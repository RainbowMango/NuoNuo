//
//  ViewController.swift
//  NuoNuo
//
//  Created by ruby on 16/6/26.
//  Copyright © 2016年 ruby. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var commentsTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        commentsTableView.tableFooterView = UIView()
        commentsTableView.estimatedRowHeight = 160 //预估高度要大于SB中最小高度，否则cell可能被压缩
        commentsTableView.rowHeight = UITableViewAutomaticDimension // cell 高度自适应
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("textcell", forIndexPath: indexPath)
        return cell
    }
}

