//
//  Configuration.swift
//  BlueTwitterCS
//
//  Created by Duy Nguyen on 20/7/16.
//  Copyright © 2016 ZwooMobile Pte. Ltd. All rights reserved.
//

import UIKit

class Configuration: NSObject {
    
    static let consumerKey = "ud7Gg9U28yVG5k3HOfZ7NBr1J"
    static let consumerSecret = "KD70sYrvjGLgDHBvLNZYxrWsiG3ZSULr5WbvyJQYjKeG5lZxDE"
    
    static let composeFinishedNotificationKey = "composeFinishedNotificationKey"
    static let characterLimit = 140

    struct Colors {
        static let primary = UIColor(red:133.0/255, green:182.0/255, blue:231.0/255, alpha:0.90)
        static let pink = UIColor(red:197.0/255, green:56.0/255, blue:77.0/255, alpha:1.0)
        static let green = UIColor(red:119.0/255, green:206.0/255, blue:137.0/255, alpha:1.0)
    }
}
