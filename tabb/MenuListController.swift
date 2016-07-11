//
//  MenuListController.swift
//  tabb
//
//  Created by LeeDongMin on 2015. 10. 29..
//  Copyright © 2015년 LeeDongMin. All rights reserved.
//

import UIKit

class MenuListController: UIViewController {

    @IBOutlet weak var back: UIBarButtonItem!
    @IBOutlet weak var menuListTable: UITableView!
    @IBOutlet weak var menuListBack: UIView!
    
    var search : SearchViewController!
    
    var cartPop : PopUpViewController = PopUpViewController(nibName: "PopupView", bundle: nil)
    var optionsPop : DishOptionViewPopUp = DishOptionViewPopUp(nibName: "PopupView", bundle: nil)
    
    var lastId : Double = 0
    var size : Int = 50
    var refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        dispatch_async(dispatch_get_main_queue(), {
            showActivityIndicator(windowView)
        })
        
        menuListController = self
        
        self.menuListTable.showsVerticalScrollIndicator = false
        
        let callView = UIView()
        callView.frame = CGRect(x: (screen.size.width * 321 / 414), y: (screen.size.height * 530 / 736), width: (screen.size.width * 74 / 414), height: (screen.size.height * 74 / 736))
        callView.backgroundColor = UIColorFromHex(0xc13939, alpha: 1.0)
        callView.layer.cornerRadius = callView.frame.size.width / 2
        menuListBack.addSubview(callView)
        
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
        
        self.getMenuList()
        
        // set up the refresh control
        let attributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        let attributedTitle = NSAttributedString(string: "Pull to refresh", attributes: attributes)
        
        refreshControl.attributedTitle = attributedTitle
        self.refreshControl.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
        self.menuListTable.addSubview(refreshControl)
    }
    
    func refresh(sender:AnyObject) {
        print("Browse Table View Refresh")
        menuList = NSArray()
        lastId = 0
        size = 50
        self.getMenuList()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        if(searchCheck == true) {
            self.navigationController?.popToRootViewControllerAnimated(true)
        }
        
        if(notCheck) {
            notCheck = false
            self.navigationController?.popToRootViewControllerAnimated(true)
        }
    }
    
    func callAction(sender : AnyObject?) {
        if(checkinId == 0) {
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
                            })
                            let errorMsg: String! = post["error"] as! String
                            print(errorMsg)
                        }
                        
                    }
                    catch let error as NSError {
                        // Catch fires here, with an NSErrro being thrown from the JSONObjectWithData method
                        dispatch_async(dispatch_get_main_queue(), {
                            hideActivityIndicator(windowView)
                        })
                        print("A JSON parsing error occurred, here are the details:\n \(error)")
                    }
                    
                } else {
                    dispatch_async(dispatch_get_main_queue(), {
                        hideActivityIndicator(windowView)
                    })
                    print("response was not 200: \(response)")
                    return
                }
            }
            if (error != nil) {
                dispatch_async(dispatch_get_main_queue(), {
                    hideActivityIndicator(windowView)
                })
                print("error submitting request: \(error)")
                return
            }
        }
        task.resume()
    }
    
    @IBAction func backPressed(sender: AnyObject?) {
        menuList = NSArray()
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func restaurantSearch(sender: AnyObject) {
        search = storyboard?.instantiateViewControllerWithIdentifier("search") as! SearchViewController
        
        self.presentViewController(self.search, animated: true, completion: nil)
    }

    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // Return the number of sections.
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuList.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("menuListCell", forIndexPath: indexPath) as! MenuListTableCell
        
        let activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
        dispatch_async(dispatch_get_main_queue(), {
            activityIndicator.frame = CGRectMake(0.0, 0.0, 40.0, 40.0);
            activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.WhiteLarge
            activityIndicator.center = CGPointMake(cell.loadingView.frame.size.width / 2, cell.loadingView.frame.size.height / 2);
            cell.loadingView.addSubview(activityIndicator)
            activityIndicator.startAnimating()
            
        })
        
        if let url = NSURL(string: (menuList[indexPath.row].valueForKey("picture") as? String)!) {
            let request = NSURLRequest(URL: url)
            NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) {
                (response: NSURLResponse?, data: NSData?, error: NSError?) -> Void in
                if let imageData = data as NSData? {
                    cell.menuListImg.image = UIImage(data: imageData)
                    
                    dispatch_async(dispatch_get_main_queue(), {
                        activityIndicator.stopAnimating()
                        activityIndicator.removeFromSuperview()
                    })
                }
            }
        }
        
        //cell.menuListImg.imageFromUrl((menuList[indexPath.row].valueForKey("picture") as? String)!)
        cell.menuListImg.clipsToBounds = true
        cell.menuListImg.contentMode = UIViewContentMode.ScaleAspectFill

        cell.menuListTitle.text = menuList[indexPath.row].valueForKey("name") as? String
        cell.menuListPrice.text = ((menuList[indexPath.row].valueForKey("price") as! Double).format(someDoubleFormat))

        //기본 세팅으로 변경
        cell.badge.frame = CGRect(x: 35, y: 20, width: 24, height: 24)
        let content: NSString = (menuList[indexPath.row].valueForKey("favoritesCount")?.description)!
        let labelSize = content.sizeWithAttributes([NSFontAttributeName: UIFont.systemFontOfSize(12)])

        //badge 사이즈 변경
        if(labelSize.width > 24) {
            cell.badge.frame = CGRect(x: 35, y: 20, width: (labelSize.width + 10), height: 24)
        }
        cell.badge.text = menuList[indexPath.row].valueForKey("favoritesCount")?.description
        
        if((menuList[indexPath.row].valueForKey("favoritesCount") as! Int) == 0) {
            cell.badge.hidden = true
        }
        
        cell.menuListAdd.addTarget(self, action: "addCart:", forControlEvents: .TouchUpInside)
        cell.menuListAdd.tag = indexPath.row
        
        let like = menuList[indexPath.row].valueForKey("like") as? Bool
        if(like == true) {
            cell.menuListHeart.image = UIImage(named: "icon_heart_r")?.alpha(1.0)
        } else {
            cell.menuListHeart.image = UIImage(named: "icon_heart")?.alpha(0.25)
        }
        
        //grade
        let grade = menuList[indexPath.row].valueForKey("grade") as! Double
        
        gradeVisible(cell.starList, grade: grade)
        
        let border = CALayer()
        border.backgroundColor = UIColorFromHex(0x222222, alpha: 1.0).CGColor
        border.frame = CGRect(x: 0, y: 0, width: cell.frame.width, height: 12)
        
        if(indexPath.row == menuList.count) {
            border.frame = CGRect(x: 0, y: 0, width: cell.frame.width, height: (screen.size.height * 75 / 736))
        }
        
        cell.layer.addSublayer(border)
        
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print(indexPath.row)
        dispatch_async(dispatch_get_main_queue(), {
            showActivityIndicator(windowView)
        })
        foodId = menuList[indexPath.row].valueForKey("foodId") as? Double
        self.getDishView()
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if !(indexPath.row + 1 < size) {            
            lastId = restaurantList[indexPath.row].objectForKey("restaurantId") as! Double
            size = size + 50
            
            self.getMenuList()
        }
    }
    
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        //Bottom Refresh
        if scrollView == self.menuListTable{
            
            if ((scrollView.contentOffset.y + scrollView.frame.size.height) >= scrollView.contentSize.height) {
                
                print("scrollViewDidEndDragging")
                
            }
        }
    }
    
    func getDishView() {
        let url: String = serverURL + "user/food/view"
        let request = NSMutableURLRequest(URL: NSURL(string: url)!)
        
        let authId: Double! = pref.objectForKey("authId") as! Double
        let authKey: String! = pref.objectForKey("authKey") as! String

        let newPost: NSDictionary = ["authId": authId, "authKey": authKey, "foodId": foodId]
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
                            foodViewData = post["data"] as! NSDictionary
                            dispatch_async(dispatch_get_main_queue(), {
                                hideActivityIndicator(windowView)
                                self.performSegueWithIdentifier("resMenuView", sender: nil)
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
    
    func addCart(sender: AnyObject?) {
        
        let options = menuList[sender!.tag].objectForKey("options") as! NSArray
        foodId = menuList[sender!.tag].valueForKey("foodId") as? Double
        if(options.count > 0) {
            //옵션이 존재한다면!!!
            menuListGoCart = true
            optionsList.removeAllObjects()
            optionsPop = DishOptionViewPopUp(nibName: "PopupView", bundle: nil)
            optionsPop.showInView(self.view, withMessage: "Food Options", animated: true, items: options)
        } else {
            self.goCart()
        }
    }
    
    func goCart() {
        
        toppingsList.removeAllObjects()
        excludesList.removeAllObjects()

        let url: String = serverURL + "user/cartItem/add"
        let request = NSMutableURLRequest(URL: NSURL(string: url)!)
        
        let authId: Double! = pref.objectForKey("authId") as! Double
        let authKey: String! = pref.objectForKey("authKey") as! String
        
        let newPost: NSDictionary = ["authId": authId, "authKey": authKey, "checkinId": checkinId, "foodId":foodId, "quantity" : 1, "toppings" : toppingsList, "options" : optionsList, "excludes" : excludesList]
        
        print("cart add \(newPost)")
        
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
                            
                            
                            let data = post["data"] as! NSDictionary
                            cartId = data.objectForKey("cartId") as! Double
                            pref.setValue(cartId, forKey: "cartId")
                            dispatch_async(dispatch_get_main_queue(), {
                                dishViewBackFlag = false
                                self.cartPop.showInView(self.view, withMessage: "cartPop", animated: true)
                            })
                        } else {
                            dispatch_async(dispatch_get_main_queue(), {
                                customPop.showInView(self.view, withMessage: "Error occurred during communicating with server. Please try again in a few minutes.", animated: true)
                            })
                        }
                        
                    }
                    catch let error as NSError {
                        // Catch fires here, with an NSErrro being thrown from the JSONObjectWithData method
                        print("A JSON parsing error occurred, here are the details:\n \(error)")
                        dispatch_async(dispatch_get_main_queue(), {
                            customPop.showInView(self.view, withMessage: "Error occurred during communicating with server. Please try again in a few minutes.", animated: true)
                        })
                    }
                    
                } else {
                    print("response was not 200: \(response)")
                    dispatch_async(dispatch_get_main_queue(), {
                        customPop.showInView(self.view, withMessage: "Error occurred during communicating with server. Please try again in a few minutes.", animated: true)
                    })
                    return
                }
            }
            if (error != nil) {
                print("error submitting request: \(error)")
                dispatch_async(dispatch_get_main_queue(), {
                    customPop.showInView(self.view, withMessage: "Error occurred during communicating with server. Please try again in a few minutes.", animated: true)
                })
                return
            }
        }
        task.resume()
        
        
    }
    
    func getMenuList() {
        let url: String = serverURL + "user/food/list"
        let request = NSMutableURLRequest(URL: NSURL(string: url)!)
        
        let authId: Double! = pref.objectForKey("authId") as! Double
        let authKey: String! = pref.objectForKey("authKey") as! String
        
        let newPost: NSDictionary = ["authId": authId, "authKey": authKey, "restaurantId": restaurantId, "categoryId" : categoryId, "lastId" : lastId, "size" : size]
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
                        print(post)
                        let status = post["status"] as! Double
                        
                        if status == 0 {
                            //성공
                            
                            let data = post["data"] as! NSDictionary
                            
                            print(data)
                            
                            let chk: AnyObject? = data.valueForKey("items")
                            
                            if(chk?.count == 0) {
                                
                            } else {
                                menuList = data.valueForKey("items") as! NSArray
                                dispatch_async(dispatch_get_main_queue(), {
                                    // code here
                                    self.menuListTable.reloadData()
                                })
                                
                                
                            }
                            
                            dispatch_async(dispatch_get_main_queue(), {
                                hideActivityIndicator(windowView)
                            })
                            
                        } else {
                            dispatch_async(dispatch_get_main_queue(), {
                                hideActivityIndicator(windowView)
                                customPop.showInView(self.view, withMessage: "Error occurred during communicating with server. Please try again in a few minutes.", animated: true)
                            })
                            
                            
                        }
                        
                        // tell refresh control it can stop showing up now
                        if self.refreshControl.refreshing {
                            self.refreshControl.endRefreshing()
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

}
