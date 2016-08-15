//
//  LoginViewController.swift
//  NuoNuo
//
//  Created by ruby on 16/7/14.
//  Copyright © 2016年 ruby. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    @IBOutlet weak var backgroundView: UIImageView!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var verificationCodeTextField: UITextField!

    @IBOutlet weak var getVerificationCodeButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    
    var verifyingPhone: String = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupBackground()

        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /**
     添加背景图片并设置毛玻璃效果
     */
    func setupBackground() -> Void {
        let blurEffect = UIBlurEffect(style: .Light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.frame
        backgroundView.addSubview(blurEffectView)
    }

    /**
     隐藏状态栏
     
     - returns: bool
     */
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    /**
     获取验证码button点击动作
     
     - parameter sender: sender description
     */
    @IBAction func getVerificationButtonPressed(sender: AnyObject) {
        verifyingPhone = self.phoneTextField.text!
        
        if(11 != verifyingPhone.lengthOfBytesUsingEncoding(NSASCIIStringEncoding)) {
            showSimpleHint(self.view, title: "", message: "请输入正确的手机号码")
            return
        }
        
        SMSSDK.getVerificationCodeByMethod(SMSGetCodeMethodSMS, phoneNumber: verifyingPhone, zone: "86", customIdentifier: nil, result: { (error) -> Void in
            
            if(error != nil) {
                let errorString = getSMSErrorInfo(error.code)
                showSimpleAlert(self, title: "验证码获取失败", message: errorString)
                return
            }
            
            //showSimpleHint(self.view, title: "发送成功", message: "请耐心接收短信")
        })
    }
    
    /**
     登录按钮点击动作
     
     - parameter sender: sender description
     */
    @IBAction func loginButtonPressed(sender: AnyObject) {
        //检查验证码
        let verCode = verificationCodeTextField.text!
        if(verCode.isEmpty) {
            showSimpleAlert(self, title: VERIFY_SMS_FAILED_TITLE, message: VERIFY_SMS_FAILED_MSG)
            return
        }
        
        //测试账号
        if(phoneTextField.text! == ADMIN_PHONE && verificationCodeTextField.text! == ADMIN_CODE) {
            self.performSegueWithIdentifier("register_1_segue", sender: self)
            return
        }
        
        SMSSDK.commitVerificationCode(verCode, phoneNumber: verifyingPhone, zone: "86") { (error) in
            if(error != nil) {
                showSimpleAlert(self, title: VERIFY_SMS_FAILED_TITLE, message: VERIFY_SMS_FAILED_MSG)
                return
            }
            
            //验证通过，检查用户是否注册
            isUserRegisted(self.verifyingPhone, result: { (registed) in
                if(registed) {
                    NSNotificationCenter.defaultCenter().postNotificationName(LoginSuccessful, object: nil)
                }
                else {
                    self.performSegueWithIdentifier("register_1_segue", sender: self)
                }
            })
            
        }
        
    }
    
    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let dest = segue.destinationViewController as! VerifyViewController
        dest.verifiedPhone = verifyingPhone
        
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
}
