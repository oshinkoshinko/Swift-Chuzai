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
    
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var startButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        emailTextField.layer.borderColor = UIColor.secondarySystemBackground.cgColor
        emailTextField.layer.borderWidth = 2.0
        emailTextField.layer.cornerRadius = 5
        
        passwordTextField.layer.borderColor = UIColor.secondarySystemBackground.cgColor
        passwordTextField.layer.borderWidth = 2.0
        passwordTextField.layer.cornerRadius = 5

        startButton.layer.borderColor = UIColor.systemTeal.cgColor
        startButton.layer.borderWidth = 2.0

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
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
    
    
}

