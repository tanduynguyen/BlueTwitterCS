//
//  TweetTableViewCell.swift
//  BlueTwitterCS
//
//  Created by Duy Nguyen on 21/7/16.
//  Copyright © 2016 ZwooMobile Pte. Ltd. All rights reserved.
//

import UIKit
import AFNetworking

class TweetTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var tweetLabel: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var retweetCountLabel: UILabel!
    @IBOutlet weak var favCountLabel: UILabel!
    @IBOutlet weak var timeSinceCreatedLabel: UILabel!
    @IBOutlet weak var profileView: UIImageView!
    
    @IBOutlet weak var userMentionLable: UILabel!
    @IBOutlet weak var verticalTopConstraint: NSLayoutConstraint!
    var tweet: Tweet! {
        didSet {
            
            tweetLabel.text = tweet.text
            retweetCountLabel.text = tweet.retweetCount > 0 ? String(tweet.retweetCount) : ""
            favCountLabel.text = tweet.favCount > 0 ? String(tweet.favCount) : ""
            timeSinceCreatedLabel.text = tweet.timeSinceCreated
            
            if let userMention = tweet.userMention {
                userMentionLable.text = userMention.name?.stringByAppendingString(" retweeted")
                verticalTopConstraint.constant = 8
            } else {
                verticalTopConstraint.constant = -20
            }
            
            if let user = tweet.user {
                nameLabel.text = user.name
                if let screenName = user.screenName  {
                    screenNameLabel.text = "@\(screenName)"
                } else {
                    screenNameLabel.text = ""
                }
                if user.profileImageUrl != nil {
                    profileView.setImageWithURL(user.profileImageUrl!)
                }
            }
            
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        profileView.layer.cornerRadius = 4
        profileView.layer.masksToBounds = true
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
