//
//  TweetsViewController.swift
//  BlueTwitterCS
//
//  Created by Duy Nguyen on 20/7/16.
//  Copyright © 2016 ZwooMobile Pte. Ltd. All rights reserved.
//

import UIKit

class TweetsViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var twitters: [Tweet]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        TwitterClient.shareInstance.homeTimeline({ (twitters) in
            
            self.twitters = twitters
            self.tableView.reloadData()
            }) { (error) in
                print("\(error.localizedDescription)")
        }
        
        tableView.dataSource = self
    }
    
    @IBAction func onLogout(sender: AnyObject) {
        
        TwitterClient.shareInstance.logout()
        
        NSNotificationCenter.defaultCenter().postNotificationName(User.userDidLogoutNotificationKey, object: nil)
    }
}

extension TweetsViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return twitters?.count ?? 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell")
        let tweet = twitters![indexPath.row] as Tweet
        cell?.textLabel?.text = tweet.text
        
        return cell!
    }
}
