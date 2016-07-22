//
//  TweetsViewController.swift
//  BlueTwitterCS
//
//  Created by Duy Nguyen on 20/7/16.
//  Copyright © 2016 ZwooMobile Pte. Ltd. All rights reserved.
//

import UIKit
import RevealingSplashView
import MBProgressHUD

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
        addNotification()
        revealingSplashView?.startAnimation() {
            self.revealingSplashView.removeFromSuperview()
            self.revealingSplashView = nil
        }
        
//        NSTimer.scheduledTimerWithTimeInterval(30, target: self, selector: #selector(self.getHomeTimeline), userInfo: nil, repeats: true)
    }
    
    func addNotification() {
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.getHomeTimeline), name: Configuration.composeFinishedNotificationKey, object: nil)
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
        revealingSplashView = RevealingSplashView(iconImage: UIImage(named: "twitterLogo")!,iconInitialSize: CGSizeMake(70, 70), backgroundColor: Configuration.Colors.primary)
        
        //Adds the revealing splash view as a sub view
        self.view.addSubview(revealingSplashView)
    }
    
    func setupPullRefresh() {
        // Initialize a UIRefreshControl
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(getHomeTimeline), forControlEvents: UIControlEvents.ValueChanged)
        tableView.insertSubview(refreshControl, atIndex: 0)
        getHomeTimeline()
    }
    
    func getHomeTimeline() {
        
        if revealingSplashView == nil {
            
            let hub = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
            hub.bezelView.color = Configuration.Colors.primary
        }
        
        TwitterClient.shareInstance.homeTimeline({ (twitters) in
            
            self.twitters = twitters
            self.tableView.reloadData()
            
            self.refreshControl?.endRefreshing()
            
            let scrollIndexPath: NSIndexPath = NSIndexPath(forRow:NSNotFound , inSection: 0)
            self.tableView.scrollToRowAtIndexPath(scrollIndexPath, atScrollPosition: UITableViewScrollPosition.Top, animated: true)
            MBProgressHUD.hideHUDForView(self.view, animated: true)
        }) { (error) in
            print("\(error.localizedDescription)")
            
            Helper.showAlert("Error", message: error.description, inNavigationController: self.navigationController!)
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
        
        cell?.tweet = tweet
        
        return cell!
    }
}
