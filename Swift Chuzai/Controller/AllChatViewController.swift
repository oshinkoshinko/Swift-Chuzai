//
//  AllChatViewController.swift
//  Swift Chuzai
//
//  Created by 岡真也 on 2021/04/27.
//

import UIKit
import Firebase
import SDWebImage

class AllChatViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageTextField: UITextField!
    let db = Firestore.firestore()
    
    var roomName = String()
    var imageString = String()
    
    //構造体Message型が入る配列
    var messages:[Message] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(UINib(nibName: "MessageCell", bundle: nil), forCellReuseIdentifier: "Cell")
        
        //userimageにurlが入っていたら
        if UserDefaults.standard.object(forKey: "userImage") != nil{
            
            //imageStringにurlを文字列型で格納
            imageString = UserDefaults.standard.object(forKey: "userImage") as! String
            
        }
        //ルーム名なし==全体チャット
        if roomName == ""{
            
            roomName = "All"
            
        }
        
        self.navigationItem.title = roomName
        
        loadMessages(roomName: roomName)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.isNavigationBarHidden = true
        
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
    
    //セルの数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        //メッセージの数
        return messages.count
        
    }
    
    //セクションの数
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    //セルの中身
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! MessageCell
        
        let message = messages[indexPath.row]
        cell.label.text = message.body
        
        if message.sender == Auth.auth().currentUser?.email{
            
            //ユーザのメッセージであれば右側アイコンのみ表示
            cell.leftImageView.isHidden = true
            cell.rightImageView.isHidden = false
            //アイコンをセット
            cell.rightImageView.sd_setImage(with: URL(string: imageString), completed: nil)
            cell.leftImageView.sd_setImage(with: URL(string: messages[indexPath.row].imageString), completed: nil)
            //セルの色分け
            cell.backView.backgroundColor = .systemTeal
            cell.label.textColor = .white

        }else{
            
            //別ユーザのメッセージであれば左側アイコンのみ表示
            cell.leftImageView.isHidden = false
            cell.rightImageView.isHidden = true
            //アイコンをセット
            cell.rightImageView.sd_setImage(with: URL(string: imageString), completed: nil)
            cell.leftImageView.sd_setImage(with: URL(string: messages[indexPath.row].imageString), completed: nil)
            //セルの色分け
            cell.backView.backgroundColor = .orange
            cell.label.textColor = .white
            
        }
        
        return cell
        
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
