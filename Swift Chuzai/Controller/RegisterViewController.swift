//
//  RegisterViewController.swift
//  Swift Chuzai
//
//  Created by 岡真也 on 2021/04/15.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore

class RegisterViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate,SendProfileOKDelegate,UITextFieldDelegate {

    

    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var countryTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var profileImageView: UIImageView!
    
    var sendToDBModel = SendToDBModel()
    var urlString = String()
    var imageString = String()
    
    //ユーザデータ保存用
    let db = Firestore.firestore()
    var idString = String()
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        
        //カメラ許可画面を出す
        let checkModel = CheckPermission()
        checkModel.showCheckPermission()
        
        sendToDBModel.sendProfileOKDelegate = self
        
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
        profileImageView.layer.cornerRadius = profileImageView.frame.height/2
        
    }
    
    //入力後にキーボードを閉じる
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        
    }
    
    
    @IBAction func register(_ sender: Any) {
        
        //各TextFieldが空でないか
        if userNameTextField.text?.isEmpty != true && countryTextField.text?.isEmpty != true && emailTextField.text?.isEmpty != true && passwordTextField.text?.isEmpty != true, let image = profileImageView.image{
            
            //FirebaseのAuthentificationに入る
            Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!) { [self] (result, error) in
                
                if error != nil{
                    
                    print(error.debugDescription)
                    return
                    
                }
                
                //UIImageをデータ型へ
                let data = image.jpegData(compressionQuality: 1.0)
                
                
                //登録したプロフ写真をFirebaseStorageへ送信
                self.sendToDBModel.sendProfileImageData(data: data!)
             
                let user = Auth.auth().currentUser
                let email = user?.email
                
                //ユーザデータ用コレクション作成
                var ref: DocumentReference? = nil
                //userIDにuidを代入
                guard let userID = user?.uid else { fatalError() }
                
                ref = db.collection("User").document(userID)
                
                ref?.setData(["userName":userNameTextField.text as Any,"country":countryTextField.text as Any,"introduction":"","phoneNumber":"" ,"uid":user?.uid as Any,"imageString":"","email":email as Any, "registerDate":Date().timeIntervalSince1970])
                { err in if let err = err{
                    print("Error adding document: \(err)")
                } else {
                    print("Document added with ID: \(ref!.documentID)")
                }}
                
            }
            
        }
        
    }
    
    func sendProfileOKDelegate(url: String) {
        
        urlString = url
        
        //プロフ画像Userコレクションに追加
        let user = Auth.auth().currentUser
        guard let userID = user?.uid else { fatalError() }
        let ref = db.collection("User").document(userID)
        
        ref.updateData(["imageString":urlString as Any])
        { err in if let err = err{
            print("Error adding document: \(err)")
        } else {
            print("Document added with ID: \(ref.documentID)")
        }}
        
        
        //firebasestoreからurlが返ってきているか
        if urlString.isEmpty != true{
            //画面遷移
            self.performSegue(withIdentifier: "chat", sender: nil)
            
        }
        
    }
    
    @IBAction func tapImageView(_ sender: Any) {
        
        //カメラかアルバムから写真を選択
        //アラートを出す
        showAlert()
    }
    
    //カメラ立ち上げメソッド
    func doCamera(){
        
        let sourceType:UIImagePickerController.SourceType = .camera
        
        //カメラ利用可能かチェック
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            
            let cameraPicker = UIImagePickerController()
            cameraPicker.allowsEditing = true
            cameraPicker.sourceType = sourceType
            cameraPicker.delegate = self
            self.present(cameraPicker, animated: true, completion: nil)
            
            
        }
        
    }
    
    //アルバム
    func doAlbum(){
        
        let sourceType:UIImagePickerController.SourceType = .photoLibrary
        
        //カメラ利用可能かチェック
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            
            let cameraPicker = UIImagePickerController()
            cameraPicker.allowsEditing = true
            cameraPicker.sourceType = sourceType
            cameraPicker.delegate = self
            self.present(cameraPicker, animated: true, completion: nil)
            
            
        }
        
    }
    
    //選択された写真
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        
        if info[.originalImage] as? UIImage != nil{
            
            let selectedImage = info[.originalImage] as! UIImage
            profileImageView.image = selectedImage
            picker.dismiss(animated: true, completion: nil)
            
        }
        
    }
    
    //キャンセルボタン
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        picker.dismiss(animated: true, completion: nil)
        
    }
    
    
    //アラート
    func showAlert(){
        
        let alertController = UIAlertController(title: "選択", message: "どちらを使用しますか?", preferredStyle: .actionSheet)
        
        let action1 = UIAlertAction(title: "カメラ", style: .default) { (alert) in
            
            self.doCamera()
            
        }
        let action2 = UIAlertAction(title: "アルバム", style: .default) { (alert) in
            
            self.doAlbum()
            
        }
        
        let action3 = UIAlertAction(title: "キャンセル", style: .cancel)
        
        
        alertController.addAction(action1)
        alertController.addAction(action2)
        alertController.addAction(action3)
        self.present(alertController, animated: true, completion: nil)
        
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
