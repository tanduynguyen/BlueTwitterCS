//
//  NavigationController.swift
//  BlueTwitterCS
//
//  Created by Duy Nguyen on 21/7/16.
//  Copyright © 2016 ZwooMobile Pte. Ltd. All rights reserved.
//

import UIKit

struct Colors {
    static let primary = UIColor(red:133.0/255, green:182.0/255, blue:231.0/255, alpha:0.90)
}

class NavigationController: UINavigationController {
    
    override func viewDidLoad() {
        navigationBar.barTintColor = Colors.primary
        navigationBar.barStyle = .Black
        navigationBar.tintColor = UIColor.whiteColor()
        
        let statusBarHeight = UIApplication.sharedApplication().statusBarFrame.height
        let topView = UIView(frame:
            CGRect(
                x: 0,
                y: -statusBarHeight,
                width: navigationBar.frame.width,
                height: statusBarHeight
            )
        )
        
        topView.backgroundColor = UIColor(red: 0.00, green: 0.00, blue: 0.00, alpha: 0.20)
        
        navigationBar.addSubview(topView)
    }
}
