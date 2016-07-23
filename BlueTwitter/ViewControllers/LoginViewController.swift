//
//  LoginViewController.swift
//  BlueTwitterCS
//
//  Created by Duy Nguyen on 20/7/16.
//  Copyright © 2016 ZwooMobile Pte. Ltd. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBAction func onLogin(sender: AnyObject) {
        // TODO: Get request token, redirect to authURL, convert requestToken -> accessToken
        
        // To make sure whoever login before, logout first
        TwitterClient.shareInstance.login(
            {
                self.performSegueWithIdentifier("loginSegue", sender: nil)
        }) { (error) in
            print("\(error.description)")
            Helper.showAlert("Error", message: error.localizedDescription, inNavigationController: self.navigationController!)
        }
    }
    
}
