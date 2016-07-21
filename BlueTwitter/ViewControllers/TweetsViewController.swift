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
    var refreshControl: UIRefreshControl!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        setupSplashScreen()
        setupPullRefresh()
        revealingSplashView?.startAnimation()
    }
    
    func setupTableView() {
        
        tableView.dataSource = self
        tableView.estimatedRowHeight = 120
        tableView.rowHeight = UITableViewAutomaticDimension
        
        let identifier = String(TweetTableViewCell)
        tableView.registerNib(UINib(nibName: identifier, bundle: nil), forCellReuseIdentifier: identifier)
        
    }
    
    func setupSplashScreen() {
        
        //Initialize a revealing Splash with with the iconImage, the initial size and the background color
        revealingSplashView = RevealingSplashView(iconImage: UIImage(named: "twitterLogo")!,iconInitialSize: CGSizeMake(70, 70), backgroundColor: Colors.primary)
        
        //Adds the revealing splash view as a sub view
        self.view.addSubview(revealingSplashView)
    }
    
    func setupPullRefresh() {
        // Initialize a UIRefreshControl
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(getHomeTimeline(_:)), forControlEvents: UIControlEvents.ValueChanged)
        tableView.insertSubview(refreshControl, atIndex: 0)
        getHomeTimeline(nil)
    }
    
    func getHomeTimeline(refreshControl: UIRefreshControl?) {
        
        TwitterClient.shareInstance.homeTimeline({ (twitters) in
            
            self.twitters = twitters
            self.tableView.reloadData()
            
            refreshControl?.endRefreshing()
            
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
        
        let identifier = String(TweetTableViewCell)
        let cell = tableView.dequeueReusableCellWithIdentifier(identifier) as? TweetTableViewCell
        
        let tweet = twitters![indexPath.row] as Tweet

//        if cell == nil {
//            tableView.registerNib(UINib(nibName: identifier, bundle: nil), forCellReuseIdentifier: identifier)
//            cell = tableView.dequeueReusableCellWithIdentifier(identifier) as? TweetTableViewCell
//        }
        
        cell?.tweet = tweet
        
        return cell!
    }
}
