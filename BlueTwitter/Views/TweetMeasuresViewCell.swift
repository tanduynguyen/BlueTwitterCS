//
//  TweetMeasuresViewCell.swift
//  BlueTwitterCS
//
//  Created by Duy Nguyen on 22/7/16.
//  Copyright © 2016 ZwooMobile Pte. Ltd. All rights reserved.
//

import UIKit

class TweetMeasuresViewCell: UITableViewCell {

    @IBOutlet weak var retweetCountLabel: UILabel!
    @IBOutlet weak var favoriteCountLabel: UILabel!
    
    var tweet: Tweet! {
        didSet {
            updateCellUI()
        }
    }
    
    private func updateCellUI() {
        retweetCountLabel.text = Helper.getDecimalFormattedNumberString(NSNumber(integer: tweet.retweetCount))
        favoriteCountLabel.text = Helper.getDecimalFormattedNumberString(NSNumber(integer: tweet.favCount))
    }


}
