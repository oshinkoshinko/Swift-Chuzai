//
//  EachUserViewController.swift
//  Swift Chuzai
//
//  Created by 岡真也 on 2021/04/30.
//

import UIKit
import Firebase
import FirebaseFirestore
import FirebaseStorage

class EachUserViewController: UIViewController {

    var imageUrl = String()
    
    @IBOutlet weak var profile: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    @IBOutlet weak var introductionLabel: UILabel!
    
    let db = Firestore.firestore()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        print("岡真也 imageUrl")
        print(imageUrl)
        
        
        // Do any additional setup after loading the view.
    }
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//
        self.navigationController?.isNavigationBarHidden = false
        loadUser()

//        //ユーザ情報取得
//        let user = Auth.auth().currentUser
//        if let user = user {
//
//            let userID = user.uid
//            let ref = db.collection("User").document(userID)
//
//            ref.getDocument{ [self] (document, error) in
//                if let document = document {
//                    let data = document.data()
//                    let name = data!["userName"]
//                    self.userNameLabel.text = name as! String
//                    let number = data!["phoneNumber"]
//                    self.phoneNumberLabel.text = number as! String
//                    let introduction = data!["introduction"]
//                    self.introductionLabel.text = introduction as! String
//                    let imageString = data!["imageString"]
//                    self.profile.sd_setImage(with: URL(string: imageString as! String), completed: nil)
//                }else{
//                    print("Document does not exist")
//                }
//            }
//            let email = user.email
//            emailLabel.text = email
//
//
//        }
//
    }
    
    //ロード　Firebaseの全メッセージ取得
    func loadUser(){
        
        let userRef = db.collection("User")
        let thisUserRef = userRef.whereField("imageString", isEqualTo: imageUrl)
        
        print("イメージurl")
        print(imageUrl)
        
        thisUserRef.getDocuments { [self] (querySnapshot, error) in
            
            if error != nil {
                
                print("エラーです")
                return
                
            }else{
            
                for document in querySnapshot!.documents {
                
                let data = document.data()
                    self.userNameLabel.text = data["userName"] as? String
                    self.phoneNumberLabel.text = data["phoneNumber"] as? String
                    self.introductionLabel.text = data["introduction"] as? String
                    self.profile.sd_setImage(with: URL(string: imageUrl as! String), completed: nil)
                    
                print("あいう")
                print(data)
                print(data["userName"] as? String)
                
                }
            }
//            let datas = _snapshot!.documents.compactMap { $0.data() }
//            print(datas)
            
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
