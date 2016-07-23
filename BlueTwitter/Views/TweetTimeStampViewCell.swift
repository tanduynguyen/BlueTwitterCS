//
//  TweetTimeStampViewCell.swift
//  BlueTwitterCS
//
//  Created by Duy Nguyen on 22/7/16.
//  Copyright © 2016 ZwooMobile Pte. Ltd. All rights reserved.
//

import UIKit

class TweetTimeStampViewCell: UITableViewCell {

    var tweetDate: NSDate! {
        didSet {
            updateViewForCell()
        }
    }
    
    @IBOutlet weak var timestampLabel: UILabel!
    
    
    private func updateViewForCell() {
        timestampLabel?.text = Helper.getPresentationDateString(tweetDate)
    }


}
