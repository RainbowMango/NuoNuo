//
//  BmobFile.swift
//  NuoNuo
//
//  Created by ruby on 16/9/5.
//  Copyright © 2016年 ruby. All rights reserved.
//

import Foundation

/**
 保存数据文件到服务器
 
 - parameter fileName:        服务器存储的文件名
 - parameter fileData:        文件数据
 - parameter successCallback: 保存成功回调函数
 - parameter failureCallback: 保存失败回调函数
 */
func addFileWithData(fileName: String?, fileData: NSData?, successCallback: ((url: String) -> Void)?, failureCallback: (()->Void)?) -> Void {
    if(nil == fileName || nil == fileData || (fileName?.isEmpty)!) {
        print("参数非法!")
        return
    }
    
    let bmobFile = BmobFile(fileName: fileName!, withFileData: fileData!)
    let bmobCallback = { (success: Bool, error: NSError?) -> Void in
        if(success) {
            if(nil != successCallback) {
                successCallback?(url: bmobFile.url)
            }
            return
        }
        
        print("保存文件失败: \(error?.localizedDescription)")
        if(nil != failureCallback) {
            failureCallback?()
        }
    }

    bmobFile.saveInBackground(bmobCallback)
}

/**
 添加图片到服务器
 
 - parameter fileName:        图片名称
 - parameter image:           图片
 - parameter successCallback: 保存成功回调函数
 - parameter failureCallback: 保存失败回调函数
 */
func addImageToRemote(fileName: String?, image: UIImage?, successCallback: ((url: String) -> Void)?, failureCallback: (()->Void)?) -> Void {
    if(nil == fileName || nil == image || (fileName?.isEmpty)!) {
        print("参数非法!")
        return
    }
    
    let imageData = ImageHandler().getImageBinary(image!, compressionQuality: 1.0).data
    if(imageData == nil) {
        print("转换图片失败!")
        return
    }
    
    addFileWithData(fileName, fileData: imageData, successCallback: successCallback, failureCallback: failureCallback)
}