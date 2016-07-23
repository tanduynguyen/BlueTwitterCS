//
//  ComposeViewController.swift
//  BlueTwitterCS
//
//  Created by Duy Nguyen on 22/7/16.
//  Copyright © 2016 ZwooMobile Pte. Ltd. All rights reserved.
//

import UIKit
import MBProgressHUD
import MapKit
import CoreLocation
import MobileCoreServices

class ComposeViewController: UIViewController {

    @IBOutlet weak var statusField: UITextView!
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var characterCountLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var replyToUserLabel: UILabel!
    @IBOutlet weak var widthOfImageView: NSLayoutConstraint!
    @IBOutlet weak var mediaImageView: UIImageView!
    
    var tweet: Tweet?
    
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
    
    var tagLocation = false
    var devicePlaceMark: CLPlacemark?
    var deviceLocation: CLLocation?
    let locationManager = CLLocationManager()
    var addMedia = false
    var tweetMediaIds: [String]?
    var imageData: NSData?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        statusField.becomeFirstResponder()
        statusField.delegate = self
        
        // initial set up for location
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()

        setupUIs()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        NSNotificationCenter.defaultCenter().removeObserver(self);
        locationManager.stopUpdatingLocation()
    }
    
    
    func setupUIs() -> Void {
        if let user = User.currentUser {
            if user.profileImageUrl != nil {
                profileImage.setImageWithURL(user.profileImageUrl!)
            }
            nameLabel.text = user.name
        }
        
        if tweet == nil {
            replyToUserLabel.text = ""
        } else if let tweet = tweet, let user = tweet.user, let screenName = user.screenName {
                replyToUserLabel.text = "Reply to " + user.name!
                statusField.text = "@" + screenName + " "
        }
        widthOfImageView.constant = 0
    }

    
    @IBAction func onCancel(sender: AnyObject) {
        
        onDismiss()
    }

    @IBAction func onTweet(sender: AnyObject) {
        
        statusField.resignFirstResponder()
        
        let hub = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        hub.bezelView.color = Configuration.Colors.primary
        
        let location = tagLocation ? deviceLocation : nil
        
        self.uploadImageIfNeeded({ () in
            let mediaIds = self.addMedia ? self.tweetMediaIds : nil
            
            TwitterClient.updateStatus(self.statusField.text, inResponseToStatusId: self.tweet?.id, andMediaIds: mediaIds, andLocation: location, withCompletion: { (response) in
                
                NSNotificationCenter.defaultCenter().postNotificationName(Configuration.composeFinishedNotificationKey, object: nil)
                MBProgressHUD.hideHUDForView(self.view, animated: true)
                self.dismissViewControllerAnimated(true, completion: nil)
            }) { (error) in
                print("\(error.description)")
                MBProgressHUD.hideHUDForView(self.view, animated: true)
                Helper.showAlert("Error", message: error.localizedDescription, inNavigationController: self.navigationController!)
            }
        })
        
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

extension ComposeViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBAction func captureMediaButton(sender: UIButton) {
        
        addMedia = !addMedia
        sender.selected = addMedia
        
        if addMedia == false {
            
            mediaImageView.image = nil
            widthOfImageView.constant = 0
            return
        }
        
        let pickerVC = UIImagePickerController()
        pickerVC.mediaTypes = [kUTTypeImage as String]
        pickerVC.allowsEditing = true
        pickerVC.delegate = self
        pickerVC.sourceType = .PhotoLibrary
        pickerVC.viewWillAppear(true)
        presentViewController(pickerVC, animated: false, completion: nil)
        pickerVC.viewDidAppear(true)
    }
    
    // MARK: - Image Picker delegate functions
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        var image = info[UIImagePickerControllerEditedImage] as? UIImage
        if image == nil {
            image = info[UIImagePickerControllerOriginalImage] as? UIImage
        }
        
        mediaImageView.image = image
        widthOfImageView.constant = 80

        dismissViewControllerAnimated(true, completion: nil)
        if image != nil {
            imageData = UIImagePNGRepresentation(image!)
        }
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func uploadImageIfNeeded(completion:() -> ()) {
        if imageData == nil {
            completion()
            return
        }
        TwitterClient.uploadMedia(imageData!, withCompletion: { (uploadedMediaDetails: NSDictionary?) in
            if let mediaIdString = uploadedMediaDetails?["media_id_string"] as? String {
                if self.tweetMediaIds == nil { self.tweetMediaIds = [String]() }
                self.tweetMediaIds?.append(mediaIdString)
                completion()
            }
            }, failure: { (error) in
                print("\(error.description)")
                Helper.showAlert("Error", message: error.localizedDescription, inNavigationController: self.navigationController!)
                completion()
        })
    }
    
}

extension ComposeViewController: CLLocationManagerDelegate {
    
    // MARK: - Location awreness
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            deviceLocation = location
        }
        
        CLGeocoder().reverseGeocodeLocation(manager.location!, completionHandler: {(placemarks, error) -> Void in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }
            
            // update location code
            if let placemarks = placemarks {
                self.devicePlaceMark = placemarks[0]
            }
        })
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("\(error.localizedDescription)")
        deviceLocation = nil
    }
    
    
    @IBAction func toggleLocationTagging(sender: UIButton) {
        tagLocation = !tagLocation
        sender.selected = tagLocation
    }
}
