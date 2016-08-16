//
//  RegisterViewController.swift
//  NuoNuo
//
//  Created by ruby on 16/7/19.
//  Copyright © 2016年 ruby. All rights reserved.
//

import UIKit
import DKImagePickerController

class RegisterViewController: UIViewController {
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var avatarButton: UIButton!
    @IBOutlet weak var nickTextField: UITextField!

    var verifiedPhone = String()
    var email         = String()
    var staffID       = String()
    var avatarImage: UIImage?   = nil
    var nickName      = String()
    
    private var didSelectImageBlock: ((assets: [DKAsset]) -> Void)?  //image picker回调
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupBackground()
        
        setupImageBlock()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /**
     设置背景图片毛玻璃效果
     */
    func setupBackground() -> Void {
        let blurEffect = UIBlurEffect(style: .Light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.frame
        backgroundImageView.addSubview(blurEffectView)
    }
    
    func setupImageBlock() -> Void {
        didSelectImageBlock = { (assets: [DKAsset]) in
            
            if assets.isEmpty {
                showSimpleAlert(self, title: "您真幸运", message: "一定是哪里出错了，头像只能是一张图片")
                return
            }
            
            //新选择的图片加入列表中
            for asset in assets {
                asset.fetchFullScreenImage(false, completeBlock: { (image, info) in
                    if nil == image {
                        showSimpleAlert(self, title: "您真幸运", message: "获取图片失败了")
                        return
                    }
                    print("接收图片")
                    self.avatarButton.setBackgroundImage(image, forState: .Normal)
                    self.avatarImage = image
                    //let scaledImage = ImageHandler().aspectSacleSize(image!, targetSize: AVATAR_SIZE)
                })
                
            }
        }
    }

    @IBAction func avatarButtonPressedAction(sender: AnyObject) {
        let alertVC = HCImagePickerHandler().makeAlertController(self, maxCount: 1, defaultAssets: nil, didSelectAssets: self.didSelectImageBlock)
        self.presentViewController(alertVC, animated: true, completion: nil)
    }
    
    @IBAction func doneButtonPressedAction(sender: AnyObject) {
        nickName = nickTextField.text!
        if(nickName.isEmpty) {
            showSimpleHint(self.view, title: "缺少昵称", message: "请给自己选一个名字吧~")
            return
        }
        
        isNickNameReserved(nickName) { (reserved) in
            if(reserved) {
                showSimpleHint(self.view, title: "重名了", message: "该名称已被使用")
                return
            }
            self.verifiedPhone = "18605811857"// 测试使用
            uploadAvatar(self.avatarImage!, phone: self.verifiedPhone, result: { (url) in
                NSNotificationCenter.defaultCenter().postNotificationName(RegisterSuccessful, object: nil)
            })
            
        }
    }
    
    /**
     隐藏状态栏
     
     - returns: bool
     */
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
