//
//  ComposeViewController.swift
//  BlueTwitterCS
//
//  Created by Duy Nguyen on 22/7/16.
//  Copyright © 2016 ZwooMobile Pte. Ltd. All rights reserved.
//

import UIKit

class ComposeViewController: UIViewController {

    @IBOutlet weak var statusField: UITextView!
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var characterCountLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!

    var tweet: Tweet!
    
    var postMessage: String? {
        get {
            return statusField?.text
        }
        set(newValue) {
            if let _ = statusField {
                statusField.text = newValue
                remainingCharacterCount = remainingCharacterCount * 1
            }
        }
    }
    var remainingCharacterCount: Int {
        get {
            return Configuration.characterLimit - (postMessage?.characters.count ?? 0)
        }
        set(newValue) {
            characterCountLabel?.text = "\(newValue)"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        statusField.becomeFirstResponder()
        statusField.delegate = self
        
        setupUIs()
    }
    
    func setupUIs() -> Void {
        if let user = User.currentUser {
            if user.profileImageUrl != nil {
                profileImage.setImageWithURL(user.profileImageUrl!)
            }
            nameLabel.text = user.name
        }

    }

    
    @IBAction func onCancel(sender: AnyObject) {
        
        onDismiss()
    }

    @IBAction func onTweet(sender: AnyObject) {
        
        statusField.resignFirstResponder()

        TwitterClient.updateStatus(statusField.text, inResponseToStatusId: tweet?.id, andMediaIds: nil, withCompletion: { (response) in
            
            NSNotificationCenter.defaultCenter().postNotificationName(Configuration.composeFinishedNotificationKey, object: nil)
            }) { (error) in
                print("\(error.localizedDescription)")
                
                Helper.showAlert("Error", message: error.description, inNavigationController: self.navigationController!)
        }

        onDismiss()
    }
    
    func onDismiss() {
        
        if statusField.text.characters.count > 0 {
            
            let alertVC = UIAlertController(title: "Warning", message: "Are you sure to discard this status?", preferredStyle: .Alert)
            
            let CancelAction = UIAlertAction(title: "Cancel", style: .Default) { (action) in
                
            }
            
            let OKAction = UIAlertAction(title: "OK", style: .Cancel) { (action) in
                self.dismissViewControllerAnimated(true, completion: nil)
            }
            
            alertVC.addAction(OKAction)
            alertVC.addAction(CancelAction)
            self.presentViewController(alertVC, animated: true, completion: nil)

        } else {
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }

}

extension ComposeViewController: UITextViewDelegate {
    
    // MARK: - UI Text view delegate methods
    func textViewDidChange(textView: UITextView) {
        remainingCharacterCount = remainingCharacterCount * 1
        if remainingCharacterCount == 0 {
            characterCountLabel?.textColor = UIColor.redColor()
        } else if remainingCharacterCount < 0 {
            postMessage = postMessage!.substringToIndex((postMessage?.endIndex.predecessor())!)
        } else {
            characterCountLabel?.textColor = UIColor.blackColor()
        }
    }
}

