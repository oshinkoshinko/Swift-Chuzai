//
//  MypageViewController.swift
//  Swift Chuzai
//
//  Created by 岡真也 on 2021/04/27.
//

import UIKit
import Firebase
import FirebaseFirestore

class MypageViewController: UIViewController {

    var imageString = String()
    
    @IBOutlet weak var profile: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    @IBOutlet weak var introductionLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        //userimageにurlが入っていたら
        if UserDefaults.standard.object(forKey: "userImage") != nil{
            
            //imageStringにurlを文字列型で格納
            imageString = UserDefaults.standard.object(forKey: "userImage") as! String
            
        }
        
        //ユーザ情報取得
        let user = Auth.auth().currentUser
        if let user = user {

            let name = user.displayName
            userNameLabel.text = name
            let email = user.email
            emailLabel.text = email
            
            
        }
   
        
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.isNavigationBarHidden = true
        
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
