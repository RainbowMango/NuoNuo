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


/// 用户表
let BMOB_USER_TABLE_COLUMN_EMPLOYEEID     = "employeeID"
let BMOB_USER_TABLE_COLUMN_PHONE_VERIFIED = "mobilePhoneNumberVerified"
let BMOB_USER_TABLE_COLUMN_AVATAR         = "avatar"


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

func userSignUp(phone: String, email: String, staffID: String, avatar: String, username: String, result: ((success: Bool, error: NSError?) -> Void)) -> Void {
    let user = BmobUser()
    
    user.username = username
    user.password = phone
    user.email    = email
    user.mobilePhoneNumber = phone
    user.setObject(staffID, forKey: BMOB_USER_TABLE_COLUMN_EMPLOYEEID)
    user.setObject(true, forKey: BMOB_USER_TABLE_COLUMN_PHONE_VERIFIED)
    user.setObject(avatar, forKey: BMOB_USER_TABLE_COLUMN_AVATAR)
    user.signUpInBackgroundWithBlock { (signResult, signError) in
        if(!signResult) {
            print("userSignUp: failed: \(signError.localizedDescription)")
            result(success: signResult, error: signError)
            return
        }
        
        result(success: signResult, error: nil)
    }
}

/**
 缓存用户信息到本地，方便下次登录使用
 该方法根据参数向服务器端请求完整的用户信息，然后缓存到本地。获取用户信息使用：BmobUser.currentUser()。
 
 - parameter username: 用户昵称
 - parameter password: 用户密码，本初使用手机号
 */
func cacheUserinfo(username: String, password: String) {
    BmobUser.loginWithUsernameInBackground(username, password: password)
}

/**
 判断本地是否有缓存用户信息。
 
 - returns: true(有) fasle(没有)
 */
func isUserLogined() -> Bool {
    let user = BmobUser.currentUser()
    if(user != nil) {
        return true
    }
    
    return false
}

/**
 获取用户手机号码
 
 - returns: 返回用户手机号码
 */
func getUserPhone() -> String? {
    let user = BmobUser.currentUser()
    
    if(nil != user) {
        return user.mobilePhoneNumber
    }
    
    return nil
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
    let smallImage = ImageHandler().aspectSacleSize(image, targetSize: CGSizeMake(120, 120))
    
    isAvatarExist(phone) { (exist) in
        if(!exist) {
            //新用户首次添加头像
            bombAddAvatar(smallImage, phone: phone, result: result)
            return
        }
        
        //更新用户头像
        bombUpdateAvatar(smallImage, phone: phone, result: result)
        
        //删除用户原头像文件
        //TODO
    }
    
}

func getAvatarPath(phone: String, callback: ((path: String, error: NSError) -> Void)) ->Void {
    let bquery = BmobQuery(className: BOMB_USER_AVATAR_TABLE)
    bquery.whereKey(BOMB_USER_AVATAR_COLUMN_KEY, equalTo: phone)
    
    bquery.findObjectsInBackgroundWithBlock { (array, error) in
        if(array.isEmpty) {
            callback(path: String(), error: error)
            return
        }
        let object = array[0] as! BmobObject
        let path   = object.objectForKey(BOMB_USER_AVATAR_COLUMN_URL) as! String
        callback(path: path, error: error)
    }
}

func removeAvatar(phone: String, result: ((success: Bool, error: NSError) -> Void)) -> Void {
    getAvatarPath(phone) { (path, avatarError) in
        if(path.isEmpty) {
            print("removeAvatar: remove failed: \(avatarError.localizedDescription)")
            result(success: false, error: avatarError)
            return
        }
        let bombFile = BmobFile(filePath: path)
        bombFile.deleteInBackground({ (deleteSuccess, deleteError) in
            if(!deleteSuccess) {
                print("removeAvatar: delete faile: \(deleteError.localizedDescription)")
                result(success: true, error: deleteError)
                return
            }
        })
    }
}

/**
 删除服务器存储文件
 
 - parameter path:           文件URL
 - parameter resultCallback: 删除结果回调
 */
func removeFileByPath(path: String, resultCallback: ((sucess: Bool, error: NSError) -> Void)?) -> Void {
    let bmobFile = BmobFile(filePath: path)
    bmobFile.deleteInBackground { (deleteSuccess, deleteError) in
        if(resultCallback != nil) {
            resultCallback!(sucess: deleteSuccess, error: deleteError)
        }
    }
}