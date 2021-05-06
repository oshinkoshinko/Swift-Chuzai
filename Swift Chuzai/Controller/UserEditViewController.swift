//
//  UserEditViewController.swift
//  Swift Chuzai
//
//  Created by 岡真也 on 2021/04/28.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore
import SDWebImage

class UserEditViewController: UIViewController,UIImagePickerControllerDelegate,UITextFieldDelegate, UITextViewDelegate, UINavigationControllerDelegate,SendProfileOKDelegate {


    let db = Firestore.firestore()
    
    var sendToDBModel = SendToDBModel()
    var urlString = String()
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var numberTextField: UITextField!
    @IBOutlet weak var introductionTextField: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        profileImage.layer.cornerRadius = profileImage.frame.height/2
        
        introductionTextField.layer.cornerRadius = 5
        
        userNameTextField.delegate = self
        emailTextField.delegate = self
        numberTextField.delegate = self
        introductionTextField.delegate = self
        
        sendToDBModel.sendProfileOKDelegate = self
        
        //ユーザ情報取得
        let user = Auth.auth().currentUser
        if let user = user {

            let userID = user.uid
            let ref = db.collection("User").document(userID)
            
            //フォームに登録値入力
            ref.getDocument{ [self] (document, error) in
                if let document = document {
                    let data = document.data()
                    
                    let name = data!["userName"]
                    self.userNameTextField.text = name as! String
                    
                    let number = data!["phoneNumber"]
                    self.numberTextField.text = number as! String
                   
                    let introduction = data!["introduction"]
                    self.introductionTextField.text = introduction as! String
                    
                    let imageString = data!["imageString"]
                    self.profileImage.sd_setImage(with: URL(string: imageString as! String), completed: nil)
                    
                }else{
                    print("Document does not exist")
                }
            }
            
            let email = user.email
            emailTextField.text = email
            
            
        }
        
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.isNavigationBarHidden = false
        
    }
    
    //入力後にキーボードを閉じる
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        emailTextField.resignFirstResponder()
        userNameTextField.resignFirstResponder()
        numberTextField.resignFirstResponder()
        introductionTextField.resignFirstResponder()
        
    }
    
    
    //更新アクション
    @IBAction func update(_ sender: Any) {
        
        let image = profileImage.image
        //UIImageをデータ型へ
        let data = image!.jpegData(compressionQuality: 1.0)
        //登録したプロフ写真をFirebaseStorageへ送信
        self.sendToDBModel.sendProfileImageData(data: data!)
        
        
        let user = Auth.auth().currentUser
        guard let userID = user?.uid else { fatalError() }
        let ref = db.collection("User").document(userID)
        
        ref.updateData(["userName":userNameTextField.text as Any,"introduction":introductionTextField.text as Any,"phoneNumber":numberTextField.text as Any])
        { err in if let err = err{
            print("Error adding document: \(err)")
        } else {
            print("Document added with ID: \(ref.documentID)")
        }}
        
        user?.updateEmail(to: emailTextField.text!, completion: { (error) in
            
            if let error = error{
              print(error.localizedDescription)
            }
            
        })
        
        //前画面へ遷移
        if urlString.isEmpty != true{

            self.navigationController?.popViewController(animated: true)

            
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
        
    }
    
    
    //プロフ写真
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
            profileImage.image = selectedImage
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
