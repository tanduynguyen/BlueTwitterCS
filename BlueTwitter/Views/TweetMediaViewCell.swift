//
//  TweetMediaViewCell.swift
//  BlueTwitterCS
//
//  Created by Duy Nguyen on 22/7/16.
//  Copyright © 2016 ZwooMobile Pte. Ltd. All rights reserved.
//

import UIKit

class TweetMediaViewCell: UITableViewCell {

    var mediaUrl: NSURL? {
        didSet {
            if mediaUrl != nil {
                tweetMediaImageView?.setImageWithURL(mediaUrl!)
            }
        }
    }
    
    @IBOutlet weak var tweetMediaImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        // Initialization code
        tweetMediaImageView.layer.cornerRadius = 5
        tweetMediaImageView.clipsToBounds = true
        tweetMediaImageView.contentMode = .ScaleAspectFit
    }


}
