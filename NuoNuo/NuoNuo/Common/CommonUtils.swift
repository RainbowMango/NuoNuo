//
//  CommonUtils.swift
//  NuoNuo
//
//  Created by ruby on 16/9/5.
//  Copyright © 2016年 ruby. All rights reserved.
//

import Foundation

/**
 获取当前时间，精确到毫秒
 
 - returns: <#return value description#>
 */
func getCurrTime() -> String {
    let dateFormatter = NSDateFormatter()
    dateFormatter.dateFormat = "yyyyMMddHHmmssSSS"
    let date          = NSDate()
    
    return dateFormatter.stringFromDate(date)
}
