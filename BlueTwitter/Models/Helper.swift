//
//  Helper.swift
//  BlueTwitterCS
//
//  Created by Duy Nguyen on 22/7/16.
//  Copyright © 2016 ZwooMobile Pte. Ltd. All rights reserved.
//

import UIKit

class Helper: NSObject {
    
    static func showAlert(title: String, message: String?, inNavigationController nav: UINavigationController) {
        
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        
        let OKAction = UIAlertAction(title: "OK", style: .Cancel) { (action) in
            
        }
        
        alertVC.addAction(OKAction)
        nav.presentViewController(alertVC, animated: true, completion: nil)
    }
}
