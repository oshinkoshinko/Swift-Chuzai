//
//  UserListViewController.swift
//  Swift Chuzai
//
//  Created by 岡真也 on 2021/05/08.
//

import UIKit
import Firebase
import SDWebImage

class UserListViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    

    @IBOutlet weak var collectionView: UICollectionView!
    
    //構造体User型が入る配列
    var users:[User] = []
    
    let db = Firestore.firestore()
    
    var imageURL = String()
    var uid = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        self.navigationItem.title = "すべてのユーザー"
        
        // セルのレイアウトを設定
                let flowLayout : UICollectionViewFlowLayout = UICollectionViewFlowLayout()
                // セルのサイズ
                flowLayout.itemSize = CGSize(width: 120.0, height: 120.0)
                // 縦・横のスペース
        flowLayout.minimumLineSpacing = -30.0
        flowLayout.minimumInteritemSpacing = 0.0
                //  スクロールの方向
        flowLayout.scrollDirection = UICollectionView.ScrollDirection.vertical
                // 設定内容を反映させる
                self.collectionView.collectionViewLayout = flowLayout
                // 背景色を設定
                self.collectionView?.backgroundColor =  UIColor.white
        
        loadUserData()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.isNavigationBarHidden = false
        
        
    }
    
    
    func loadUserData(){
        
        db.collection("User").addSnapshotListener { [self] (snapShot, error) in
            
            self.users = []
            
            if error != nil{
                
                print(error.debugDescription)
                return
                
            }
            
            print("あいうえおおおおおお")
            //firebaseのsnapShotにデータ入っている documentはその塊
            if let snapShotDoc = snapShot?.documents{
                
                print("かきくけこおおおおお")
                print(snapShotDoc)
                //for文
                for doc in snapShotDoc{
                    
                    //doc.dataでbodyやdateが入る
                    let data = doc.data()
                                        
                    //必要なデータを取得
                    if let userName = data["userName"] as? String,let imageString = data["imageString"] as? String, let uid = data["uid"] as? String, let country = data["country"] as? String{
                                                
                        //構造体Userにセットでデータを格納
                        let newUser = User(userName: userName, imageString: imageString, uid: uid, country: country)
                        
                        self.users.append(newUser)
                        
                        DispatchQueue.main.async {
                            
                            //CollectionViewにデータを取得
                            self.collectionView.reloadData()
                            let indexPath = IndexPath(row: self.users.count - 1, section: 0)
 
                        }
                        
                    }
                    
                }
                
            }
            
        }
        
        
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return 1
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return users.count
        
    }
    
    //セルの中身
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        
        let contentImageView = cell.contentView.viewWithTag(1) as! UIImageView
        contentImageView.sd_setImage(with: URL(string: users[indexPath.row].imageString), completed: nil)
        contentImageView.layer.cornerRadius = contentImageView.frame.height/2
        let nameLabel = cell.contentView.viewWithTag(2) as! UILabel
        nameLabel.text = String(users[indexPath.row].userName)
        let countryLabel = cell.contentView.viewWithTag(3) as! UILabel
        countryLabel.text = users[indexPath.row].country
        
        return cell
        
    }
    
    //アイテムの選択　画面遷移
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        imageURL = users[indexPath.row].imageString
        uid = users[indexPath.row].uid
        
        //セルの選択解除
        collectionView.deselectItem(at: indexPath, animated: true)
        
        let eachUserVC = storyboard?.instantiateViewController(identifier: "eachUserVC") as! EachUserViewController
        
        //画像url受け渡し
        eachUserVC.imageUrl = imageURL
        //送信者uid受け渡し
        eachUserVC.uid = uid
        navigationController?.pushViewController(eachUserVC, animated: true)
        
        
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
