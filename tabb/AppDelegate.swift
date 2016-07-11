//
//  AppDelegate.swift
//  tabb
//
//  Created by LeeDongMin on 2015. 9. 23..
//  Copyright (c) 2015년 LeeDongMin. All rights reserved.
//

import UIKit
import CoreData
import CoreLocation
import AudioToolbox

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, CLLocationManagerDelegate {

    var window: UIWindow?
    
    var locationManager: CLLocationManager?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.

        locationManager = CLLocationManager()
        
        if(locationManager!.respondsToSelector("requestAlwaysAuthorization")) {
            locationManager!.requestAlwaysAuthorization()
        }
        locationManager!.delegate = self
        locationManager!.pausesLocationUpdatesAutomatically = false
        
        let settings = UIUserNotificationSettings(forTypes: UIUserNotificationType([.Alert, .Badge, .Sound]), categories: nil)
        
        //var settings: UIUserNotificationSettings = UIUserNotificationSettings( forTypes: types, categories: nil )
        
        application.registerUserNotificationSettings( settings )
        application.registerForRemoteNotifications()
        
        
//        if (pref.boolForKey("loginCheck")) {
//            let tabbar = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("tabBar") as! TabBarController
//            self.window?.makeKeyAndVisible()
//            
//
//            for item in (tabbar.tabBar.items as NSArray!){
//                (item as! UITabBarItem).image = (item as! UITabBarItem).image?.imageWithRenderingMode(.AlwaysOriginal)
//                (item as! UITabBarItem).selectedImage = (item as! UITabBarItem).selectedImage?.imageWithRenderingMode(.AlwaysOriginal)
//            }
//            
//            //self.window?.rootViewController? = tabbar
//        }
        
     
        

        UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: UIColorFromHex(0xc13939, alpha: 0.6)], forState: .Normal)
        UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: UIColorFromHex(0xc13939, alpha: 1.0)], forState: .Selected)
        
        UINavigationBar.appearance().translucent = false
        UINavigationBar.appearance().barTintColor = UIColorFromHex(0xc13939, alpha: 1.0)
        //UINavigationBar.appearance().tintColor = UIColor.whiteColor()

        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        UIApplication.sharedApplication().statusBarStyle = .LightContent
        
        return FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
        
        return FBSDKApplicationDelegate.sharedInstance().application(application, openURL: url, sourceApplication: sourceApplication, annotation: annotation)
    }
    
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        let characterSet: NSCharacterSet = NSCharacterSet( charactersInString: "<>" )
        
        let deviceTokenString: String = ( deviceToken.description as NSString )
            .stringByTrimmingCharactersInSet( characterSet )
            .stringByReplacingOccurrencesOfString( " ", withString: "" ) as String
        
        pref.setValue(deviceTokenString, forKey: "deviceToken")
        print( pref.objectForKey("deviceToken") )
        print( deviceTokenString )
    }
    
    func application( application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError ) {
        
        print( error.localizedDescription )
    }
    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
        //푸시 받고나서 사용한다.
        print("Recived: \(userInfo)")
        
        
        AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
        

        
        
        let aps : NSDictionary = (userInfo["aps"] as? NSDictionary)!
        let alert = aps.objectForKey("alert") as! NSDictionary
        
        print(alert.objectForKey("title") as! String)
        print(alert.objectForKey("body") as! String)
        
        let pushType : NSString = (userInfo["type"] as? NSString)!
        
//        if(pushType == "testPush") {
//            customPop.showInView(window, withMessage: "Test Push", animated: true)
//        } else {
//            let msg : NSString = (userInfo["msg"] as? NSString)!
//            let jsonData : NSData = msg.dataUsingEncoding(NSUTF8StringEncoding)!
//            
//            do {
//                let post = try NSJSONSerialization.JSONObjectWithData(jsonData, options: NSJSONReadingOptions.AllowFragments) as! NSDictionary
//                
//                if(pushType == "request.share") {
//                    
//                    let type = post["type"] as! String
//                    
//                    if(type == "SPLIT") {
//                        if(payment != nil) {
//                            payment.updatePushChange()
//                        }
//                    }
//                    
//                    if(type == "IMPORTS") {
//                        //take this bill을 할 경우 푸시로 온다. 처리는?????
//                        if(payment != nil) {
//                            payment.updatePushChange()
//                        }
//                    }
//                    
//                    if(type == "SPLIT_CHECK") {
//                        //send my bill을 할 경우 푸시로 온다. 처리는?????
//                        if(payment != nil) {
//                            payment.updatePushChange()
//                        }
//                    }
//                }
//                
//                if(pushType == "requester.share") {
//                    //아이템 개별 스플릿 경우 노티를 보내야된다.
//                    let responseType = post["responseType"] as! String
//                    print("split responseType : \(responseType)")
//                    
//                    if(payment != nil) {
//                        if(splitAttemptChk) {
//                            payment.changeReviewBtn()
//                            
//                            if(responseType == "ACCEPT") {
//                                sendNotificationMessage("Your split request was accepted", title: "TABB")
//                            } else if(responseType == "REJECT") {
//                                sendNotificationMessage("Your split request was not accepted", title: "TABB")
//                            }
//                        }
//                        
//                        if(splitTakeBillChk) {
//                            splitTakeBillChk = false
//                            payment.updatePushChange()
//                            
//                            if(responseType == "ACCEPT") {
//                                sendNotificationMessage("Your request was accepted", title: "TABB")
//                            } else if(responseType == "REJECT") {
//                                sendNotificationMessage("Your request was rejected", title: "TABB")
//                            }
//                        }
//                        
//                        if(splitSendBillChk) {
//                            payment.changeAllReviewBtn()
//                            
//                            if(responseType == "ACCEPT") {
//                                sendNotificationMessage("Your request was accepted", title: "TABB")
//                            } else if(responseType == "REJECT") {
//                                sendNotificationMessage("Your request was rejected", title: "TABB")
//                            }
//                        }
//                    }
//                    
//                }
//                
//                if(pushType == "response.share") {
//                    let type = post["type"] as! String
//                    let responseType = post["responseType"] as! String
//                    print("split responseType : \(responseType)")
//                    if(type == "SPLIT_CHECK") {
//                        if(responseType == "ACCEPT") {
//                            
//                        } else if(responseType == "REJECT") {
//                            
//                        }
//                    }
//                    
//                    if(type == "SPLIT") {
//                        if(responseType == "ACCEPT") {
//                            
//                        } else if(responseType == "REJECT") {
//                            if(payment != nil) {
//                                payment.updatePushChange()
//                            }
//                        }
//                    }
//                    
//                    
//                }
//                
//            } catch let error as NSError {
//                // Catch fires here, with an NSErrro being thrown from the JSONObjectWithData method
//                print("A JSON parsing error occurred, here are the details:\n \(error)")
//            }
//
//        }
        
        let msg : NSString = (userInfo["msg"] as? NSString)!
        let jsonData : NSData = msg.dataUsingEncoding(NSUTF8StringEncoding)!
        
        do {
            let post = try NSJSONSerialization.JSONObjectWithData(jsonData, options: NSJSONReadingOptions.AllowFragments) as! NSDictionary
            
            if(pushType == "request.share") {
                
                let type = post["type"] as! String
                
                if(type == "SPLIT") {
                    if(payment != nil) {
                        payment.updatePushChange()
                    }
                }
                
                if(type == "IMPORTS") {
                    //take this bill을 할 경우 푸시로 온다. 처리는?????
                    if(payment != nil) {
                        payment.updatePushChange()
                    }
                }
                
                if(type == "SPLIT_CHECK") {
                    //send my bill을 할 경우 푸시로 온다. 처리는?????
                    if(payment != nil) {
                        payment.updatePushChange()
                    }
                }
            }
            
            if(pushType == "requester.share") {
                //아이템 개별 스플릿 경우 노티를 보내야된다.
                let responseType = post["responseType"] as! String
                print("split responseType : \(responseType)")
                
                if(payment != nil) {
                    if(splitAttemptChk) {
                        payment.changeReviewBtn()
                        
                        if(responseType == "ACCEPT") {
                            sendNotificationMessage("Your split request was accepted", title: "TABB")
                        } else if(responseType == "REJECT") {
                            sendNotificationMessage("Your split request was not accepted", title: "TABB")
                        }
                    }
                    
                    if(splitTakeBillChk) {
                        splitTakeBillChk = false
                        payment.updatePushChange()
                        
                        if(responseType == "ACCEPT") {
                            sendNotificationMessage("Your request was accepted", title: "TABB")
                        } else if(responseType == "REJECT") {
                            sendNotificationMessage("Your request was rejected", title: "TABB")
                        }
                    }
                    
                    if(splitSendBillChk) {
                        payment.changeAllReviewBtn()
                        
                        if(responseType == "ACCEPT") {
                            sendNotificationMessage("Your request was accepted", title: "TABB")
                        } else if(responseType == "REJECT") {
                            sendNotificationMessage("Your request was rejected", title: "TABB")
                        }
                    }
                }
                
            }
            
            if(pushType == "response.share") {
                let type = post["type"] as! String
                let responseType = post["responseType"] as! String
                print("split responseType : \(responseType)")
                if(type == "SPLIT_CHECK") {
                    if(responseType == "ACCEPT") {
                        
                    } else if(responseType == "REJECT") {
                        
                    }
                }
                
                if(type == "SPLIT") {
                    if(responseType == "ACCEPT") {
                        
                    } else if(responseType == "REJECT") {
                        if(payment != nil) {
                            payment.updatePushChange()
                        }
                    }
                }
                
                
            }
            
        } catch let error as NSError {
            // Catch fires here, with an NSErrro being thrown from the JSONObjectWithData method
            print("A JSON parsing error occurred, here are the details:\n \(error)")
        }
        
        
    }
    
    func sendNotificationMessage(message: String!, title: String!) {
        AudioServicesPlaySystemSound (1307)
        let notification:UILocalNotification = UILocalNotification()
        notification.alertBody = message
        notification.alertTitle = title
        UIApplication.sharedApplication().scheduleLocalNotification(notification)
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }

    // MARK: - Core Data stack

    lazy var applicationDocumentsDirectory: NSURL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "com.ekay.tabb" in the application's documents Application Support directory.
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        return urls[urls.count-1] 
    }()

    lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelURL = NSBundle.mainBundle().URLForResource("tabb", withExtension: "momd")!
        return NSManagedObjectModel(contentsOfURL: modelURL)!
    }()

    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator? = {
        // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        var coordinator: NSPersistentStoreCoordinator? = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.URLByAppendingPathComponent("tabb.sqlite")
        var error: NSError? = nil
        var failureReason = "There was an error creating or loading the application's saved data."
        do {
            try coordinator!.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: nil)
        } catch var error1 as NSError {
            error = error1
            coordinator = nil
            // Report any error we got.
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data"
            dict[NSLocalizedFailureReasonErrorKey] = failureReason
            dict[NSUnderlyingErrorKey] = error
            error = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog("Unresolved error \(error), \(error!.userInfo)")
            abort()
        } catch {
            fatalError()
        }
        
        return coordinator
    }()

    lazy var managedObjectContext: NSManagedObjectContext? = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        let coordinator = self.persistentStoreCoordinator
        if coordinator == nil {
            return nil
        }
        var managedObjectContext = NSManagedObjectContext()
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        if let moc = self.managedObjectContext {
            var error: NSError? = nil
            if moc.hasChanges {
                do {
                    try moc.save()
                } catch let error1 as NSError {
                    error = error1
                    // Replace this implementation with code to handle the error appropriately.
                    // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    NSLog("Unresolved error \(error), \(error!.userInfo)")
                    abort()
                }
            }
        }
    }

}

