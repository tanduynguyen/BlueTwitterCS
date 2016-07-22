//
//  Configuration.swift
//  BlueTwitterCS
//
//  Created by Duy Nguyen on 20/7/16.
//  Copyright © 2016 ZwooMobile Pte. Ltd. All rights reserved.
//

import UIKit

class Configuration: NSObject {
    
    static var consumerKey = "FoU1uykMbBdCfsiJ8swOT1Mez"
    static var consumerSecret = "Um1oj2plEOeXBXFFOau3SoYVR0KCVEhp9b9dc6PHkd9qfCqS9T"

    static var baseURL = "https://api.twitter.com"
    
    
    struct Colors {
        static let primary = UIColor(red:133.0/255, green:182.0/255, blue:231.0/255, alpha:0.90)
        static let pink = UIColor(red:197.0/255, green:56.0/255, blue:77.0/255, alpha:1.0)
        static let green = UIColor(red:119.0/255, green:206.0/255, blue:137.0/255, alpha:1.0)
    }
}
