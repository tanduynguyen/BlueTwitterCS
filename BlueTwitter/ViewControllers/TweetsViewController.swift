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
    var canFetchMoreResults = true
    var lastId: String?

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
        
    }
    
    func addNotification() {
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.resetHomeTimeline), name: Configuration.composeFinishedNotificationKey, object: nil)
    }
    
    func setupTableView() {
        
        tableView.dataSource = self
        tableView.delegate = self
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
        refreshControl.addTarget(self, action: #selector(resetHomeTimeline), forControlEvents: UIControlEvents.ValueChanged)
        tableView.insertSubview(refreshControl, atIndex: 0)
        resetHomeTimeline()
    }
    
    func resetHomeTimeline() {
        lastId = nil
        getHomeTimeline()
    }
    
    func getHomeTimeline() {
        
        if revealingSplashView == nil && lastId == nil {
            
            let hub = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
            hub.bezelView.color = Configuration.Colors.primary
        }
        
        TwitterClient.shareInstance.homeTimeline(withStatusId: lastId, success: { (userTweets) in
            
            if self.lastId != nil {
                let insertIndex = self.twitters!.count - 1
                self.twitters!.last!.id == userTweets.first?.id ? self.twitters?.replaceRange(insertIndex...insertIndex, with: userTweets) : ()
                self.tableView.reloadData()
                
            } else {
                self.twitters = userTweets
                self.tableView.reloadData()
                let scrollIndexPath: NSIndexPath = NSIndexPath(forRow:NSNotFound , inSection: 0)
                self.tableView.scrollToRowAtIndexPath(scrollIndexPath, atScrollPosition: UITableViewScrollPosition.Top, animated: true)
                
                self.refreshControl?.endRefreshing()
                MBProgressHUD.hideHUDForView(self.view, animated: true)
            }
            
        }) { (error) in
            print("\(error.localizedDescription)")
            MBProgressHUD.hideHUDForView(self.view, animated: true)
            Helper.showAlert("Error", message: "Please try to login again!", inNavigationController: self.navigationController!)
        }
            
    }
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "detailSegue" {
            let indexPath = sender as! NSIndexPath
            let vc = segue.destinationViewController as! DetailsViewController
            let tweet = twitters![indexPath.row] as Tweet
            
            vc.tweet = tweet
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

extension TweetsViewController: UITableViewDelegate {
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        self.performSegueWithIdentifier("detailSegue", sender: indexPath)
    }
    
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        if (twitters!.count - indexPath.row) == 4 && canFetchMoreResults {
            lastId = twitters?.last?.id
            getHomeTimeline()
        }
    }
}
