//
//  CheckPermission.swift
//  Swift Chuzai
//
//  Created by 岡真也 on 2021/04/15.
//

import Foundation
import Photos

class CheckPermission {
    
    func showCheckPermission(){
        PHPhotoLibrary.requestAuthorization { (status) in
            
            switch(status){
                
            case .authorized:
                print("許可されてます")

            case .denied:
                    print("拒否")

            case .notDetermined:
                        print("notDetermined")
                
            case .restricted:
                        print("restricted")
                
            case .limited:
                print("limited")
            @unknown default: break
                
            }
            
        }
    }

}
