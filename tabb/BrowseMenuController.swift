//
//  BrowseMenuController.swift
//  tabb
//
//  Created by LeeDongMin on 2015. 10. 29..
//  Copyright © 2015년 LeeDongMin. All rights reserved.
//

import UIKit

class BrowseMenuController: UIViewController {

    @IBOutlet weak var back: UIBarButtonItem!
    @IBOutlet weak var browseMenuTable: UITableView!
    @IBOutlet weak var browseMenuBack: UIView!
    
    @IBOutlet weak var backKey: UIBarButtonItem!
    var search : SearchViewController!
    
    var barButton: UIBarButtonItem!
    
    var lastId : Double = 0
    var size : Int = 50
    var refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //viewCount를 초기화해서 체크인 되어있는 레스토랑의 카테고리로 보내야한다.
        viewCount = 0

        dispatch_async(dispatch_get_main_queue(), {
            showActivityIndicator(windowView)
        })
        
        //create a new button
        let leftButton: UIButton = UIButton()
        if(checkinChk == true) {
            leftButton.setImage(UIImage(named: "icon_blank"), forState: UIControlState.Normal)
            leftButton.frame = CGRectMake(0, 0, screen.size.width * 29 / 414, screen.size.height * 29 / 736)
            barButton = UIBarButtonItem(customView: leftButton)
            self.navigationItem.leftBarButtonItem = barButton
        } else {
            leftButton.setImage(UIImage(named: "icon_back"), forState: UIControlState.Normal)
            leftButton.addTarget(self, action: "backPressed:", forControlEvents: UIControlEvents.TouchUpInside)
            leftButton.frame = CGRectMake(0, 0, screen.size.width * 29 / 414, screen.size.height * 29 / 736)
            barButton = UIBarButtonItem(customView: leftButton)
            self.navigationItem.leftBarButtonItem = barButton
        }
        
        self.browseMenuTable.showsVerticalScrollIndicator = false
        
        let callView = UIView()
        //callView.frame = CGRect(x: (screen.size.width * 321 / 414), y: (screen.size.height * 643 / 736) - 113, width: (screen.size.width * 74 / 414), height: (screen.size.height * 74 / 736))
        callView.frame = CGRect(x: (screen.size.width * 321 / 414), y: (screen.size.height * 530 / 736), width: (screen.size.width * 74 / 414), height: (screen.size.height * 74 / 736))
        callView.backgroundColor = UIColorFromHex(0xc13939, alpha: 1.0)
        callView.layer.cornerRadius = callView.frame.size.width / 2
        browseMenuBack.addSubview(callView)
        
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
        
        //카테고리 리스트 가져오기.
        self.getBrowseMenuList()
        
        // set up the refresh control
        let attributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        let attributedTitle = NSAttributedString(string: "Pull to refresh", attributes: attributes)
        
        refreshControl.attributedTitle = attributedTitle
        self.refreshControl.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
        self.browseMenuTable.addSubview(refreshControl)
    }
    
    func refresh(sender:AnyObject) {
        print("Browse Table View Refresh")
        categories = NSArray()
        lastId = 0
        size = 50
        self.getBrowseMenuList()
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
        return categories.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("BrowseMenuCell", forIndexPath: indexPath) as! BrowseMenuTableCell
        let activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
        dispatch_async(dispatch_get_main_queue(), {
            activityIndicator.frame = CGRectMake(0.0, 0.0, 40.0, 40.0);
            activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.WhiteLarge
            activityIndicator.center = CGPointMake(cell.loadingView.frame.size.width / 2, cell.loadingView.frame.size.height / 2);
            cell.loadingView.addSubview(activityIndicator)
            activityIndicator.startAnimating()
            
        })
        
        if let url = NSURL(string: (categories[indexPath.row].valueForKey("picture") as? String)!) {
            let request = NSURLRequest(URL: url)
            NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) {
                (response: NSURLResponse?, data: NSData?, error: NSError?) -> Void in
                if let imageData = data as NSData? {
                    cell.browseMenuImg.image = UIImage(data: imageData)
                    
                    dispatch_async(dispatch_get_main_queue(), {
                        activityIndicator.stopAnimating()
                        activityIndicator.removeFromSuperview()
                    })
                }
            }
        }
        
        if((categories[indexPath.row].valueForKey("picture") as? String)! == "") {
            dispatch_async(dispatch_get_main_queue(), {
                activityIndicator.stopAnimating()
                activityIndicator.removeFromSuperview()
            })
        }
        
        //cell.browseMenuImg.imageFromUrl((categories[indexPath.row].valueForKey("picture") as? String)!)
        cell.browseMenuImg.clipsToBounds = true
        cell.browseMenuImg.contentMode = UIViewContentMode.ScaleAspectFill
        cell.browseMenuTitle.text = categories[indexPath.row].valueForKey("name") as? String
        
        let border = CALayer()
        border.backgroundColor = UIColorFromHex(0x222222, alpha: 1.0).CGColor
        border.frame = CGRect(x: 0, y: 0, width: cell.frame.width, height: 12)
        
        cell.layer.addSublayer(border)
        
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print(indexPath.row)
        categoryId = categories[indexPath.row].valueForKey("categoryId") as? Double
        
        dispatch_async(dispatch_get_main_queue(), {
            // code here
            self.performSegueWithIdentifier("resMenuList", sender: nil)
        })
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if !(indexPath.row + 1 < size) {
            
            lastId = restaurantList[indexPath.row].objectForKey("restaurantId") as! Double
            size = size + 50
            
            self.getBrowseMenuList()
        }
    }
    
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        //Bottom Refresh
        if scrollView == self.browseMenuTable{
            
            if ((scrollView.contentOffset.y + scrollView.frame.size.height) >= scrollView.contentSize.height) {
                
                print("scrollViewDidEndDragging")
                
            }
        }
    }

    func getBrowseMenuList() {
        let url: String = serverURL + "user/category/list"
        let request = NSMutableURLRequest(URL: NSURL(string: url)!)
        
        let authId: Double! = pref.objectForKey("authId") as! Double
        let authKey: String! = pref.objectForKey("authKey") as! String
        
        let newPost: NSDictionary = ["authId": authId, "authKey": authKey, "restaurantId": restaurantId, "lastId" : lastId, "size" : size]
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
                            
                            let chk: AnyObject? = data.valueForKey("categories")
                            
                            if(chk?.count == 0) {

                            } else {
                                
                                //print(data.valueForKey("categories"))
                                categories = data.valueForKey("categories") as! NSArray
                                
                                dispatch_async(dispatch_get_main_queue(), {
                                    hideActivityIndicator(self.view)
                                    self.browseMenuTable.reloadData()
                                    
                                })

                            }
                        } else {
                            let errorMsg: String! = post["error"] as! String
                            print(errorMsg)
                            dispatch_async(dispatch_get_main_queue(), {
                                hideActivityIndicator(self.view)
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
                            hideActivityIndicator(self.view)
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
                        hideActivityIndicator(self.view)
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
                    hideActivityIndicator(self.view)
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
