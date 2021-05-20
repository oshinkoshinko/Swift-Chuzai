//
//  MypageViewController.swift
//  Swift Chuzai
//
//  Created by 岡真也 on 2021/04/27.
//

import UIKit
import Firebase
import FirebaseFirestore
import SDWebImage

class MypageViewController: UIViewController {

    
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var countryLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    @IBOutlet weak var introductionLabel: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        profileImage.layer.cornerRadius = profileImage.frame.height/2
        
        countryLabel.layer.cornerRadius = 5
        countryLabel.clipsToBounds = true
        emailLabel.layer.cornerRadius = 5
        emailLabel.clipsToBounds = true
        userNameLabel.layer.cornerRadius = 5
        userNameLabel.clipsToBounds = true
        phoneNumberLabel.layer.cornerRadius = 5
        phoneNumberLabel.clipsToBounds = true
        introductionLabel.layer.cornerRadius = 5
        introductionLabel.clipsToBounds = true

        
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.isNavigationBarHidden = true
        
        //ユーザ情報取得  編集後に再描画する必要あるためviewWillAppear
        let user = Auth.auth().currentUser
        if let user = user {

            let userID = user.uid
            let ref = db.collection("User").document(userID)

            ref.getDocument{ [self] (document, error) in
                if let document = document {
                    let data = document.data()
                    let name = data!["userName"]
                    self.userNameLabel.text = name as! String
                    let country = data!["country"]
                    self.countryLabel.text = country as! String
                    let number = data!["phoneNumber"]
                    self.phoneNumberLabel.text = number as! String
                    let introduction = data!["introduction"]
                    self.introductionLabel.text = introduction as! String
                    let imageString = data!["imageString"]
                    self.profileImage.sd_setImage(with: URL(string: imageString as! String), completed: nil)
                }else{
                    print("Document does not exist")
                }
            }
            let email = user.email
            emailLabel.text = email
            
            
        }
        
    }
    
    
    
    @IBAction func edit(_ sender: Any) {
        
        self.performSegue(withIdentifier: "userEdit", sender: nil)
        
    }
    
    
    
    @IBAction func logout(_ sender: Any) {
        

        do {
            try Auth.auth().signOut()
            print("ログアウトしました。")
            
        } catch let error {
            print("ログアウトできませんでした。")
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
