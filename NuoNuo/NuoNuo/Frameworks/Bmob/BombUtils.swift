//
//  BombUtils.swift
//  NuoNuo
//
//  Created by ruby on 16/8/10.
//  Copyright © 2016年 ruby. All rights reserved.
//

import Foundation

/**
 检查手机号是否已经注册
 
 - parameter phone:  待检手机号
 - parameter result: 结果回调函数
 */
func isUserRegisted(phone: String, result: ((registed: Bool) -> Void)) -> Void {
    let bquery = BmobUser.query()
    bquery.whereKey("mobilePhoneNumber", equalTo: phone)
    
    bquery.findObjectsInBackgroundWithBlock { (array, error) in
        result(registed: !array.isEmpty)
    }
}

/**
 检查用户名是否已被占用
 
 - parameter name:   待查询的用户名
 - parameter result: 结果回调函数
 */
func isNickNameReserved(name: String, result: ((reserved: Bool) -> Void)) -> Void {
    let bquery = BmobUser.query()
    bquery.whereKey("username", equalTo: name)
    
    bquery.findObjectsInBackgroundWithBlock { (array, error) in
        result(reserved: !array.isEmpty)
    }
}

func uploadAvatar(image: UIImage, phone: String, result: ((url: String) -> Void)) -> Void {
    let imageData = ImageHandler().getImageBinary(image, compressionQuality: 1.0)
    if(imageData.data == nil) {
        return
    }
    let imageName = phone + "." + imageData.mine!
    
    //let obj = BmobObject(className: "_User")
    let bombFile = BmobFile(fileName: imageName, withFileData: imageData.data)
    
    bombFile.saveInBackground { (successful, error) in
        if(successful) {
            print("上传成功： \(bombFile.url)")
            result(url: bombFile.url)
        }
    }
}