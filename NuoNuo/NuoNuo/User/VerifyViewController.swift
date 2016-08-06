//
//  VerifyViewController.swift
//  NuoNuo
//
//  Created by ruby on 16/7/18.
//  Copyright © 2016年 ruby. All rights reserved.
//

import UIKit

class VerifyViewController: UIViewController {

    var verifiedPhone = String()
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var staffIdentifierTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /**
     隐藏状态栏
     
     - returns: bool
     */
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    /**
     信息验证后继续注册流程
     
     - parameter sender: <#sender description#>
     */
    @IBAction func NextButtonPressedAction(sender: AnyObject) {
        let email = emailTextField.text!
        let staff = staffIdentifierTextField.text!
        
        if(email.isEmpty || staff.isEmpty) {
            showSimpleHint(self.view, title: "请输入身份信息", message: "请放心，不会向你的邮箱发送任何内容")
            return
        }
        performSegueWithIdentifier("register_2_segue", sender: self)
    }
    
    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let dest = segue.destinationViewController as! RegisterViewController
        dest.verifiedPhone = verifiedPhone
        dest.email         = emailTextField.text!
        dest.staffID       = staffIdentifierTextField.text!
    }
}
