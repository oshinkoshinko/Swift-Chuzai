//
//  UserEditViewController.swift
//  Swift Chuzai
//
//  Created by 岡真也 on 2021/04/28.
//

import UIKit
import Firebase
import FirebaseFirestore
import SDWebImage

class UserEditViewController: UIViewController {

    let db = Firestore.firestore()
    
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var numberTextField: UITextField!
    @IBOutlet weak var introductionTextField: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //ユーザ情報取得
        let user = Auth.auth().currentUser
        if let user = user {

            let userID = user.uid
            let ref = db.collection("User").document(userID)

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
    
    
    @IBAction func update(_ sender: Any) {
        
        let user = Auth.auth().currentUser
        guard let userID = user?.uid else { fatalError() }
        let ref = db.collection("User").document(userID)
        
        ref.updateData(["userName":userNameTextField.text as Any,"email":emailTextField.text as Any,"introduction":introductionTextField.text as Any,"phoneNumber":numberTextField.text as Any])
        { err in if let err = err{
            print("Error adding document: \(err)")
        } else {
            print("Document added with ID: \(ref.documentID)")
        }}
        
        
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
