//
//  PostViewController.swift
//  NuoNuo
//
//  Created by ruby on 16/9/4.
//  Copyright © 2016年 ruby. All rights reserved.
//

import UIKit
import KMPlaceholderTextView

let POST_MIN_LEN = 0
let POST_MAX_LEN = 256

class PostViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var postButton: UIBarButtonItem!
    @IBOutlet weak var contentTextView: KMPlaceholderTextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBarController?.tabBar.hidden = true
        postButton.enabled = false
        contentTextView.delegate = self

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(animated: Bool) {
        self.tabBarController?.tabBar.hidden = false
    }

    //MARK: --UITextViewDelegate
    /**
     限制内容最小长度
     
     - parameter textView: <#textView description#>
     */
    func textViewDidChange(textView: UITextView)
    {
        let len = textView.text.characters.count;
        
        postButton.enabled = (len > POST_MIN_LEN) ? true:false
    }
    
    /**
     限制内容最大长度
     
     - parameter textView: <#textView description#>
     - parameter range:    <#range description#>
     - parameter text:     <#text description#>
     
     - returns: <#return value description#>
     */
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool
    {
        let newLength = textView.text.characters.count;
        if (newLength > POST_MAX_LEN)
        {
            return false;
        }
        return true;
    }
    
    /**
     用户点击发表按钮，将内容发送到服务器
     
     - parameter sender: <#sender description#>
     */
    @IBAction func PostButtonPressed(sender: AnyObject) {
        print("准备将内容发布到服务器...")
    }
    
}
