//
//  Tweet.swift
//  TwitterDemo
//
//  Created by Dave Vo on 7/17/16.
//  Copyright © 2016 DaveVo. All rights reserved.
//

import UIKit

extension Bool {
    init<T : IntegerType>(_ integer: T) {
        if integer == 0 {
            self.init(false)
        } else {
            self.init(true)
        }
    }
}

class Tweet: NSObject {
    var id: String?
    var user: User?
    var userMention: User?
    var text: String?
    var createdAtString: String?
    var createdAt: NSDate?
    var timeSinceCreated: String?
    var inReplyToScreenName: String?
    var mediaURL: NSURL?
    var isRetweeted: Bool
    var isFavorited: Bool
    
    var retweetCount = 0
    var favCount = 0
    
    
    init(dictionary: NSDictionary) {
        
        user = User(dictionary: dictionary["user"] as! NSDictionary)
        id = dictionary["id_str"] as? String
        text = dictionary["text"] as? String
        createdAtString = dictionary["created_at"] as? String
        retweetCount = (dictionary["retweet_count"] as? Int)!
        favCount = (dictionary["favorite_count"] as? Int)!
        inReplyToScreenName = dictionary["in_reply_to_screen_name"] as? String
        isRetweeted = Bool(dictionary["retweeted"] as! Int)
        isFavorited = Bool(dictionary["favorited"] as! Int)

        let formatter = NSDateFormatter()
        formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
        createdAt = formatter.dateFromString(createdAtString!)
        
        let elapsedTime = NSDate().timeIntervalSinceDate(createdAt!)
        if elapsedTime < 60 {
            timeSinceCreated = String(Int(elapsedTime)) + "s"
        } else if elapsedTime < 3600 {
            timeSinceCreated = String(Int(elapsedTime / 60)) + "m"
        } else if elapsedTime < 24*3600 {
            timeSinceCreated = String(Int(elapsedTime / 60 / 60)) + "h"
        } else {
            timeSinceCreated = String(Int(elapsedTime / 60 / 60 / 24)) + "d"
        }
        
        if let user_mention = dictionary.valueForKeyPath("retweeted_status.user") {
            userMention = user
            user = User(dictionary: user_mention as! NSDictionary)
        }
        
        if inReplyToScreenName != nil {
            
        }
        
        if let mediaItem = dictionary.valueForKeyPath("extended_entities.media.media_url") as? NSArray {
            if let item = mediaItem.firstObject {
                mediaURL = NSURL(string: item as! String)
            }
        }
    }
    
    class func tweetsWithArray(array: [NSDictionary]) -> [Tweet] {
        var tweets = [Tweet]()
        
//        NSLog("%@", array)

        for dict in array {
            tweets.append(Tweet(dictionary: dict))
        }
        return tweets
    }
}
