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
     
     - parameter sender: <#sender description#>
     */
    @IBAction func getVerificationButtonPressed(sender: AnyObject) {
        verifyingPhone = self.phoneTextField.text!
        
        if(11 != verifyingPhone.lengthOfBytesUsingEncoding(NSASCIIStringEncoding)) {
            //TODO: 提示用户手机号位数不对
            return
        }
        
        SMSSDK.getVerificationCodeByMethod(SMSGetCodeMethodSMS, phoneNumber: verifyingPhone, zone: "86", customIdentifier: nil, result: { (error) -> Void in
            
            if(error != nil) {
                //let errorString = getSMSErrorInfo(error.code)
                //showSimpleAlert(self, title: "验证码获取失败", message: errorString)
                return
            }
            
            //showSimpleHint(self.view, title: "发送成功", message: "请耐心接收短信")
        })
    }
    
    /**
     登录按钮点击动作
     
     - parameter sender: <#sender description#>
     */
    @IBAction func loginButtonPressed(sender: AnyObject) {
        
        let verCode = verificationCodeTextField.text
        if(verCode?.lengthOfBytesUsingEncoding(NSASCIIStringEncoding) < 0) {
            //showSimpleAlert(self, title: VERIFY_SMS_FAILED_TITLE, message: VERIFY_SMS_FAILED_MSG)
            return
        }
        
        SMSSDK.commitVerificationCode(verCode!, phoneNumber: verifyingPhone, zone: "86") { (error) in
            if(error != nil) {
                //showSimpleAlert(self, title: VERIFY_SMS_FAILED_TITLE, message: VERIFY_SMS_FAILED_MSG)
                return
            }
            
            //验证通过，检查用户是否注册
        }
        performSegueWithIdentifier("register_1_segue", sender: self)
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
