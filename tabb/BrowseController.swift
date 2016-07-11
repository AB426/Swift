//
//  BrowseController.swift
//  tabb
//
//  Created by LeeDongMin on 2015. 10. 21..
//  Copyright © 2015년 LeeDongMin. All rights reserved.
//

import UIKit
import CoreLocation

class BrowseController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var browseBack: UIView!
    @IBOutlet weak var browseTable: UITableView!
    var refreshControl = UIRefreshControl()
    
    var lastId : Double = 0
    var size : Int = 50

//    var instaView : UIView!
    var resTitle : UILabel!
    var instaTitle_front : UILabel!
    var instaTitle_back : UILabel!
 
    var search : SearchViewController!
    
    var locationManager: CLLocationManager?
    let uuidString = "335C530F-9800-45EA-9801-FA03095A3556"
    let beaconIdentifier = "TABB"
    
    var restaurantSelect : RestaurantSelectPopUp = RestaurantSelectPopUp(nibName: "PopupView", bundle: nil)   //비콘 검색후 레스토랑이 2개 이상 나올 경우....

    @IBAction func restaurantSearch(sender: AnyObject) {
        self.presentViewController(self.search, animated: true, completion: nil)
    }
    
    override func loadView() {
        super.loadView()
        
        if(pref.objectForKey("checkinId") as! Double > 0) {
            //checkinChk = true
            checkinId = pref.objectForKey("checkinId") as! Double
            restaurantId = pref.objectForKey("restaurantId") as! Double
            
            if(pref.objectForKey("cartId") != nil) {
                cartId = pref.objectForKey("cartId") as! Double
            }
            
            self.getBrowseMenuList()
        }

        print("checkinId : \(checkinId)")
        print("restaurantId : \(restaurantId)")
        print("cartId : \(cartId)")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager = CLLocationManager()
        
        browse = self

        members = NSArray()
        
        search = storyboard?.instantiateViewControllerWithIdentifier("search") as! SearchViewController
        
        isShowResMenu = false
        isShowInstaMenu = false
        searchType = "POPULARITY"
        restaurantType = "RESTAURANT"
        
        restaurantTable = self.browseTable
        
        self.browseTable.showsVerticalScrollIndicator = false
        //self.browseTable.indicatorStyle = UIS
        
        resView = SearchListView(aView: self.view, title: "SearchList")
        resView.frame = CGRect(x: (screen.size.width * 12 / 414), y: (screen.size.height * 12 / 736), width: (screen.size.width * 196 / 414), height: (screen.size.height * 54 / 736))
        resView.backgroundColor = UIColorFromHex(0xffffff, alpha: 1.0)
        browseBack.addSubview(resView)
        
        resTitle = UILabel()
        resTitle.text = "RESTAURANT"
        resTitle.textColor = UIColorFromHex(0x333333, alpha: 1.0)
        resTitle.textAlignment = .Center
        resTitle.backgroundColor = UIColor.clearColor()
        resTitle.font = UIFont(name: robotoBold, size: (screen.size.width * 15 / 414))
        resTitle.frame = CGRect(x: 0, y: (resView.frame.height - (screen.size.height * 24 / 736)) / 2, width: (screen.size.width * 196 / 414), height: (screen.size.height * 24 / 736))
        resView.addSubview(resTitle)
        
        let resBtn = UIButton()
        resBtn.frame = CGRect(x: (screen.size.width * 12 / 414), y: (screen.size.height * 12 / 736), width: (screen.size.width * 196 / 414), height: (screen.size.height * 54 / 736))
        resBtn.tag = 1
        resBtn.addTarget(self, action: "viewAction:", forControlEvents: UIControlEvents.TouchUpInside)
        browseBack.addSubview(resBtn)
        
        instaView = SearchInstaView(aView: self.view, title: "SearchInstaList")
        instaView.frame = CGRect(x: (screen.size.width * 206 / 414), y: (screen.size.height * 12 / 736), width: (screen.size.width * 196 / 414), height: (screen.size.height * 54 / 736))
        instaView.backgroundColor = UIColorFromHex(0xffffff, alpha: 1.0)
        browseBack.addSubview(instaView)
        instaTitle_front = UILabel()
        instaTitle_front.text = "INSTA"
        instaTitle_front.textColor = UIColorFromHex(0x333333, alpha: 1.0)
        instaTitle_front.textAlignment = .Right
        instaTitle_front.backgroundColor = UIColor.clearColor()
        instaTitle_front.font = UIFont(name: robotoBold, size: (screen.size.width * 15 / 414))
        instaTitle_front.frame = CGRect(x: 0, y: (resView.frame.height - (screen.size.height * 24 / 736)) / 2, width: (screen.size.width * 98 / 414), height: (screen.size.height * 24 / 736))
        
        instaTitle_back = UILabel()
        instaTitle_back.text = "FOOD"
        instaTitle_back.textColor = UIColorFromHex(0x333333, alpha: 1.0)
        instaTitle_back.textAlignment = .Left
        instaTitle_back.backgroundColor = UIColor.clearColor()
        instaTitle_back.font = UIFont(name: roboto, size: (screen.size.width * 15 / 414))
        instaTitle_back.frame = CGRect(x: (screen.size.width * 98 / 414), y: (resView.frame.height - (screen.size.height * 24 / 736)) / 2, width: (screen.size.width * 98 / 414), height: (screen.size.height * 24 / 736))
        instaView.addSubview(instaTitle_front)
        instaView.addSubview(instaTitle_back)
        
        let instaBtn = UIButton()
        instaBtn.frame = CGRect(x: (screen.size.width * 206 / 414), y: (screen.size.height * 12 / 736), width: (screen.size.width * 196 / 414), height: (screen.size.height * 54 / 736))
        instaBtn.tag = 2
        instaBtn.addTarget(self, action: "viewAction:", forControlEvents: UIControlEvents.TouchUpInside)
        browseBack.addSubview(instaBtn)
        
        
        let callView = UIView()
        callView.frame = CGRect(x: (screen.size.width * 321 / 414), y: (screen.size.height * 530 / 736), width: (screen.size.width * 74 / 414), height: (screen.size.height * 74 / 736))
        callView.backgroundColor = UIColorFromHex(0xc13939, alpha: 1.0)
        callView.layer.cornerRadius = callView.frame.size.width / 2
        browseBack.addSubview(callView)
        
        let callImage = UIImageView(image: UIImage(named: "icon_call"))
        callImage.frame = CGRect(x: (screen.size.width * 22.5 / 414), y: (screen.size.height * 22.5 / 736), width: (screen.size.width * 29 / 414), height: (screen.size.height * 29 / 736))
        callView.addSubview(callImage)
        
        let callBtn = UIButton()
        callBtn.frame = CGRect(x: 0, y: 0, width: (screen.size.width * 74 / 414), height: (screen.size.height * 74 / 736))
        callBtn.backgroundColor = UIColor.clearColor()
        callBtn.layer.cornerRadius = callBtn.frame.size.width / 2
        callBtn.clipsToBounds = true
        callBtn.addTarget(self, action: "callAction:", forControlEvents: .TouchUpInside)
        callBtn.setBackgroundImage(UIImage.imageWithColor(UIColorFromHex(0xffffff, alpha: 0.0)), forState: .Normal)
        callBtn.setBackgroundImage(UIImage.imageWithColor(UIColorFromHex(0xffffff, alpha: 0.3)), forState: .Highlighted)
        callView.addSubview(callBtn)
        
        viewBox(resView, value: 0xcccccc, border: 1, radius: 0)
        viewBox(instaView, value: 0xcccccc, border: 1, radius: 0)
        
        //self.getRestaurantList()
        
        // set up the refresh control
        let attributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        let attributedTitle = NSAttributedString(string: "Pull to refresh", attributes: attributes)
        
        refreshControl.attributedTitle = attributedTitle
        self.refreshControl.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
        self.browseTable.addSubview(refreshControl)
    }
    
    func refresh(sender:AnyObject) {
        print("Browse Table View Refresh")
        restaurantList = NSMutableArray()
        lastId = 0
        size = 50
        self.getRestaurantList()
    }
    
    func searchRestaurant() {
        print("scan start")
        
        dispatch_async(dispatch_get_main_queue(), {
            // code here
            showActivityIndicator(windowView)
        })
        
        let beaconUUID = NSUUID(UUIDString: uuidString)
        
        let beaconRegion:CLBeaconRegion = CLBeaconRegion(proximityUUID: beaconUUID!,
            identifier: beaconIdentifier)
        
        locationManager!.delegate = self
        //locationManager!.startRangingBeaconsInRegion(beaconRegion)
        
        locationManager!.startMonitoringForRegion(beaconRegion)
        locationManager!.startRangingBeaconsInRegion(beaconRegion)
        locationManager!.startUpdatingLocation()

        
//        let machineArray: NSMutableArray = NSMutableArray()
//        let value: NSMutableDictionary = NSMutableDictionary()
//        value.setObject(1, forKey: "major")
//        value.setObject(1, forKey: "minor")
//        machineArray.addObject(value)
//        
//        
//        self.getRestaurantBeacon(machineArray)

    }
    
    func locationManager(manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], inRegion region: CLBeaconRegion) {
        print("locationManager")
        let beaconUUID = NSUUID(UUIDString: uuidString)
        let beaconRegion:CLBeaconRegion = CLBeaconRegion(proximityUUID: beaconUUID!,
            identifier: beaconIdentifier)
        if(beacons.count > 0) {
            
            let restaurantArray: NSMutableArray = NSMutableArray()
            for(var counter = 0; counter < beacons.count; counter++) {
                let beacon:CLBeacon = beacons[counter]
                if(uuidString == beacon.proximityUUID.UUIDString) {
                    let value: NSMutableDictionary = NSMutableDictionary()
                    value.setObject(beacon.major, forKey: "major")
                    value.setObject(beacon.minor, forKey: "minor")
                    restaurantArray.addObject(value)
                }
                
                print("UUID : \(beacon.proximityUUID.UUIDString), Major : \(beacon.major), Minor : \(beacon.minor)")
            }
            
            
            self.getRestaurantBeacon(restaurantArray)
            
            locationManager!.stopMonitoringForRegion(beaconRegion)
            locationManager!.stopRangingBeaconsInRegion(beaconRegion)
            locationManager!.stopUpdatingLocation()
        } else {
            
            locationManager!.stopMonitoringForRegion(beaconRegion)
            locationManager!.stopRangingBeaconsInRegion(beaconRegion)
            locationManager!.stopUpdatingLocation()
            dispatch_async(dispatch_get_main_queue(), {
                // code here
                hideActivityIndicator(windowView)
            })
            
            self.getRestaurantList()
        }
    }
    
    func getRestaurantBeacon(machineArray: NSMutableArray) {
        let url: String = serverURL + "user/scan/find"
        let request = NSMutableURLRequest(URL: NSURL(string: url)!)
        
        //let identifier:String = pref.objectForKey("identifier") as! String
        let authId: Double! = pref.objectForKey("authId") as! Double
        let authKey: String! = pref.objectForKey("authKey") as! String
        let newPost: NSDictionary = ["authId": authId, "authKey": authKey, "beaconId": uuidString, "machine" : machineArray]
        
        print(newPost)
        do {
            // Try parsing some valid JSON
            let postData = try NSJSONSerialization.dataWithJSONObject(newPost, options: NSJSONWritingOptions.PrettyPrinted)
            request.HTTPBody = postData
            
        }
        catch let error as NSError {
            // Catch fires here, with an NSErrro being thrown from the JSONObjectWithData method
            print("A JSON parsing error occurred, here are the details:\n \(error)")
        }
        
        request.HTTPMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
            data, response, error in
            
            if let httpResponse = response as? NSHTTPURLResponse {
                print(httpResponse.statusCode)
                if httpResponse.statusCode == 200 {
                    do {
                        // Try parsing some valid JSON
                        let post = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments) as! NSDictionary
                        print("getRestaurantBeacon : \(post)")
                        let status = post["status"] as! Double
                        
                        if status == 0 {
                            //성공
                            scanChk = true

                            
                            let list = post.valueForKey("data")!.valueForKey("items") as! NSArray
                            
                            if(checkInRestaurantList.count > 0) {
                                checkInRestaurantList.removeAllObjects()
                            }
                            
                            for(var index = 0; index < list.count; index++) {
                                checkInRestaurantList.addObject(list[index])
                            }
                            
                            dispatch_async(dispatch_get_main_queue(), {
                                hideActivityIndicator(windowView)
                                self.restaurantSelect = RestaurantSelectPopUp(nibName: "PopupView", bundle: nil)
                                self.restaurantSelect.showInView(self.view, withMessage: "Select Restaurant", animated: true, items: checkInRestaurantList)
                            })
                            
                            
                            //self.getRestaurantList()
                            
                        } else if(status == 705){
                            scanChk = false
                            restaurantList = NSMutableArray()
                            self.getRestaurantList()
 
                        } else {
                            restaurantList = NSMutableArray()
                            scanChk = false
                            self.getRestaurantList()
                            
                            let errorMsg: String! = post["error"] as! String
                            print(errorMsg)
                        }
                        
                    }
                    catch let error as NSError {
                        // Catch fires here, with an NSErrro being thrown from the JSONObjectWithData method
                        dispatch_async(dispatch_get_main_queue(), {
                            // code here
                            hideActivityIndicator(windowView)
                            customPop.showInView(self.view, withMessage: "Error occurred during communicating with server. Please try again in a few minutes.", animated: true)
                        })
                        print("A JSON parsing error occurred, here are the details:\n \(error)")
                    }
                } else {
                    
                    
                    dispatch_async(dispatch_get_main_queue(), {
                        // code here
                        hideActivityIndicator(windowView)
                        customPop.showInView(self.view, withMessage: "Error occurred during communicating with server. Please try again in a few minutes.", animated: true)
                    })
                    
                    print("response was not 200: \(response)")
                    return
                }
            }
            if (error != nil) {
                dispatch_async(dispatch_get_main_queue(), {
                    // code here
                    hideActivityIndicator(windowView)
                    customPop.showInView(self.view, withMessage: "Error occurred during communicating with server. Please try again in a few minutes.", animated: true)
                })
                print("error submitting request: \(error)")
                return
            }
        }
        task.resume()
    }
    
    func callAction(sender : AnyObject?) {
        if(checkinId == 0) {
//            customPop.showInView(self.view, withMessage: "Error occurred during communicating with server. Please try again in a few minutes.", animated: true)
            return;
        }
        
        dispatch_async(dispatch_get_main_queue(), {
            showActivityIndicator(windowView)
        })
        
        let url: String = serverURL + "user/serviceCall/list"
        let request = NSMutableURLRequest(URL: NSURL(string: url)!)
        
        let authId: Double! = pref.objectForKey("authId") as! Double
        let authKey: String! = pref.objectForKey("authKey") as! String
        
        let newPost: NSDictionary = ["authId": authId, "authKey": authKey, "checkinId" : checkinId]
        do {
            // Try parsing some valid JSON
            let postData = try NSJSONSerialization.dataWithJSONObject(newPost, options: NSJSONWritingOptions.PrettyPrinted)
            request.HTTPBody = postData
            
        }
        catch let error as NSError {
            // Catch fires here, with an NSErrro being thrown from the JSONObjectWithData method
            print("A JSON parsing error occurred, here are the details:\n \(error)")
        }
        
        request.HTTPMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
            data, response, error in
            
            if let httpResponse = response as? NSHTTPURLResponse {
                print(httpResponse.statusCode)
                if httpResponse.statusCode == 200 {
                    do {
                        // Try parsing some valid JSON
                        let post = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments) as! NSDictionary
                        //print(post)
                        let status = post["status"] as! Double
                        
                        if status == 0 {
                            //성공
                            let data = post["data"] as! NSDictionary
                            serviceCallList = data.objectForKey("items") as! NSDictionary
                            dispatch_async(dispatch_get_main_queue(), {
                                // code here
                                hideActivityIndicator(windowView)
                                serviceCall = ServiceCallViewController(nibName: "PopupView", bundle: nil)
                                serviceCall.showInView(self.view, withMessage: "Service Call", animated: true)
                            })
                        } else {
                            dispatch_async(dispatch_get_main_queue(), {
                                hideActivityIndicator(windowView)
                                customPop.showInView(self.view, withMessage: "Error occurred during communicating with server. Please try again in a few minutes.", animated: true)
                            })
                        }
                        
                    }
                    catch let error as NSError {
                        // Catch fires here, with an NSErrro being thrown from the JSONObjectWithData method
                        dispatch_async(dispatch_get_main_queue(), {
                            hideActivityIndicator(windowView)
                            customPop.showInView(self.view, withMessage: "Error occurred during communicating with server. Please try again in a few minutes.", animated: true)
                        })
                        print("A JSON parsing error occurred, here are the details:\n \(error)")
                    }
                    
                } else {
                    dispatch_async(dispatch_get_main_queue(), {
                        hideActivityIndicator(windowView)
                        customPop.showInView(self.view, withMessage: "Error occurred during communicating with server. Please try again in a few minutes.", animated: true)
                    })
                    print("response was not 200: \(response)")
                    return
                }
            }
            if (error != nil) {
                dispatch_async(dispatch_get_main_queue(), {
                    hideActivityIndicator(windowView)
                    customPop.showInView(self.view, withMessage: "Error occurred during communicating with server. Please try again in a few minutes.", animated: true)
                })
                print("error submitting request: \(error)")
                return
            }
        }
        task.resume()
        
        
    }
    
    internal func viewAction(sender : AnyObject?) {
        print("isShowResMenu : \(isShowResMenu)")
        print("isShowInstaMenu : \(isShowInstaMenu)")
        if(sender!.tag == 1) {
            orderMethodCheck = false
            restaurantType = "RESTAURANT"
            resView.backgroundColor = UIColorFromHex(0xfe7c7c, alpha: 1.0)
            instaView.backgroundColor = UIColorFromHex(0xffffff, alpha: 1.0)
            resTitle.textColor = UIColor.whiteColor()
            instaTitle_front.textColor = UIColorFromHex(0x333333, alpha: 1.0)
            instaTitle_back.textColor = UIColorFromHex(0x333333, alpha: 1.0)
            
            //instaView.hideMenu()
            isShowInstaMenu = false
            if(isShowResMenu == false) {
                resView.showMenu()
                isShowResMenu = true
            } else {
                resView.hideMenu()
                isShowResMenu = false
            }
            
        } else {
            orderMethodCheck = true
            resView.backgroundColor = UIColorFromHex(0xffffff, alpha: 1.0)
            instaView.backgroundColor = UIColorFromHex(0xfe7c7c, alpha: 1.0)
            resTitle.textColor = UIColorFromHex(0x333333, alpha: 1.0)
            instaTitle_front.textColor = UIColor.whiteColor()
            instaTitle_back.textColor = UIColor.whiteColor()

            resView.hideMenu()
            isShowResMenu = false
            if(isShowInstaMenu == false) {
                instaView.showMenu()
                isShowInstaMenu = true
            } else {
                instaView.hideMenu()
                isShowInstaMenu = false
            }

            restaurantType = "INSTAGRAM"
        }
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        print("browse viewDidAppear")
        print("viewCount : \(viewCount)")
        print("checkinChk : \(checkinChk)")
        
        dispatch_async(dispatch_get_main_queue(), {
            showActivityIndicator(windowView)
        })
        
        
        if(searchCheck == true) {
            ++viewCount;
            
            if(viewCount == 1) {
                searchCheck = false
                self.getRestaurantList()
            }
        } else {
            if(likeChk == true) {
                ++viewCount;
                
                if(viewCount == 1) {
                    likeChk = false
                    self.getRestaurantList()
                }

            } else {
                ++viewCount;
                
                if(viewCount == 1) {
                    if(checkinChk == true) {
                        self.getBrowseMenuList()
                    } else {
                        if(checkinId < 1) {
                            self.searchRestaurant()
                        }
                    }
                }

            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func getRestaurantList() {
        
        //customPop = CustomPopUp(nibName: "PopupView", bundle: nil)
        
        let url: String = serverURL + "user/restaurant/list"
        let request = NSMutableURLRequest(URL: NSURL(string: url)!)
        
        let authId: Double! = pref.objectForKey("authId") as! Double
        let authKey: String! = pref.objectForKey("authKey") as! String
        
        var alertMsg : String!
        
        var newPost: NSDictionary = NSDictionary()
        
        switch(searchType) {
        case "NAME":
            newPost = ["authId": authId, "authKey": authKey, "type" : restaurantType, "lastId":lastId, "size": size, "searchType" : searchType, "name" : searchName]
            alertMsg = "Sorry, we don't have any listing under this category yet."
            break;
        case "LOCATION":
            newPost = ["authId": authId, "authKey": authKey, "type" : restaurantType, "lastId":lastId, "size": size, "searchType" : searchType, "location" : restaurantLocation]
            alertMsg = "Sorry, we don't have any listing under this category yet."
            break;
        case "FOOD_TYPE":
            newPost = ["authId": authId, "authKey": authKey, "type" : restaurantType, "lastId":lastId, "size": size, "searchType" : searchType, "foodType" : foodType]
            alertMsg = "Sorry, we don't have any listing under this category yet."
            break;
        case "POPULARITY":
            newPost = ["authId": authId, "authKey": authKey, "type" : restaurantType, "lastId":lastId, "size": size, "searchType" : searchType]
            alertMsg = "Sorry, we don't have any listing under this category yet."
            break;
        case "FAVORITES":
            newPost = ["authId": authId, "authKey": authKey, "type" : restaurantType, "lastId":lastId, "size": size, "searchType" : searchType]
            alertMsg = "You have no favorite yet."
            break;
        default:
            break;
        }

        print("browse search : \(newPost)")
        
        do {
            // Try parsing some valid JSON
            let postData = try NSJSONSerialization.dataWithJSONObject(newPost, options: NSJSONWritingOptions.PrettyPrinted)
            request.HTTPBody = postData
            
        }
        catch let error as NSError {
            // Catch fires here, with an NSErrro being thrown from the JSONObjectWithData method
            print("A JSON parsing error occurred, here are the details:\n \(error)")
        }
        
        request.HTTPMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
            data, response, error in
            
            if let httpResponse = response as? NSHTTPURLResponse {
                if httpResponse.statusCode == 200 {
                    do {
                        // Try parsing some valid JSON
                        let post = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments) as! NSDictionary
                        //print(post)
                        let status = post["status"] as! Double
                        
                        if status == 0 {
                            //성공
                            let data = post["data"] as! NSDictionary
                            let chk: AnyObject? = data.valueForKey("items")
                            
                            if(chk?.count == 0) {
                                
                                restaurantList = NSMutableArray()
                                restaurantImageBool = NSMutableArray()
                                
                                dispatch_async(dispatch_get_main_queue(), {
                                    // code here
                                    hideActivityIndicator(windowView)
                                    if(restaurantTable != nil) {
                                        restaurantTable.reloadData()
                                    }
                                    customPop.showInView(self.view, withMessage: alertMsg, animated: true)
                                })
                                
                                // tell refresh control it can stop showing up now
                                if self.refreshControl.refreshing {
                                    self.refreshControl.endRefreshing()
                                }

                            } else {
                                let list = data.valueForKey("items") as! NSArray
                                
                                if(restaurantList.count > 0) {
                                    restaurantList.removeAllObjects()
                                }
                                
                                for(var index = 0; index < list.count; index++) {
                                    restaurantList.addObject(list[index])
                                }
                                
                                
                                for _ in 0...(restaurantList.count - 1)  {
                                    restaurantImageBool.addObject(false)
                                }
                                
                                dispatch_async(dispatch_get_main_queue(), {
                                    hideActivityIndicator(windowView)
                                    restaurantTable.reloadData()
                                })
                                
                                // tell refresh control it can stop showing up now
                                if self.refreshControl.refreshing {
                                    self.refreshControl.endRefreshing()
                                }
                            }
                            
                        } else {
                            let errorMsg: String! = post["error"] as! String
                            print(errorMsg)
                            
                            dispatch_async(dispatch_get_main_queue(), {
                                // code here
                                hideActivityIndicator(windowView)
                                
                                customPop.showInView(self.view, withMessage: "Error occurred during communicating with server. Please try again in a few minutes.", animated: true)
                            })
                            
                            // tell refresh control it can stop showing up now
                            if self.refreshControl.refreshing {
                                self.refreshControl.endRefreshing()
                            }
                        }
                        
                    }
                    catch let error as NSError {
                        // Catch fires here, with an NSErrro being thrown from the JSONObjectWithData method
                        print("A JSON parsing error occurred, here are the details:\n \(error)")
                        
                        dispatch_async(dispatch_get_main_queue(), {
                            hideActivityIndicator(windowView)
                            customPop.showInView(self.view, withMessage: "Error occurred during communicating with server. Please try again in a few minutes.", animated: true)
                        })
                        
                        // tell refresh control it can stop showing up now
                        if self.refreshControl.refreshing {
                            self.refreshControl.endRefreshing()
                        }
                    }
                    
                } else {
                    print("response was not 200: \(response)")
                    
                    dispatch_async(dispatch_get_main_queue(), {
                        // code here
                        hideActivityIndicator(windowView)
                        customPop.showInView(self.view, withMessage: "Error occurred during communicating with server. Please try again in a few minutes.", animated: true)
                    })

                    // tell refresh control it can stop showing up now
                    if self.refreshControl.refreshing {
                        self.refreshControl.endRefreshing()
                    }
                    return
                }
            }
            if (error != nil) {
                print("error submitting request: \(error)")
                dispatch_async(dispatch_get_main_queue(), {
                    hideActivityIndicator(windowView)
                    customPop.showInView(self.view, withMessage: "Error occurred during communicating with server. Please try again in a few minutes.", animated: true)
                })
                
                // tell refresh control it can stop showing up now
                if self.refreshControl.refreshing {
                    self.refreshControl.endRefreshing()
                }
                return
            }
        }
        task.resume()
    }
    
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // Return the number of sections.
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return restaurantList.count
    }
    
//    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
//        return (tableView.frame.height * 212) / 600
//    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("BrowseCell", forIndexPath: indexPath) as! BrowseTableCell
        cell.listImg.hidden = true
        //if(restaurantImageBool.objectAtIndex(indexPath.row).boolValue == false) {
            let activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
            dispatch_async(dispatch_get_main_queue(), {
                activityIndicator.frame = CGRectMake(0.0, 0.0, 40.0, 40.0);
                activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.WhiteLarge
                activityIndicator.center = CGPointMake(cell.loadingView.frame.size.width / 2, cell.loadingView.frame.size.height / 2);
                cell.loadingView.addSubview(activityIndicator)
                activityIndicator.startAnimating()
                
            })
            
            if let url = NSURL(string: (restaurantList[indexPath.row].valueForKey("picture") as? String)!) {
                let request = NSURLRequest(URL: url)
                NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) {
                    (response: NSURLResponse?, data: NSData?, error: NSError?) -> Void in
                    if let imageData = data as NSData? {
                        cell.listImg.image = UIImage(data: imageData)
                        cell.listImg.hidden = false
                        dispatch_async(dispatch_get_main_queue(), {
                            activityIndicator.stopAnimating()
                            activityIndicator.removeFromSuperview()
                        })
                    }
                }
            }
            
            //restaurantImageBool.replaceObjectAtIndex(indexPath.row, withObject: true)
        //}

        cell.listImg.contentMode = UIViewContentMode.ScaleAspectFill

        cell.listName.text = restaurantList[indexPath.row].valueForKey("name") as? String
        cell.listFoodType.text = restaurantList[indexPath.row].valueForKey("foodTypeDescr") as? String
        
        //기본 세팅으로 변경
        cell.badge.frame = CGRect(x: 35, y: 20, width: 24, height: 24)
        let content: NSString = (restaurantList[indexPath.row].valueForKey("favoritesCount")?.description)!
        let labelSize = content.sizeWithAttributes([NSFontAttributeName: UIFont.systemFontOfSize(12)])
        if(labelSize.width > 24) {
            cell.badge.frame = CGRect(x: 35, y: 20, width: (labelSize.width + 10), height: 24)
        }
        cell.badge.text = restaurantList[indexPath.row].valueForKey("favoritesCount")?.description
        
        if((restaurantList[indexPath.row].valueForKey("favoritesCount") as! Int) == 0) {
            cell.badge.hidden = true
        } else {
            cell.badge.hidden = false
        }
        
        let like = restaurantList[indexPath.row].valueForKey("like") as? Bool
        if(like == true) {
            cell.listLikeHeart.setBackgroundImage(UIImage(named: "icon_heart_r")?.alpha(1.0), forState: .Normal)
        } else {
            cell.listLikeHeart.setBackgroundImage(UIImage(named: "icon_heart")?.alpha(0.25), forState: .Normal)
        }

        //grade
        let grade = restaurantList[indexPath.row].valueForKey("grade") as! Double
        
        gradeVisible(cell.starList, grade: grade)

        let border = CALayer()
        border.backgroundColor = UIColorFromHex(0x222222, alpha: 1.0).CGColor
        border.frame = CGRect(x: 0, y: 0, width: cell.frame.width, height: 12)
        
        cell.layer.addSublayer(border)
        
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        restaurantId = (restaurantList[indexPath.row].valueForKey("restaurantId") as? Double)!
        self.getRestaurantView(restaurantId)
        
        //self.performSegueWithIdentifier("resMain", sender: indexPath)
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if !(indexPath.row + 1 < size) {
            print("willDisplayCell")
            print("restaurantId = \(restaurantList[indexPath.row].objectForKey("restaurantId") as! Double)")
            
            lastId = restaurantList[indexPath.row].objectForKey("restaurantId") as! Double
            size = size + 50
            
            self.getRestaurantList()
        }
    }
    
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        //Bottom Refresh
        if scrollView == self.browseTable{
            
            if ((scrollView.contentOffset.y + scrollView.frame.size.height) >= scrollView.contentSize.height) {
                
                print("scrollViewDidEndDragging")

            }
        }
    }
    
    
    func getRestaurantView(restaurantId : Double) {
        
        customPop = CustomPopUp(nibName: "PopupView", bundle: nil)
        
        let url: String = serverURL + "user/restaurant/view"
        let request = NSMutableURLRequest(URL: NSURL(string: url)!)
        
        let authId: Double! = pref.objectForKey("authId") as! Double
        let authKey: String! = pref.objectForKey("authKey") as! String
        
        let newPost: NSDictionary = ["authId": authId, "authKey": authKey, "restaurantId": restaurantId]

        do {
            // Try parsing some valid JSON
            let postData = try NSJSONSerialization.dataWithJSONObject(newPost, options: NSJSONWritingOptions.PrettyPrinted)
            request.HTTPBody = postData
            
        }
        catch let error as NSError {
            // Catch fires here, with an NSErrro being thrown from the JSONObjectWithData method
            print("A JSON parsing error occurred, here are the details:\n \(error)")
        }
        
        request.HTTPMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
            data, response, error in
            
            if let httpResponse = response as? NSHTTPURLResponse {
                if httpResponse.statusCode == 200 {
                    do {
                        // Try parsing some valid JSON
                        let post = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments) as! NSDictionary
                        print(post)
                        let status = post["status"] as! Double
                        
                        if status == 0 {
                            //성공
                            restaurantView = post["data"] as! NSDictionary
                            dispatch_async(dispatch_get_main_queue(), {
                                hideActivityIndicator(windowView)
                                if(orderMethodCheck) {
                                    self.performSegueWithIdentifier("resMain", sender: nil)
                                } else {
                                    if(!scanChk) {
                                        self.performSegueWithIdentifier("resMain", sender: nil)
                                    } else {
                                        self.performSegueWithIdentifier("checkin", sender: nil)
                                    }
                                }
                            })
                        } else {
                            let errorMsg: String! = post["error"] as! String
                            print(errorMsg)
                            
                            dispatch_async(dispatch_get_main_queue(), {
                                hideActivityIndicator(windowView)
                                customPop.showInView(self.view, withMessage: "Error occurred during communicating with server. Please try again in a few minutes.", animated: true)
                            })
                        }
                        
                    }
                    catch let error as NSError {
                        // Catch fires here, with an NSErrro being thrown from the JSONObjectWithData method
                        print("A JSON parsing error occurred, here are the details:\n \(error)")
                        dispatch_async(dispatch_get_main_queue(), {
                            hideActivityIndicator(windowView)
                            customPop.showInView(self.view, withMessage: "Error occurred during communicating with server. Please try again in a few minutes.", animated: true)
                        })
                    }
                    
                } else {
                    print("response was not 200: \(response)")
                    dispatch_async(dispatch_get_main_queue(), {
                        hideActivityIndicator(windowView)
                        customPop.showInView(self.view, withMessage: "Error occurred during communicating with server. Please try again in a few minutes.", animated: true)
                    })
                    return
                }
            }
            if (error != nil) {
                print("error submitting request: \(error)")
                dispatch_async(dispatch_get_main_queue(), {
                    hideActivityIndicator(windowView)
                    customPop.showInView(self.view, withMessage: "Error occurred during communicating with server. Please try again in a few minutes.", animated: true)
                })
                return
            }
        }
        task.resume()
    }
    
    func getServiceCallList() {
        
    }
    
    //체크인이 되어있을 경우....
    func getBrowseMenuList() {
        let url: String = serverURL + "user/category/list"
        let request = NSMutableURLRequest(URL: NSURL(string: url)!)
        
        let authId: Double! = pref.objectForKey("authId") as! Double
        let authKey: String! = pref.objectForKey("authKey") as! String
        
        let newPost: NSDictionary = ["authId": authId, "authKey": authKey, "restaurantId": restaurantId, "lastId" : 0, "size" : 30]
        do {
            // Try parsing some valid JSON
            let postData = try NSJSONSerialization.dataWithJSONObject(newPost, options: NSJSONWritingOptions.PrettyPrinted)
            request.HTTPBody = postData
            
        }
        catch let error as NSError {
            // Catch fires here, with an NSErrro being thrown from the JSONObjectWithData method
            print("A JSON parsing error occurred, here are the details:\n \(error)")
        }
        
        request.HTTPMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
            data, response, error in
            
            if let httpResponse = response as? NSHTTPURLResponse {
                print(httpResponse.statusCode)
                if httpResponse.statusCode == 200 {
                    do {
                        // Try parsing some valid JSON
                        let post = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments) as! NSDictionary
                        //print(post)
                        let status = post["status"] as! Double
                        
                        if status == 0 {
                            //성공
                            let data = post["data"] as! NSDictionary
                            
                            let chk: AnyObject? = data.valueForKey("categories")
                            
                            if(chk?.count == 0) {
                                dispatch_async(dispatch_get_main_queue(), {
                                    // code here
                                    hideActivityIndicator(windowView)
                                })
                            } else {
                                //hideActivityIndicator(self.view)
                                //print(data.valueForKey("categories"))
                                categories = data.valueForKey("categories") as! NSArray
                                
                                dispatch_async(dispatch_get_main_queue(), {
                                    // code here
                                    hideActivityIndicator(windowView)
                                    checkinChk = true
                                    self.performSegueWithIdentifier("alreadyCheckBrowseMenu", sender: nil)
                                })
                            }
                        } else {
                            let errorMsg: String! = post["error"] as! String
                            print(errorMsg)
                            dispatch_async(dispatch_get_main_queue(), {
                                hideActivityIndicator(windowView)
                                customPop.showInView(self.view, withMessage: "Error occurred during communicating with server. Please try again in a few minutes.", animated: true)
                            })
                        }
                        
                        
                        
                    }
                    catch let error as NSError {
                        // Catch fires here, with an NSErrro being thrown from the JSONObjectWithData method
                        print("A JSON parsing error occurred, here are the details:\n \(error)")
                        dispatch_async(dispatch_get_main_queue(), {
                            hideActivityIndicator(windowView)
                            customPop.showInView(self.view, withMessage: "Error occurred during communicating with server. Please try again in a few minutes.", animated: true)
                        })
                    }
                    
                } else {
                    print("response was not 200: \(response)")
                    dispatch_async(dispatch_get_main_queue(), {
                        hideActivityIndicator(windowView)
                        customPop.showInView(self.view, withMessage: "Error occurred during communicating with server. Please try again in a few minutes.", animated: true)
                    })
                    return
                }
            }
            if (error != nil) {
                print("error submitting request: \(error)")
                dispatch_async(dispatch_get_main_queue(), {
                    hideActivityIndicator(windowView)
                    customPop.showInView(self.view, withMessage: "Error occurred during communicating with server. Please try again in a few minutes.", animated: true)
                })
                return
            }
        }
        task.resume()
        
    }


}
