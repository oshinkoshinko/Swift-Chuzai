//
//  AllChatViewController.swift
//  Swift Chuzai
//
//  Created by 岡真也 on 2021/04/27.
//

import UIKit
import Firebase
import SDWebImage
import FirebaseAuth
import FirebaseStorage

class AllChatViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    

    @IBOutlet weak var backImageView: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageTextField: UITextField!
    let db = Firestore.firestore()
    
    var roomName = String()
    var imageString = String()
    
    //ログインユーザのプロフ渡す用
    var imageURL = String()
    //送信者userID受け渡す用
    var uid = String()
    
    //構造体Message型が入る配列
    var messages:[Message] = []
        
    var documentID = String()
    
    var activityIndicatorView = UIActivityIndicatorView()
    
    //背景画像用配列
    var backImageArray = ["back1","back2","back3","back4","back5","back6","back7","back8","back9","back10","back11","back12","back13","back14","back15","back16","back17","back18","back19","back20",]
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        activityIndicatorView.center = view.center
        activityIndicatorView.style = .whiteLarge
        activityIndicatorView.color = .purple

        view.addSubview(activityIndicatorView)
        
        
        
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(UINib(nibName: "MessageCell", bundle: nil), forCellReuseIdentifier: "Cell")
        
        //新規登録後、userimageにurlが入っていたら
//        if UserDefaults.standard.object(forKey: "userImage") != nil{
//
//            //imageStringにurlを文字列型で格納 アプリ内保存画像
//            imageString = UserDefaults.standard.object(forKey: "userImage") as! String
            

            
            let user = Auth.auth().currentUser
            let userID = user!.uid
            let ref = db.collection("User").document(userID)
            
            //ルーム名なし==全体チャット
            if roomName == ""{
                
                roomName = "All"
                
            }
            
            ref.getDocument{ [self] (document, error) in
                if let document = document {
                    let data = document.data()
                    let loginImageString = data!["imageString"]
                    
                    if loginImageString as! String != imageString{
                        
                        imageString = loginImageString as! String
                        
                        self.navigationItem.title = roomName
                        
                        loadMessages(roomName: roomName)
                        
                    } else {
                        
                        
                        self.navigationItem.title = roomName
                        
                        loadMessages(roomName: roomName)
                        
                    }
                }
            }
//        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        backImageView.image = UIImage(named: backImageArray.randomElement()!)
        
        self.navigationController?.isNavigationBarHidden = true
        
        tableView.reloadData()
        self.navigationItem.title = roomName
        loadMessages(roomName: roomName)
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
                    if let sender = data["sender"] as? String, let body = data["body"] as? String, let imageString = data["imageString"] as? String, let documentID = data["documentID"] as? String, let uid = data["uid"] as? String{
                        
                        //構造体Messageにセットでデータを格納
                        let newMessage = Message(sender: sender, body: body, imageString: imageString, documentID: documentID, uid: uid)
                        
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
        
        if let messageBody = messageTextField.text,let sender = Auth.auth().currentUser?.email,let uid = Auth.auth().currentUser?.uid{
            
            //Firebase内にデータを辞書型で追加
            var ref: DocumentReference? = nil
            
            ref = db.collection(roomName).addDocument(data: ["sender":sender,"body":messageBody,"imageString":imageString,"uid":uid,"date":Date().timeIntervalSince1970,"documentID":""]) { (error) in
                
                if error != nil{
                    
                    print(error.debugDescription)
                    return
                    
                } else {
                    
                    //documentIDをfirestoreに格納
                    ref!.updateData(["sender":sender,"body":messageBody,"imageString":self.imageString,"uid":uid,"date":Date().timeIntervalSince1970,"documentID":ref?.documentID])
                    
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
    
    //セルがタップされた時の処理(ユーザページへ) indexPath.rowでセルの行番号取得
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        imageURL = messages[indexPath.row].imageString
        uid = messages[indexPath.row].uid
        
        //セルの選択解除
        tableView.deselectRow(at: indexPath, animated: true)
        
        let eachUserVC = storyboard?.instantiateViewController(identifier: "eachUserVC") as! EachUserViewController
        
        //送信者uid受け渡し
        eachUserVC.uid = uid
        navigationController?.pushViewController(eachUserVC, animated: true)

    }
    

    //メッセージ削除アクション
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        //指定セルのdocumentIDを取得
        print(indexPath.row)
        let message = messages[indexPath.row]
        let documentID = message.documentID
        print("構造体に格納したdocumentId")
        print(documentID)
        print(message.sender)
            
        let messageRef = db.collection(roomName)
        let thisMessageRef = messageRef.whereField("documentID", isEqualTo: documentID)
        
        thisMessageRef.getDocuments { [self] (querySnapshot, error) in
            
            if error != nil {
                
                print("エラーです")
                return
                
            }else{
                        
                    for document in querySnapshot!.documents {
                        print("削除id")
                        print(document.documentID)
                        self.documentID = document.documentID
                        
                }
            }
        }
        
        
        //削除アクション時の処理
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete", handler: { [self]
            action, sourceView, completionHolder in
            
            //firestoreから削除
            db.collection(roomName).document(self.documentID).delete() { err in
                
                if let err = err {
                    print("削除できませんでした")
                } else {
                    print("削除できました")
                }
                
            }
            
                //messagesの配列からも削除 => セルの数とデータの数を合わせる
                messages.remove(at: indexPath.row)
                //セルを削除
                tableView.deleteRows(at: [indexPath], with: .automatic)
                completionHolder(true)
            
        })
        
        let user = Auth.auth().currentUser
        
        if message.sender == user?.email{
            //ボタンの見た目
            let deleteImage = UIImage(systemName: "trash.fill")?.withTintColor(UIColor.lightGray, renderingMode: .alwaysOriginal)
            deleteAction.image = deleteImage
            deleteAction.backgroundColor = UIColor(red: 255/255, green: 0/255, blue: 0/255, alpha: 1)
            
            let swipeAction = UISwipeActionsConfiguration(actions: [deleteAction])
            
            return swipeAction
            
        } else {
            
            return nil
        
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
