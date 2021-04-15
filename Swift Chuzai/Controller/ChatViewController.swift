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
    
    //構造体Message型が入る配列
    var messages:[Message] = []
    
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
    
    //ロード　Firebaseの全メッセージ取得
    func loadMessages(roomName:String){
        
        db.collection(roomName).order(by: "date").addSnapshotListener { (snapShot, error) in
            
            self.messages = []
            
            if error != nil{
                
                print(error.debugDescription)
                return
                
            }
            
            //firebaseのsnapShotにはbody等入っている documentはその塊
            if let snapShotDoc = snapShot?.documents{
                
                //for文
                for doc in snapShotDoc{
                    
                    //doc.dataでbodyやdateが入る
                    let data = doc.data()
                    //必要なデータを取得
                    if let sender = data["sender"] as? String, let body = data["body"] as? String, let imageString = data["imageString"] as? String{
                        
                        //構造体Messageにセットでデータを格納
                        let newMessage = Message(sender: sender, body: body, imageString: imageString)
                        
                        self.messages.append(newMessage)
                        
                        DispatchQueue.main.async {
                            
                            //TableViewにメッセージを取得
                            self.tableView.reloadData()
                            let indexPath = IndexPath(row: self.messages.count - 1, section: 0)
                            //メッセージ送信後にそのメッセージが一番下に来るようにスクロール
                            self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
                        }
                        
                    }
                    
                }
                
            }
            
        }
        
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
