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
        
        profile.layer.cornerRadius = profile.frame.height/2
        
        loadUser()

        // Do any additional setup after loading the view.
    }
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.navigationController?.isNavigationBarHidden = false
        // ナビゲーションバーの透明化
        // 半透明の指定（デフォルト値）
        self.navigationController?.navigationBar.isTranslucent = true
        // 空の背景画像設定
        self.navigationController!.navigationBar.setBackgroundImage(UIImage(), for: .default)
        // ナビゲーションバーの影画像を空に設定
        self.navigationController!.navigationBar.shadowImage = UIImage()
        
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
        
        let url = NSURL(string: "tel://\(phoneNumberLabel.text!)")!
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url as URL)
        } else {
            UIApplication.shared.openURL(url as URL)
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
