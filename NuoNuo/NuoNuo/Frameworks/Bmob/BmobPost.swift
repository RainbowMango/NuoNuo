//
//  BmobPost.swift
//  NuoNuo
//
//  Created by ruby on 16/9/5.
//  Copyright © 2016年 ruby. All rights reserved.
//

import Foundation

//帖子表信息
let POST_TABLE_NAME           = "post"
let POST_TABLE_COLUMN_AUTHOR  = "author"
let POST_TABLE_COLUMN_CONTENT = "content"
let POST_TABLE_COLUMN_PIC     = "pic"
let POST_TABLE_COLUMN_VOTE    = "vote"
let POST_TABLE_COLUMN_NVOTE   = "nvote"
let POST_TABLE_COLUMN_FORWARD = "forward"

//其他宏定义
let POST_TABLE_PIC_MAX_SIZE   = CGSizeMake(120, 120)

/**
 发表帖子
 
 - parameter author:  帖子作者
 - parameter content: 帖子文本内容
 - parameter pic:     帖子图片
 */
func addPost(author: String, content: String, pic: UIImage?, result: (successfull: Bool) -> Void){
    
    let saveImageSuccessCallback = { (url: String) -> Void in
        let obj = BmobObject(className: POST_TABLE_NAME)
        obj.setObject(author, forKey: POST_TABLE_COLUMN_AUTHOR)
        obj.setObject(content, forKey: POST_TABLE_COLUMN_CONTENT)
        obj.setObject(url, forKey: POST_TABLE_COLUMN_PIC)
        obj.setObject(0, forKey: POST_TABLE_COLUMN_VOTE)
        obj.setObject(0, forKey: POST_TABLE_COLUMN_NVOTE)
        obj.setObject(0, forKey: POST_TABLE_COLUMN_FORWARD)
        obj.saveInBackgroundWithResultBlock({ (success, error) in
            if(success) {
                result(successfull: true)
            }
            else {
                print("发布失败: \(error.localizedDescription)")
                result(successfull: false)
            }
        })
    }
    
    let postFaulureCallback = { () -> Void in
        result(successfull: false)
    }
    
    var smallImage: UIImage?
    if(nil != pic) { //带图片的帖子
        smallImage = ImageHandler().aspectSacleSize(pic!, targetSize: POST_TABLE_PIC_MAX_SIZE)
        addImageToRemote(author, image: smallImage, successCallback: saveImageSuccessCallback, failureCallback: postFaulureCallback)
    }
    else { //不带图片的帖子
        saveImageSuccessCallback(String())
    }
}