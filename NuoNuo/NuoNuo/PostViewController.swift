//
//  PostViewController.swift
//  NuoNuo
//
//  Created by ruby on 16/9/4.
//  Copyright © 2016年 ruby. All rights reserved.
//

import UIKit
import KMPlaceholderTextView
import DKImagePickerController

let POST_MIN_LEN = 0
let POST_MAX_LEN = 256

class PostViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var postButton: UIBarButtonItem!
    @IBOutlet weak var contentTextView: KMPlaceholderTextView!
    @IBOutlet weak var addPhontoButton: UIButton!
    
    private var didSelectImageBlock: ((assets: [DKAsset]) -> Void)?  //image picker回调
    var photo: UIImage? {
        didSet {
            addPhontoButton.setBackgroundImage(photo, forState: .Normal)
            addPhontoButton.setTitle("点击更改图片", forState: .Normal)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBarController?.tabBar.hidden = true
        postButton.enabled = false
        contentTextView.delegate = self
        
        setupImageBlock()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(animated: Bool) {
        self.tabBarController?.tabBar.hidden = false
    }
    
    func setupImageBlock() {
        didSelectImageBlock = { (assets: [DKAsset]) in
            print("获取到图片张数: \(assets.count), 准备处理...")
            if assets.isEmpty || assets.count > 1 {
                print("获取图片张数不符合要求!")
                return
            }
            
            for asset in assets { //实际只需要一张图片
                asset.fetchFullScreenImage(false, completeBlock: { (image, info) in
                    if nil == image {
                        showSimpleAlert(self, title: "您真幸运", message: "获取图片失败了")
                        return
                    }
                    self.photo = image
                    return
                })
                
            }
        }
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
    
    @IBAction func addPhontoButtonPressed(sender: AnyObject) {
        print("用户准备选择图片...")
        let alertVC = HCImagePickerHandler().makeAlertController(self, maxCount: 1, defaultAssets: nil, didSelectAssets: self.didSelectImageBlock)
        self.presentViewController(alertVC, animated: true, completion: nil)
    }
    
    /**
     用户点击发表按钮，将内容发送到服务器
     
     - parameter sender: <#sender description#>
     */
    @IBAction func PostButtonPressed(sender: AnyObject) {
        print("准备将内容发布到服务器...")
        
        let author = getUserPhone()
        print("获取作者信息: \(author)")
        
        showHintFromView(self.view)
        addPost(author! + ".png", content: self.contentTextView.text, pic: photo) { (successfull) in
            hideHintFromView(self.view)
            if(!successfull) {
                print("发布帖子失败!")
            }
            else {
                print("发布帖子成功.")
            }
        }
    }
    
}
