//
//  TweetsViewController.swift
//  BlueTwitterCS
//
//  Created by Duy Nguyen on 20/7/16.
//  Copyright © 2016 ZwooMobile Pte. Ltd. All rights reserved.
//

import UIKit
import RevealingSplashView

class TweetsViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var twitters: [Tweet]?
    var revealingSplashView: RevealingSplashView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        
        self.revealingSplashView = setupSplashScreen()
        getHomeTimeline()
    }
    
    func setupSplashScreen() -> RevealingSplashView {
        
        //Initialize a revealing Splash with with the iconImage, the initial size and the background color
        let splashView = RevealingSplashView(iconImage: UIImage(named: "twitterLogo")!,iconInitialSize: CGSizeMake(70, 70), backgroundColor: Colors.primary)
        
        //Adds the revealing splash view as a sub view
        self.view.addSubview(splashView)
        
        return splashView
    }
    
    func getHomeTimeline() {
        
        TwitterClient.shareInstance.homeTimeline({ (twitters) in
            
            self.twitters = twitters
            self.tableView.reloadData()
            
            //Starts animation
            self.revealingSplashView.startAnimation() {
                print("Completed")
            }
        }) { (error) in
            print("\(error.localizedDescription)")
        }

    }
}

extension TweetsViewController {
    
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
