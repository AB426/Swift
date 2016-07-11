//
//  TabBarController.swift
//  tabb
//
//  Created by LeeDongMin on 12/10/15.
//  Copyright © 2015 LeeDongMin. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {
    
    var window: UIWindow?

    override func viewDidLoad() {
        super.viewDidLoad()

//        let tabBar = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("tabBar") as! TabBarController
//        for item in (tabBar.tabBar.items as NSArray!){
//            (item as! UITabBarItem).image = (item as! UITabBarItem).image?.imageWithRenderingMode(.AlwaysOriginal)
//            (item as! UITabBarItem).selectedImage = (item as! UITabBarItem).selectedImage?.imageWithRenderingMode(.AlwaysOriginal)
//        }
//        
//        UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: UIColorFromHex(0xc13939, alpha: 0.6)], forState: .Normal)
//        UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: UIColorFromHex(0xc13939, alpha: 1.0)], forState: .Selected)
        
        
//        let window = UIApplication.sharedApplication().windows[0]
//        let statusBarView = UIView(frame: CGRectMake(0, 0,
//            UIApplication.sharedApplication().statusBarFrame.size.width,
//            UIApplication.sharedApplication().statusBarFrame.size.height))
//        statusBarView.backgroundColor = UIColorFromHex(0x000000, alpha: 1.0)
        //window.rootViewController?.view.addSubview(statusBarView)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
