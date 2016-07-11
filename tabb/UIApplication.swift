//
//  UIApplication.swift
//  tabb
//
//  Created by LeeDongMin on 12/23/15.
//  Copyright © 2015 LeeDongMin. All rights reserved.
//

import Foundation
import UIKit

extension UIApplication {
    class func tryURL(urls: [String]) {
        let application = UIApplication.sharedApplication()
        for url in urls {
            if application.canOpenURL(NSURL(string: url)!) {
                application.openURL(NSURL(string: url)!)
                return
            }
        }
    }
}