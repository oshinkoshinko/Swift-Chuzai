//
//  AnimationViewController.swift
//  Swift Chuzai
//
//  Created by 岡真也 on 2021/05/01.
//

import UIKit
import Lottie

class AnimationViewController: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var scrollView: UIScrollView!
    
    
    var onboardArray = ["1","2","3","4","5"]
    var onboardStringArray = ["ようこそ、Chuzaiへ\nあなたの駐在国の仲間と繋がりましょう！","ログイン後に全体チャットで挨拶してみよう！","各国のチャットルームで情報交換ができます！","各国の最新ニュースがすぐに分かる！","仲間に電話ができる！"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //スクロールビューのページング
        scrollView.isPagingEnabled = true
        setUpScroll()
        
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.isNavigationBarHidden = false
        
    }
    

    func setUpScroll(){
        
        scrollView.delegate = self
        
        //横長のページを5分割して表示するイメージ　5ページ分なので*5
        scrollView.contentSize = CGSize(width:view.frame.size.width * 5, height: scrollView.frame.size.height)
        
        for i in 0...4 {
            
            //x軸は画面の左端を始点として考える
            let onboardLabel = UILabel(frame: CGRect(x: CGFloat(i) * view.frame.size.width, y: view.frame.size.height/3, width: scrollView.frame.size.width, height: scrollView.frame.size.height))
            onboardLabel.font = UIFont.boldSystemFont(ofSize: 15.0)
            onboardLabel.textAlignment = .center
            onboardLabel.text = onboardStringArray[i]
            scrollView.addSubview(onboardLabel)
            
            
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
