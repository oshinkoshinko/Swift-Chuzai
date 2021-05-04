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
    var uid = String()
    
    @IBOutlet weak var profile: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    @IBOutlet weak var introductionLabel: UILabel!
    
    let db = Firestore.firestore()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadUser()

        // Do any additional setup after loading the view.
    }
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.navigationController?.isNavigationBarHidden = false
        
    }
    
    func loadUser(){
        
        let userRef = db.collection("User")

        let thisUserRef = userRef.whereField("uid", isEqualTo: uid)
        
        print("送信者")
        print(uid)
        
        
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
                    
                }
            }
            
        }
        
    }
    
    //電話発信
    @IBAction func call(_ sender: Any) {
        print(phoneNumberLabel.text)
        UIApplication.shared.open(URL(string: "tel://\(phoneNumberLabel.text)")!, options: [:], completionHandler: nil)
        
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
