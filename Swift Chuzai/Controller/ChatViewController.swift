//
//  ChatViewController.swift
//  Swift Chuzai
//
//  Created by 岡真也 on 2021/04/15.
//

import UIKit
import Firebase
import SDWebImage

class ChatViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageTextField: UITextField!
    let db = Firestore.firestore()
    
    var roomName = String()
    var imageString = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        //userimageにurlが入っていたら
        if UserDefaults.standard.object(forKey: "userimage") != nil{
            
            //ImageStringにurlを文字列型で格納
            imageString = UserDefaults.standard.object(forKey: "userimage") as! String
            
        }
        //ルーム名なし==全体チャット
        if roomName == ""{
            
            roomName = "All"
            
        }
        
        self.navigationItem.title = roomName
        

    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        <#code#>
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        <#code#>
    }
    
    @IBAction func send(_ sender: Any) {
        
        if let messageBody = messageTextField.text,let sender = Auth.auth().currentUser?.email{
            
            //Firebase内のデータを辞書型で取得
            db.collection(roomName).addDocument(data: ["sender":sender,"body":messageBody,"imageString":imageString,"date":Date().timeIntervalSince1970]) { (error) in
                
                if error != nil{
                    
                    print(error.debugDescription)
                    return
                    
                }
                
                //非同期処理
                DispatchQueue.main.async{
                    //送信後はフォームを空にする
                    self.messageTextField.text = ""
                    //キーボードを閉じる
                    self.messageTextField.resignFirstResponder()
                }
            }
            
        }
        
    }
    
    
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
