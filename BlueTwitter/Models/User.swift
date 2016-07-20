//
//  User.swift
//  TwitterDemo
//
//  Created by Dave Vo on 7/17/16.
//  Copyright © 2016 DaveVo. All rights reserved.
//

import UIKit

class User: NSObject {
    var name: String?
    var screenName: String?
    var profileImageUrl: NSURL?
    var tagline: String?
    var dictionary: NSDictionary
    
    static let storeCurrentUserDataKey = "storeCurrentUserDataKey"
    static var userDidLogoutNotificationKey = "userDidLogoutNotificationKey"

    init(dictionary: NSDictionary) {
        self.dictionary = dictionary
        name = dictionary["name"] as? String
        screenName = dictionary["screen_name"] as? String
        tagline = dictionary["description"] as? String
        
        let profileImageURLString = dictionary["profile_image_url_https"] as? String
        if let profileImageURLString = profileImageURLString {
            profileImageUrl = NSURL(string: profileImageURLString)!
        }
    }
    
    static var _currentUser: User?
    class var currentUser: User? {
        
        get {
            
            if _currentUser == nil {
            let defaults = NSUserDefaults.standardUserDefaults()
            let userData = defaults.objectForKey(storeCurrentUserDataKey) as? NSData
            if let userData = userData {
                let dict = try! NSJSONSerialization.JSONObjectWithData(userData, options: [])
                _currentUser = User(dictionary: dict as! NSDictionary)
            }
            }
            
            return _currentUser
        }
        
        set(user) {
            
            let defaults = NSUserDefaults.standardUserDefaults()
            if let user = user {
                let data = try! NSJSONSerialization.dataWithJSONObject(user.dictionary, options: [])
                defaults.setObject(data, forKey: storeCurrentUserDataKey)
            } else {
                defaults.setObject(nil, forKey: storeCurrentUserDataKey)
            }
            
            defaults.synchronize()
        }
    }
}
