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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        self.navigationItem.title = "すべてのユーザー"
        
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
                            
                            //TableViewにメッセージを取得
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
        
        
        return cell
        
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
