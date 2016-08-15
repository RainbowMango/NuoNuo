//
//  RegisterViewController.swift
//  NuoNuo
//
//  Created by ruby on 16/7/19.
//  Copyright © 2016年 ruby. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController {
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var avatarButton: UIButton!
    @IBOutlet weak var nickTextField: UITextField!

    var verifiedPhone = String()
    var email         = String()
    var staffID       = String()
    
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
     设置背景图片毛玻璃效果
     */
    func setupBackground() -> Void {
        let blurEffect = UIBlurEffect(style: .Light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.frame
        backgroundImageView.addSubview(blurEffectView)
    }

    @IBAction func avatarButtonPressedAction(sender: AnyObject) {
        print("选取头像")
    }
    
    @IBAction func doneButtonPressedAction(sender: AnyObject) {
        NSNotificationCenter.defaultCenter().postNotificationName(RegisterSuccessful, object: nil)
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
