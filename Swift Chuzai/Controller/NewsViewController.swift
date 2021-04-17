//
//  NewsViewController.swift
//  Swift Chuzai
//
//  Created by 岡真也 on 2021/04/16.
//

import UIKit
import SegementSlide

class NewsViewController: SegementSlideDefaultViewController{

    override func viewDidLoad() {
        super.viewDidLoad()
        
        reloadData()
        defaultSelectedIndex = 0
        
    }
    
    //ヘッダー形式
    override func segementSlideHeaderView() -> UIView {

        let headerView = UIImageView()

        headerView.isUserInteractionEnabled = true

        headerView.contentMode = .scaleAspectFill

        headerView.image = UIImage(named: "header")

        headerView.translatesAutoresizingMaskIntoConstraints = false

        let headerHeight: CGFloat

        if #available(iOS 11.0, *) {

        headerHeight = view.bounds.height/5+view.safeAreaInsets.top

        } else {

        headerHeight = view.bounds.height/5+topLayoutGuide.length

        }

        headerView.heightAnchor.constraint(equalToConstant: headerHeight).isActive = true

        return headerView

        }
        
        override var titlesInSwitcher: [String] {

        return ["World","JPN","USA","CHN","AUS","THA","CAN","UK","BRA","GER","FRA"]

        }
        
        //コントローラを返す
        override func segementSlideContentViewController(at index: Int) -> SegementSlideContentScrollViewDelegate? {

        //indexがある場合はswitch文を使う
        switch index {

        case 0:

        return Page1TableViewController()

        case 1:

        return Page2TableViewController()

        case 2:

        return Page3TableViewController()

        case 3:

        return Page4TableViewController()

        case 4:

        return Page5TableViewController()

        case 5:

        return Page6TableViewController()
            
        case 6:

        return Page7TableViewController()
            
        case 7:

        return Page8TableViewController()
            
        case 8:

        return Page9TableViewController()
            
        case 9:

        return Page10TableViewController()
            
        case 10:

        return Page11TableViewController()
            
        default:

        return Page1TableViewController()

        }





        }







        }

    //ログアウト
//    @IBAction func logout(_ sender: Any) {
//
//    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */


