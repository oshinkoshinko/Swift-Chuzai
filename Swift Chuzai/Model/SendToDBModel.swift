//
//  SendToDBModel.swift
//  Swift Chuzai
//
//  Created by 岡真也 on 2021/04/15.
//

import Foundation
import FirebaseStorage

protocol SendProfileOKDelegate{
    
    func sendProfileOKDelegate(url:String)
    
    
}

class SendToDBModel {
    
    
    var sendProfileOKDelegate:SendProfileOKDelegate?
    
    
    init(){
        
        
    }
    
    //データが渡ってくる
    func sendProfileImageData(data:Data){
        
        //データ型で渡ってきた値をUIImage型に変換
        let image = UIImage(data: data)
        //Jpegに圧縮 データ型
        let profileImageData = image?.jpegData(compressionQuality: 0.1)
        
        //ストレージサーバの保存先を決める "profileImage"がフォルダ名　"~.jpg"が保存命名形式
        let imageRef = Storage.storage().reference().child("profileImage").child("\(UUID().uuidString + String(Date().timeIntervalSince1970)).jpg")
        
         //渡ってきたデータをFirebasestorageに置く
        imageRef.putData(profileImageData!, metadata: nil) { (metaData, error) in
            
            if error != nil{
                print(error.debugDescription)
                return
            }
            
            //FirebaseStorageからURLが返ってくる
            imageRef.downloadURL { (url, error) in
                
            if error != nil{
                print(error.debugDescription)
                return
                
            }
                //アプリ側にキー値"userImage"としてurlを保存
                UserDefaults.standard.setValue(url?.absoluteString, forKey: "userImage")
                //委任先であるRegisterVCへ
                self.sendProfileOKDelegate?.sendProfileOKDelegate(url: url!.absoluteString)
            
            }
        
        }
    
    }
}
