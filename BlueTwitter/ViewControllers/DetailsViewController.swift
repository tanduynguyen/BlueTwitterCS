//
//  DetailsViewController.swift
//  BlueTwitterCS
//
//  Created by Duy Nguyen on 22/7/16.
//  Copyright © 2016 ZwooMobile Pte. Ltd. All rights reserved.
//

import UIKit
import MBProgressHUD

class DetailsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var tweet : Tweet!
    var idx : Int {
        get {
            return (tweet.mediaURL == nil ? 0 : 1)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        setupTableView()
    }

    func setupTableView() {
        
        tableView.dataSource = self
        tableView.estimatedRowHeight = 120
        tableView.rowHeight = UITableViewAutomaticDimension
  }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "composeSegue" {
            
            let navController = segue.destinationViewController as! UINavigationController
            let vc = navController.topViewController as! ComposeViewController
            
            vc.tweet = tweet
        }
        
    }
}

extension DetailsViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4 + (tweet.mediaURL == nil ? 0 : 1)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        
        switch indexPath.row {
        case 0:
            
            let cell = tableView.dequeueReusableCellWithIdentifier(String(TweetAndOwnerViewCell)) as? TweetAndOwnerViewCell
            cell?.tweet = tweet
            return cell!
            
        case idx:
            
            let cell = tableView.dequeueReusableCellWithIdentifier(String(TweetMediaViewCell)) as? TweetMediaViewCell
            cell?.mediaUrl = tweet.mediaURL
            return cell!
            
        case 1 + idx:
            
            let cell = tableView.dequeueReusableCellWithIdentifier(String(TweetTimeStampViewCell)) as? TweetTimeStampViewCell
            cell?.tweetDate = tweet.createdAt
            return cell!
            
        case 2 + idx:
            
            let cell = tableView.dequeueReusableCellWithIdentifier(String(TweetMeasuresViewCell)) as? TweetMeasuresViewCell
            cell?.tweet = tweet
            return cell!
            
        case 3 + idx:
            
            let cell = tableView.dequeueReusableCellWithIdentifier(String(UserActionViewCell)) as? UserActionViewCell
            cell?.tweet = tweet
            cell?.delegate = self
            return cell!
            
        default:
            break
        }
        
        return UITableViewCell()
    }
}

extension DetailsViewController: UserActionViewCellDelegate {
    
    func userActionCellTappedReply() {
        
        self.performSegueWithIdentifier("composeSegue", sender: nil)
    }
    
    func userActionCellTappedFavorite(newValue: Bool, cell: UserActionViewCell) {
        
        let hub = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        hub.bezelView.color = Configuration.Colors.primary
        
        TwitterClient.updateFavoriteStatusWitId(tweet.id!, status: newValue, WithCompletion: { (response) in
            
            if let dict = response {
                self.tweet = Tweet(dictionary: dict)
            }
            self.tableView.reloadData()
            MBProgressHUD.hideHUDForView(self.view, animated: true)
            NSNotificationCenter.defaultCenter().postNotificationName(Configuration.composeFinishedNotificationKey, object: nil)
            }) { (error) in
                print("\(error.localizedDescription)")
                MBProgressHUD.hideHUDForView(self.view, animated: true)
                Helper.showAlert("Error", message: error.description, inNavigationController: self.navigationController!)
        }
    }
 
    func userActionCellTappedRetweet(newValue: Bool) {
        
        let hub = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        hub.bezelView.color = Configuration.Colors.primary
        
        TwitterClient.updateTweetStatusWitId(tweet.id!, status: newValue, WithCompletion: { (response) in
            
            if let dict = response {
                self.tweet = Tweet(dictionary: dict)
            }
            self.tableView.reloadData()
            MBProgressHUD.hideHUDForView(self.view, animated: true)
            NSNotificationCenter.defaultCenter().postNotificationName(Configuration.composeFinishedNotificationKey, object: nil)
        }) { (error) in
            print("\(error.localizedDescription)")
            MBProgressHUD.hideHUDForView(self.view, animated: true)
            Helper.showAlert("Error", message: error.description, inNavigationController: self.navigationController!)
        }

    }
}