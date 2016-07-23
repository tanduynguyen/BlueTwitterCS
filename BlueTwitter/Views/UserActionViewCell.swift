//
//  UserActionViewCell.swift
//  BlueTwitterCS
//
//  Created by Duy Nguyen on 22/7/16.
//  Copyright © 2016 ZwooMobile Pte. Ltd. All rights reserved.
//

import UIKit

@objc protocol UserActionViewCellDelegate: class {
    
    optional func userActionCellTappedRetweet(newValue: Bool)
    optional func userActionCellTappedFavorite(newValue: Bool, cell: UserActionViewCell)
    optional func userActionCellTappedReply()
}

class UserActionViewCell: UITableViewCell {
    
    @IBOutlet weak var replyActionButton: UIButton!
    @IBOutlet weak var retweetActionButton: UIButton!
    @IBOutlet weak var favoriteActionButton: UIButton!
    
    var tweet: Tweet! {
        didSet {
            updateCellView()
        }
    }
    
    weak var delegate: UserActionViewCellDelegate?
    @IBAction func replyButtonTapped(sender: UIButton) {
        delegate?.userActionCellTappedReply?()
    }
    
    @IBAction func retweetButtonTapped(sender: UIButton) {
        delegate?.userActionCellTappedRetweet?(!tweet.isRetweeted)
    }
    
    @IBAction func favoriteButtonTapped(sender: UIButton) {
        delegate?.userActionCellTappedFavorite?(!tweet.isFavorited, cell: self)
    }
    
    private func updateCellView() {
        retweetActionButton.selected = tweet.isRetweeted
        favoriteActionButton.selected = tweet.isFavorited
    }
}
