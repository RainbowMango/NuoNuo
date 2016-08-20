//
//  BombUtils.swift
//  NuoNuo
//
//  Created by ruby on 16/8/10.
//  Copyright © 2016年 ruby. All rights reserved.
//

import Foundation

/// 用户头像表
let BOMB_USER_AVATAR_TABLE = "userAvatar"
let BOMB_USER_AVATAR_COLUMN_KEY = "mobilePhoneNumber"
let BOMB_USER_AVATAR_COLUMN_URL = "avatarURL"


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

/**
 查询用户头像是否已经存在
 
 - parameter phone:  用户手机号
 - parameter result: 查询结果回调函数
 */
func isAvatarExist(phone: String, result: ((exist: Bool) -> Void)) -> Void {
    let bquery = BmobQuery(className: BOMB_USER_AVATAR_TABLE)
    bquery.whereKey(BOMB_USER_AVATAR_COLUMN_KEY, equalTo: phone)
    
    bquery.findObjectsInBackgroundWithBlock { (array, error) in
        result(exist: !array.isEmpty)
    }
}

/**
 创建用户头像，适用于首次添加用户头像
 
 - parameter image:  用户头像
 - parameter phone:  用户手机号，将用户数据表主键
 - parameter result: 添加结果回调函数，添加成功返回文件url，失败返回空
 */
func bombAddAvatar(image: UIImage, phone: String, result: ((url: String) -> Void)) -> Void {
    let imageData = ImageHandler().getImageBinary(image, compressionQuality: 1.0)
    if(imageData.data == nil) {
        print("bombAddAvatar: 转换图片失败")
        return
    }
    let imageName = phone + "." + imageData.mine!
    
    let obj = BmobObject(className: BOMB_USER_AVATAR_TABLE)
    let bombFile = BmobFile(fileName: imageName, withFileData: imageData.data)
    
    bombFile.saveInBackground { (successful, error) in
        if(successful) {
            obj.setObject(phone, forKey: BOMB_USER_AVATAR_COLUMN_KEY)
            obj.setObject(bombFile.url, forKey: BOMB_USER_AVATAR_COLUMN_URL)
            obj.saveInBackgroundWithResultBlock({ (addSuccess, addError) in
                if(addError != nil) {
                    print("bombAddAvatar: 添加数据失败: \(addError.localizedDescription)")
                    result(url: String())
                    return
                }
                result(url: bombFile.url)
            })
        }
    }
}

func bombUpdateAvatar(image: UIImage, phone: String, result: ((url: String) -> Void)) -> Void {
    let imageData = ImageHandler().getImageBinary(image, compressionQuality: 1.0)
    if(imageData.data == nil) {
        print("bombAddAvatar: 转换图片失败")
        return
    }
    let imageName = phone + "." + imageData.mine!
    
    let bombFile = BmobFile(fileName: imageName, withFileData: imageData.data)
    
    bombFile.saveInBackground { (successful, error) in
        if(successful) {
            let bquery = BmobQuery(className: BOMB_USER_AVATAR_TABLE)
            bquery.whereKey(BOMB_USER_AVATAR_COLUMN_KEY, equalTo: phone)
            
            bquery.findObjectsInBackgroundWithBlock({ (objectArray, searchError) in
                if(objectArray.isEmpty) {
                    print("bombUpdateAvatar: No such object find.")
                    result(url: String())
                    return
                }
                if(objectArray.count > 1) {
                    print("bombUpdateAvatar: More than one object to be updated.")
                    result(url: String())
                    return
                }
                
                let targetObject = objectArray.first
                targetObject?.setObject(bombFile.url, forKey: BOMB_USER_AVATAR_COLUMN_URL)
                targetObject?.updateInBackgroundWithResultBlock({ (uSuccess, uError) in
                    if(uError != nil) {
                        print("bombUpdateAvatar: Update failed: \(uError.localizedDescription).")
                        result(url: String())
                        return
                    }
                    
                    result(url: bombFile.url)
                })
            })
        }
    }
}

func uploadAvatar(image: UIImage, phone: String, result: ((url: String) -> Void)) -> Void {
    
    isAvatarExist(phone) { (exist) in
        if(!exist) {
            //新用户首次添加头像
            bombAddAvatar(image, phone: phone, result: result)
        }
        
        //更新用户头像
        bombUpdateAvatar(image, phone: phone, result: result)
        
        //删除用户原头像文件
        //TODO
    }
    
}