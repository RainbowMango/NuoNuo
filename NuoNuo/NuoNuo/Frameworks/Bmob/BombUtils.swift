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
