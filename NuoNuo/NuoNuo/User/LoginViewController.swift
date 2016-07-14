//
//  LoginViewController.swift
//  NuoNuo
//
//  Created by ruby on 16/7/14.
//  Copyright © 2016年 ruby. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

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
        let backgroundView   = UIImageView(frame: view.bounds)
        backgroundView.image = UIImage(named: "reg_bg_1")
        view.addSubview(backgroundView)
        
        let blurEffect = UIBlurEffect(style: .Light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.frame
        backgroundView.addSubview(blurEffectView)
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
