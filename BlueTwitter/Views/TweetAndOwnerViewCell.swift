//
//  TweetAndOwnerViewCell.swift
//  BlueTwitterCS
//
//  Created by Duy Nguyen on 22/7/16.
//  Copyright © 2016 ZwooMobile Pte. Ltd. All rights reserved.
//

import UIKit

class TweetAndOwnerViewCell: UITableViewCell {
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var tweetOwnerNameLabel: UILabel!
    @IBOutlet weak var tweetOwnerScreennameLabel: UILabel!
    @IBOutlet weak var tweetTextLabel: UILabel!
    
    var tweet: Tweet! {
        didSet {
            updateCellWithTweetInfo()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        // Initialization code
        profileImageView.layer.cornerRadius = 5
        profileImageView.clipsToBounds = true
        profileImageView.contentMode = .ScaleAspectFit
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    private func updateCellWithTweetInfo() {
        
        if let user = tweet.user {
           
            if user.profileImageUrl != nil {
                profileImageView.setImageWithURL(user.profileImageUrl!)
            }
        }
        tweetOwnerNameLabel.text = tweet.user?.name
        tweetOwnerScreennameLabel?.text = tweet.user?.screenName
        tweetTextLabel?.text = tweet.text
    }


}
