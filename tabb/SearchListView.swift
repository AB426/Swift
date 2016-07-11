//
//  SearchListView.swift
//  tabb
//
//  Created by LeeDongMin on 2015. 11. 20..
//  Copyright © 2015년 LeeDongMin. All rights reserved.
//

import UIKit

public class SearchListView: UIView {
    
    private var menuTable: BTTableView!
    private var topSeparator: UIView!
    private var menuButton: UIButton!
    private var menuTitle: UILabel!
    private var menuArrow: UIImageView!
    private var backgroundView: UIView!
    private var isShown: Bool!
    private var menuWrapper: UIView!

    private var titleItems : NSMutableArray = NSMutableArray()
    private var subTitles : NSMutableDictionary = NSMutableDictionary()
    private var arrayForBool : NSMutableArray = NSMutableArray()
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public init(aView: UIView!, title: String) {
        // Set frame
        let frame = CGRectMake(0, 0, screen.size.width, (screen.size.height * 352) / 736)
        
        super.init(frame:frame)
        
        let window = UIApplication.sharedApplication().windows[0]
        let menuWrapperBounds = window.bounds

        print(menuWrapperBounds.origin.y)
        
        // Set up DropdownMenu
        self.menuWrapper = UIView(frame: CGRectMake(menuWrapperBounds.origin.x, 0, menuWrapperBounds.width, menuWrapperBounds.height))
        self.menuWrapper.clipsToBounds = true
        self.menuWrapper.autoresizingMask = UIViewAutoresizing.FlexibleWidth.union(UIViewAutoresizing.FlexibleHeight)
        
        // Init background view (under table view)
        self.backgroundView = UIView(frame: menuWrapperBounds)
        self.backgroundView.backgroundColor = UIColor.blackColor()
        self.backgroundView.autoresizingMask = UIViewAutoresizing.FlexibleWidth.union(UIViewAutoresizing.FlexibleHeight)
        
        titleItems = ["Show my Favorites", "Search by Food Type", "Search by Location", "Search by Popularity"]
        arrayForBool = ["0", "0", "0", "0"]
        
        let tmp1 : NSArray = [""]
        var string1 = self.titleItems .objectAtIndex(0) as? String
        [subTitles.setValue(tmp1, forKey:string1! )]
        
        let tmp2 : NSArray = ["African", "American", "Argentinian","Australian","Bakery","Brazilian","Breakfast & Brunch","Burgers","Cafe","Chinese","Continental","Crepes","Dairy","Dates","Desserts","Doner","Drinks","Egyptian","French","German","Gourmet","Greek","Grills","Healthy Food","Hot Dogs","Ice Cream & Frozen Yogurt","Indian","International","Iranian","Iraqi","Italian","Japanese","Jordanian","Korean","Kunafa","Kuwaiti","Lebanese","Mexican","Moroccan","Pies","Pizza","Roastery","Saj","Salads","Sandwiches","Sauces","Seafood","Shawarma","Snacks","South American","South Asian","Spanish & Portugese","Syrian","Thai","Turkish","Vegetarian"]
        string1 = self.titleItems .objectAtIndex(1) as? String
        [subTitles.setValue(tmp2, forKey:string1! )]
        
        let tmp3 : NSArray = ["Kuwait City", "Hawally", "Farwaniya", "Ahmadi", "Jahra", "Mubarak Al Khabeer"]
        string1 = self.titleItems .objectAtIndex(2) as? String
        [subTitles.setValue(tmp3, forKey:string1! )]
        
        let tmp4 : NSArray = [""]
        string1 = self.titleItems .objectAtIndex(3) as? String
        [subTitles.setValue(tmp4, forKey:string1! )]
        
        // Init table view
        self.menuTable = BTTableView(frame: CGRectMake((screen.size.width * 11) / 414, menuWrapperBounds.origin.y, (menuWrapperBounds.width * 392) / 414, menuWrapperBounds.height), titleItems: titleItems, arrayForBool: arrayForBool, subTitles: subTitles)
        
        // Add background view & table view to container view
        self.menuWrapper.addSubview(self.backgroundView)
        self.menuWrapper.addSubview(self.menuTable)
        
        // Add Menu View to container view
        aView.addSubview(self.menuWrapper)
        
        self.menuWrapper.hidden = true
    }
    
    public func showMenu() {
        self.menuWrapper.frame.origin.y = ((screen.size.height * 71) / 736)
        
        // Table view header
        let headerView = UIView(frame: CGRectMake(0, 0, self.frame.width, 300))
        headerView.backgroundColor = UIColorFromHex(0x3a3a3a, alpha: 1.0)
        self.menuTable.tableHeaderView = headerView
        
        // Visible menu view
        self.menuWrapper.hidden = false
        
        // Change background alpha
        self.backgroundView.alpha = 0
        
        // Animation
        self.menuTable.frame.origin.y = -CGFloat(self.titleItems.count) * ((screen.size.height * 46) / 736) - 300
        
        self.arrayForBool = NSMutableArray()
        self.arrayForBool = ["0", "0", "0", "0"]
        
        // Reload data to dismiss highlight color of selected cell
        self.menuTable.arrayForBool = self.arrayForBool
        self.menuTable.reloadData()
        
        UIView.animateWithDuration(
            0.5 * 1.5,
            delay: 0,
            usingSpringWithDamping: 0.7,
            initialSpringVelocity: 0.5,
            options: [],
            animations: {
                self.menuTable.frame.origin.y = CGFloat(-300)
                self.backgroundView.alpha = 0.3
            }, completion: nil
        )
    }
    
    public func hideMenu() {
        // Change background alpha
        self.backgroundView.alpha = 0.3
        
        self.arrayForBool = NSMutableArray()
        self.arrayForBool = ["0", "0", "0", "0"]
        
        // Reload data to dismiss highlight color of selected cell
        self.menuTable.arrayForBool = self.arrayForBool
        self.menuTable.reloadData()
        
        UIView.animateWithDuration(
            0.5 * 1.5,
            delay: 0,
            usingSpringWithDamping: 0.7,
            initialSpringVelocity: 0.5,
            options: [],
            animations: {
                self.menuTable.frame.origin.y = CGFloat(-200)
            }, completion: nil
        )
        
        // Animation
        UIView.animateWithDuration(0.5, delay: 0, options: UIViewAnimationOptions.TransitionNone, animations: {
            self.menuTable.frame.origin.y = -CGFloat(self.titleItems.count) * ((screen.size.height * 46) / 736) - 300
            self.backgroundView.alpha = 0
            }, completion: { _ in
                self.menuWrapper.hidden = true
        })
    }
    
}


// MARK: Table View
class BTTableView: UITableView, UITableViewDelegate, UITableViewDataSource {
    
    // Public properties
    var selectRowAtIndexPathHandler: ((indexPath: Int) -> ())?
    
    // Private properties
    //private var titleItems: [AnyObject]!
    private var selectedIndexPath: Int!
    
    var titleItems : NSMutableArray = NSMutableArray()
    var subTitlts : NSMutableDictionary = NSMutableDictionary()
    internal var arrayForBool : NSMutableArray = NSMutableArray()
    var headerColor : Bool = false
    var headerColors : NSMutableArray = NSMutableArray()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(frame: CGRect, titleItems: NSMutableArray, arrayForBool: NSMutableArray, subTitles: NSMutableDictionary) {
        super.init(frame: frame, style: UITableViewStyle.Plain)
        
        self.titleItems = titleItems
        self.selectedIndexPath = 0
        
        self.arrayForBool = arrayForBool
        self.subTitlts = subTitles
        
        // Setup table view
        self.delegate = self
        self.dataSource = self
        self.backgroundColor = UIColor.clearColor()
        self.separatorStyle = UITableViewCellSeparatorStyle.None
        self.autoresizingMask = UIViewAutoresizing.FlexibleWidth
        self.tableFooterView = UIView(frame: CGRectZero)
    }
    
    // Table view data source
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.titleItems.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(arrayForBool.objectAtIndex(section).boolValue == true) {
            if(section == 2 || section == 1) {
                let tps = self.titleItems.objectAtIndex(section) as! String
                let contents = (subTitlts.valueForKey(tps)) as! NSArray
                return contents.count
            } else {
                return 0;
            }
        }
        return 0;
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return (screen.size.height * 46) / 736
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return (screen.size.height * 46) / 736
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRectMake(0, 0, tableView.frame.size.width, (screen.size.height * 46) / 736))
        headerView.backgroundColor = UIColorFromHex(0xffffff, alpha: 1.0)
        headerView.tag = section
        
        
        let headerString = UILabel(frame: CGRect(x: (screen.size.width * 15) / 414, y: 0, width: (screen.size.width * 200) / 414, height: (screen.size.height * 46) / 736)) as UILabel
        headerString.text = self.titleItems.objectAtIndex(section) as? String
        headerString.lineBreakMode = NSLineBreakMode.ByWordWrapping
        headerString.numberOfLines = 0;
        headerString.textColor = UIColorFromHex(0x666666, alpha: 1.0)
        headerString.font = UIFont(name: lato, size: (screen.size.width * 17) / 414)
        headerView.addSubview(headerString)
        
        let border = UIView()
        border.backgroundColor = UIColorFromHex(0xcccccc, alpha: 1.0)
        border.frame = CGRect(x: 0, y: (screen.size.height * 45) / 736, width: screen.size.width, height: (screen.size.height * 1) / 736)
        
        headerView.addSubview(border)
        
        
        let headerTapped = UITapGestureRecognizer (target: self, action:"sectionHeaderTapped:")
        headerView.addGestureRecognizer(headerTapped)
        
        return headerView
    }
    
    func sectionHeaderTapped(recognizer: UITapGestureRecognizer) {
        let indexPath : NSIndexPath = NSIndexPath(forRow: 0, inSection:(recognizer.view?.tag as Int!)!)
        if (indexPath.row == 0) {
            headerColor = true
            headerColors.addObject(indexPath.section)
            recognizer.view?.backgroundColor = UIColorFromHex(0xeeeeee, alpha: 1.0)
            var collapsed = arrayForBool.objectAtIndex(indexPath.section).boolValue
            
            collapsed = !collapsed;
            
            arrayForBool.replaceObjectAtIndex(indexPath.section, withObject: collapsed)
            //reload specific section animated
            let range = NSMakeRange(indexPath.section, 1)
            let sectionToReload = NSIndexSet(indexesInRange: range)
            
            let content = subTitlts.valueForKey(self.titleItems.objectAtIndex(indexPath.section) as! String) as! NSArray
            let title = content.objectAtIndex(indexPath.row) as? String
            
            if(title == "") {
                isShowResMenu = false
                resView.hideMenu()
//                var browse: BrowseController!
//                let storyboard = UIStoryboard(name: "Main", bundle: nil)
//                browse = storyboard.instantiateViewControllerWithIdentifier("browse") as! BrowseController
//                
                if(indexPath.section == 0) {
                    searchType = "FAVORITES"
                } else {
                    searchType = "POPULARITY"
                }
                
                for(var index = 0; index < arrayForBool.count; ++index) {
                    arrayForBool.replaceObjectAtIndex(index, withObject: false)
                }
                
                
                
                browse.getRestaurantList()
                
            } else {
    
                self.reloadSections(sectionToReload, withRowAnimation:UITableViewRowAnimation.Fade)
            }
            
            for(var index = 0; index < arrayForBool.count; ++index) {
                if(index != indexPath.section) {
                    arrayForBool.replaceObjectAtIndex(index, withObject: false)
                }
            }
            
            self.reloadData()
        }
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = BTTableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "Cell")
        
        
        let manyCells : Bool = arrayForBool .objectAtIndex(indexPath.section).boolValue
        
        if (!manyCells) {
            //  cell.textLabel.text = @"click to enlarge";
        }
        else{
            let content = subTitlts.valueForKey(self.titleItems.objectAtIndex(indexPath.section) as! String) as! NSArray
            cell.textLabel?.text = content.objectAtIndex(indexPath.row) as? String
        }
        
        //cell.textLabel?.text = self.titleItems[indexPath.row] as? String
        
        let border = CALayer()
        border.backgroundColor = UIColorFromHex(0xcccccc, alpha: 1.0).CGColor
        border.frame = CGRect(x: 0, y: (screen.size.height * 45) / 736, width: screen.size.width, height: (screen.size.height * 1) / 736)
        
        cell.layer.addSublayer(border)
        
        return cell
    }
    
    // Table view delegate
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        isShowResMenu = false
        resView.hideMenu()
        let content = subTitlts.valueForKey(self.titleItems.objectAtIndex(indexPath.section) as! String) as! NSArray
        
        if(indexPath.section == 1) {
            searchType = "FOOD_TYPE"
            foodType = (content.objectAtIndex(indexPath.row) as? String)?.uppercaseString
            
        } else {
            searchType = "LOCATION"
            restaurantLocation = (content.objectAtIndex(indexPath.row) as? String)?.uppercaseString
            
            if(restaurantLocation == "KUWAIT CITY") {
                restaurantLocation = "KUWAIT_CITY"
            }
        }
        
        for(var index = 0; index < arrayForBool.count; ++index) {
            arrayForBool.replaceObjectAtIndex(index, withObject: false)
        }
        
        browse.getRestaurantList()
        
        tableView.reloadData()
    }
    
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        //let cell = tableView.cellForRowAtIndexPath(indexPath) as? BTTableViewCell
    }
}

// MARK: Table view cell
class BTTableViewCell: UITableViewCell {
    
    var checkmarkIcon: UIImageView!
    var cellContentFrame: CGRect!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        // Setup cell
        cellContentFrame = CGRectMake(0, 0, (screen.size.width * 392) / 414, (screen.size.height * 46) / 736)
        self.contentView.backgroundColor = UIColorFromHex(0xf2f2f2, alpha: 1.0)
        self.selectionStyle = UITableViewCellSelectionStyle.None
        self.textLabel!.textAlignment = NSTextAlignment.Left
        self.textLabel!.textColor = UIColorFromHex(0x666666, alpha: 1.0)
        self.textLabel!.font = UIFont(name: lato, size: (screen.size.width * 17) / 414)
        self.textLabel!.frame = CGRectMake((screen.size.width * 42) / 414, 0, cellContentFrame.width, cellContentFrame.height)

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        self.bounds = cellContentFrame
        self.contentView.frame = self.bounds
    }
}

// Content view of table view cell
class BTTableCellContentView: UIView {
    var separatorColor: UIColor = UIColor.blackColor()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.initialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.initialize()
    }
    
    func initialize() {
        self.backgroundColor = UIColor.clearColor()
    }
    
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        let context = UIGraphicsGetCurrentContext()
        
        // Set separator color of dropdown menu based on barStyle
        CGContextSetStrokeColorWithColor(context, self.separatorColor.CGColor)
        CGContextSetLineWidth(context, 1)
        CGContextMoveToPoint(context, 0, self.bounds.size.height)
        CGContextAddLineToPoint(context, self.bounds.size.width, self.bounds.size.height)
        CGContextStrokePath(context)
    }
}