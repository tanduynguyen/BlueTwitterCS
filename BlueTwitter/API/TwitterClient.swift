//
//  TwitterClient.swift
//  BlueTwitterCS
//
//  Created by Duy Nguyen on 20/7/16.
//  Copyright © 2016 ZwooMobile Pte. Ltd. All rights reserved.
//

import BDBOAuth1Manager

class TwitterClient: BDBOAuth1SessionManager {
    
    static let shareInstance = TwitterClient(baseURL: NSURL(string: Configuration.baseURL), consumerKey: Configuration.consumerKey, consumerSecret: Configuration.consumerSecret)
    
    var loginSuccess: (() -> ())?
    var loginFailure: ((NSError) -> ())?
    
    func currentAccount(success: (User) -> (), failure: (NSError) -> ()) {

        GET("1.1/account/verify_credentials.json", parameters: nil, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) in
            
            let userDictionary = response as! NSDictionary
            let user = User(dictionary: userDictionary)
            
            success(user)
            
            }, failure: { (task: NSURLSessionDataTask?, error: NSError) in
                failure(error)
        })
    }
    
    func homeTimeline(success: ([Tweet]) -> (), failure: (NSError) -> ()) {

        GET("1.1/statuses/home_timeline.json", parameters: nil, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) in
            let dictionaries = response as! [NSDictionary]
            let tweets = Tweet.tweetsWithArray(dictionaries)
            
            success(tweets)
            
            }, failure: { (task:NSURLSessionDataTask?, error: NSError) in
                failure(error)
        })
    }
    
    func login(success: () -> (), failure: (NSError) -> ()) {
        
        loginSuccess = success
        loginFailure = failure
        
        deauthorize()
        fetchRequestTokenWithPath("oauth/request_token", method: "POST", callbackURL: NSURL(string: "bluetwittercs://oauth"), scope: nil, success: { (requestToken: BDBOAuth1Credential!) in
            
//            print("I got request token = \(requestToken.token)")
            let authUrl = NSURL(string: "\(Configuration.baseURL)/oauth/authorize?oauth_token=\(requestToken.token)")!
            UIApplication.sharedApplication().openURL(authUrl)
            
        }) { (error: NSError!) in
            self.loginFailure?(error)
        }
    }
    
    func handleOpenUrl(url: NSURL) {
        
        let requestToken = BDBOAuth1Credential(queryString: url.query)
        TwitterClient.shareInstance.fetchAccessTokenWithPath("oauth/access_token", method: "POST", requestToken: requestToken, success: { (accessToken: BDBOAuth1Credential!) in
//            print("I got access token = \(accessToken.token)")
            
            self.loginSuccess?()
            
        }) { (error: NSError!) in
            self.loginFailure?(error)
        }
    }
}
