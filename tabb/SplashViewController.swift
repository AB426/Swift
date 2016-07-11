//
//  SplashViewController.swift
//  tabb
//
//  Created by LeeDongMin on 12/18/15.
//  Copyright © 2015 LeeDongMin. All rights reserved.
//

import UIKit

class SplashViewController: UIViewController {

    var tabBar : TabBarController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("tabBar") as! TabBarController
        
        // 원하는 서비스 ID 설정
        KeychainController.serviceName = serviceIdentifier
        
        if(loadKeyChainString("identifier") == nil && loadKeyChainString("identifier")?.length <= 0) {
            print(loadKeyChainString("identifier"))
            pref.setValue(NSUUID().UUIDString, forKey: "identifier")
            saveKeyChainWithString(pref.objectForKey("identifier") as! String, key: "identifier")
            if let keychainStr: NSString = loadKeyChainString("identifier") {
                NSLog("string 타입 identifier : %@", keychainStr)
            }
        } else {
            print(loadKeyChainString("identifier"))
            
            if let keychainStr: NSString = loadKeyChainString("identifier") {
                NSLog("string 타입 identifier : %@", keychainStr)
                pref.setValue(keychainStr, forKey: "identifier")
            }
        }
        
        self.startApp()

    }
    
    func startApp() {
        // Show the home screen after a bit. Calls the show() function.
        let myTimer = NSTimer.scheduledTimerWithTimeInterval(
            1.5, target: self, selector: Selector("show"), userInfo: nil, repeats: false
        )
        NSRunLoop.currentRunLoop().addTimer(myTimer, forMode: NSRunLoopCommonModes)
        
    }
    
    /*
    * Shows the app's main home screen.
    * Gets called by the timer in viewDidLoad()
    */
    func show() {

        if (pref.boolForKey("loginCheck")) {
            
            
            for item in (self.tabBar.tabBar.items as NSArray!){
                (item as! UITabBarItem).image = (item as! UITabBarItem).image?.imageWithRenderingMode(.AlwaysOriginal)
                (item as! UITabBarItem).selectedImage = (item as! UITabBarItem).selectedImage?.imageWithRenderingMode(.AlwaysOriginal)
            }
            
            self.tabBar.modalTransitionStyle = UIModalTransitionStyle.CrossDissolve
            let window = UIApplication.sharedApplication().windows[0]
            window.makeKeyAndVisible()
            UIView.transitionFromView(window.rootViewController!.view, toView: self.tabBar.view,
                duration: 0.65,options: .TransitionCrossDissolve,
                completion: {finished in window.rootViewController = self.tabBar})
            
        } else {
            
            //self.performSegueWithIdentifier("tutoSegue", sender: nil)
            
            if (pref.boolForKey("tutoCheck")) {
                self.performSegueWithIdentifier("goLogin", sender: nil)
            } else {
                self.performSegueWithIdentifier("tutoSegue", sender: nil)
            }
            
        }

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
