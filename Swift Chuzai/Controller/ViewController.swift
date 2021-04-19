//
//  ViewController.swift
//  Swift Chuzai
//
//  Created by 岡真也 on 2021/04/15.
//

import UIKit
import Firebase

class ViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }


    @IBAction func login(_ sender: Any) {
        
        let email = emailTextField.text
        let password = passwordTextField.text
        
        Auth.auth().signIn(withEmail: email!, password: password!) { [weak self] result, error in
            guard let self = self else { return }
            if let user = result?.user{
                //次の画面へ
                self.performSegue(withIdentifier: "chat", sender: nil)
            }
            //エラー
        }
        
        
    }
    
    
    @IBAction func logout(_ sender: Any) {
        
        do {
            try Auth.auth().signOut()
            print("ログアウトしました。")
        } catch let error {
            print("ログアウトできませんでした。")
        }
        
    }
    
}

