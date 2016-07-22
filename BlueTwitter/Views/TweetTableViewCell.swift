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
    @IBOutlet weak var photoView: UIImageView!
    @IBOutlet weak var retweetedIcon: UIImageView!
    @IBOutlet weak var favIcon: UIImageView!
    
    @IBOutlet weak var verticalTopConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var photoHeightEqual0: NSLayoutConstraint!
    @IBOutlet weak var ratioPhotoView: NSLayoutConstraint!
    
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
            
            if let url = tweet.mediaURL {
                dispatch_async(dispatch_get_main_queue(), {
                    self.photoView.setImageWithURL(url)
                })

                photoHeightEqual0.active = false
                ratioPhotoView.active = true
            } else {
                photoHeightEqual0.active = true
                ratioPhotoView.active = false
            }
            
            if tweet.isRetweeted {
                retweetedIcon.image = UIImage(named: "retweet-action-on")
                retweetCountLabel.textColor = Configuration.Colors.green
            } else {
                retweetedIcon.image = UIImage(named: "retweet-action")
                retweetCountLabel.textColor = UIColor.darkGrayColor()
            }
            
            if tweet.isFavorited {
                favIcon.image = UIImage(named: "like-action-on")
                favCountLabel.textColor = Configuration.Colors.pink
            } else {
                favIcon.image = UIImage(named: "like-action")
                favCountLabel.textColor = UIColor.darkGrayColor()
            }
            
            updateConstraints()
            setNeedsLayout()
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
