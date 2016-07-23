//
//  TwitterClient.swift
//  BlueTwitterCS
//
//  Created by Duy Nguyen on 20/7/16.
//  Copyright © 2016 ZwooMobile Pte. Ltd. All rights reserved.
//

import BDBOAuth1Manager
import AFNetworking

class TwitterClient: BDBOAuth1SessionManager {
    
    struct APIScheme {
        static let callbackURL = "bluetwittercs://oauth"
        static let BaseUrl = NSURL(string: "https://api.twitter.com")
        static let UploadUrl = NSURL(string: "https://upload.twitter.com")
        static let requestTokenEndPoint = "https://api.twitter.com/oauth/authorize?oauth_token="
        
        static let OAuthRequestTokenEndpoint = "oauth/request_token"
        static let OAuthAccessTokenEndpoint = "oauth/access_token"
        static let UserCredentialEndpoint = "1.1/account/verify_credentials.json"
        static let HomeTimelineEndpoint = "1.1/statuses/home_timeline.json"
        static let MentionsTimelineEndpoint = "1.1/statuses/mentions_timeline.json"
        static let ShowStatusEndpoint = "1.1/statuses/show/:id.json"
        static let UpdateStatusEndpoint = "1.1/statuses/update.json"
        static let RetweetStatusEndpoint = "1.1/statuses/retweet/%@.json"
        static let RetweetsOfStatusEndpoint = "1.1/statuses/retweets/:id.json"
        static let DestroyStatusEndpoint = "1.1/statuses/destroy/%@.json"
        static let FavoriteCreateEndpoint = "1.1/favorites/create.json"
        static let FavoriteDestroyEndpoint = "1.1/favorites/destroy.json"
        static let MediaUploadEndpoint = "1.1/media/upload.json"
    }
    
    static let shareInstance = TwitterClient(baseURL: APIScheme.BaseUrl, consumerKey: Configuration.consumerKey, consumerSecret: Configuration.consumerSecret)
    
    var loginSuccess: (() -> ())?
    var loginFailure: ((NSError) -> ())?

    
    func currentAccount(success: (User) -> (), failure: (NSError) -> ()) {

        GET(APIScheme.UserCredentialEndpoint, parameters: nil, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) in
            
            let userDictionary = response as! NSDictionary
            let user = User(dictionary: userDictionary)
            
            success(user)
            
            }, failure: { (task: NSURLSessionDataTask?, error: NSError) in
                failure(error)
        })
    }
    
    func homeTimeline(withStatusId id: String?, success: ([Tweet]) -> (), failure: (NSError) -> ()) {

        let parameters = NSMutableDictionary()
        if let id = id {
            parameters["max_id"] = id
        }
        
        GET(APIScheme.HomeTimelineEndpoint, parameters: parameters, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) in
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
        fetchRequestTokenWithPath(APIScheme.OAuthRequestTokenEndpoint, method: "POST", callbackURL: NSURL(string: APIScheme.callbackURL), scope: nil, success: { (requestToken: BDBOAuth1Credential!) in
            
//            print("I got request token = \(requestToken.token)")
            let authUrl = NSURL(string:
                APIScheme.requestTokenEndPoint.stringByAppendingString(requestToken.token))!
            UIApplication.sharedApplication().openURL(authUrl)
            
        }) { (error: NSError!) in
            self.loginFailure?(error)
        }
    }
    
    func handleOpenUrl(url: NSURL) {
        
        let requestToken = BDBOAuth1Credential(queryString: url.query)
        TwitterClient.shareInstance.fetchAccessTokenWithPath(APIScheme.OAuthAccessTokenEndpoint, method: "POST", requestToken: requestToken, success: { (accessToken: BDBOAuth1Credential!) in
//            print("I got access token = \(accessToken.token)")
            
            self.currentAccount({ (user) in
                User.currentUser = user
                self.loginSuccess?()
                }, failure: { (error) in
                    self.loginFailure?(error)
            })
            
        }) { (error: NSError!) in
            self.loginFailure?(error)
        }
    }
    
    func logout() {
        
        User.currentUser = nil
        deauthorize()
    }
    
    
    static func updateStatus(status: String, inResponseToStatusId replyStatusId: String?, andMediaIds mediaIds: [String]?, withCompletion success: (response: NSDictionary?) -> (), failure: (NSError) -> ()) {
        
        let parameters = NSMutableDictionary()
        parameters["status"] = status
        if let replyStatusId = replyStatusId {
            parameters["in_reply_to_status_id"] = replyStatusId
        }
        
        if let mediaIds = mediaIds {
            parameters["media_ids"] = mediaIds.joinWithSeparator(",")
        }
        
        TwitterClient.shareInstance.POST(APIScheme.UpdateStatusEndpoint, parameters: parameters, progress: nil, success:{ (task, response) in
            let retweetResponse =  response as? NSDictionary
            success(response: retweetResponse)
        }) { (task, error) in
            failure(error)
        }
        
    }
    
    static func updateFavoriteStatusWitId(id: String, status: Bool, WithCompletion success: (response: NSDictionary?) -> (), failure: (NSError) -> ()) {
        let useEndpoint = status ? APIScheme.FavoriteCreateEndpoint : APIScheme.FavoriteDestroyEndpoint
        TwitterClient.shareInstance.POST(useEndpoint, parameters: ["id": id], progress: nil, success:{ (task, response) in
            let retweetResponse = response as? NSDictionary
            success(response: retweetResponse)
        }) { (task, error) in
            failure(error)
        }
    }
    
    
    static func updateTweetStatusWitId(id: String, status: Bool, WithCompletion completion:(response: NSDictionary?) -> (), failure: (NSError) -> ()) {
        var useEndpoint = status ? APIScheme.RetweetStatusEndpoint : APIScheme.DestroyStatusEndpoint
        useEndpoint = String(format: useEndpoint, id)
        
        TwitterClient.shareInstance.POST(useEndpoint, parameters: nil, progress: nil, success:{ (task, response) in
            let retweetResponse = response as? NSDictionary
            completion(response: retweetResponse)
        }) { (task, error) in
            failure(error)
        }
    }

}
