//
//  WebViewController.swift
//  Swift Chuzai
//
//  Created by 岡真也 on 2021/04/16.
//

import UIKit
import WebKit

class WebViewController: UIViewController,WKUIDelegate {
    
    var webView = WKWebView()

    override func viewDidLoad() {
        super.viewDidLoad()

        //webViewのサイズ
        webView.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height - 50)
        view.addSubview(webView)

        //"url"というキー値で保存されているものをいれる Page1Table
        let urlString = UserDefaults.standard.object(forKey: "url")
        //URL型にキャスト Anyで保存されているので何型かわかっていないので as! 型で指定
        let url = URL(string: urlString! as! String)
        //urlをリクエスト
        let request = URLRequest(url: url!)
        webView.load(request)

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
