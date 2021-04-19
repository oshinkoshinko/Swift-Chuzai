//
//  RoomViewController.swift
//  Swift Chuzai
//
//  Created by 岡真也 on 2021/04/16.
//

import UIKit
import ViewAnimator //tableviewのアニメーション用

class RoomViewController: UIViewController,UITableViewDataSource,UITableViewDelegate{

    
    var roomNameArray = ["🇺🇸アメリカ","🇨🇳中国","🇦🇺オーストラリア","🇹🇭タイ","🇨🇦カナダ","🇬🇧イギリス","🇧🇷ブラジル","🇩🇪ドイツ","🇫🇷フランス"]
    
    var roomImageStringArray = ["0","1","2","3","4","5","6","7","8","9"]
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.setNavigationBarHidden(false, animated: false)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isHidden = true
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableView.isHidden = false
        
        let animation = [AnimationType.vector(CGVector(dx: 0, dy: 30))]
        UIView.animate(views: tableView.visibleCells, animations:animation,completion:nil)
        
    }
    
    //セルの数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return roomNameArray.count
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
        
    }
    
    //セルの中身
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "RoomCell", for: indexPath)
        
        let imageView = cell.contentView.viewWithTag(1) as! UIImageView
        imageView.image = UIImage(named: roomImageStringArray[indexPath.row])
        
        let label = cell.contentView.viewWithTag(2) as! UILabel
        label.text = roomNameArray[indexPath.row]
        
        return cell
    }
    
    //セルの高さ
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 102
        
    }
    
    //セルがタップされた時
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "roomChat", sender: indexPath.row)
        
    }
    
    //didSelectRowAtでsenderに渡された値がsenderに入ってる
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let roomChatVC = segue.destination as! ChatViewController
        roomChatVC.roomName = roomNameArray[sender as! Int]
        
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
