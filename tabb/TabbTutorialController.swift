//
//  TabbTutorialController.swift
//  tabb
//
//  Created by LeeDongMin on 1/11/16.
//  Copyright © 2016 LeeDongMin. All rights reserved.
//

import UIKit

class TabbTutorialController: UIViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    // MARK: - Variables
    private var pageViewController: UIPageViewController?
    
    var prev : UIImageView!
    var next : UIImageView!
    
    // Initialize it right away here
    private let contentImages = ["tuto1_1.png",
        "tuto1_2.png",
        "tuto1_3.png",
        "tuto1_4.png"];
    
    private let titles = ["Browse Menu",
        "Customize & Order",
        "Bill Split & Transfer",
        "Service Call"];
    
    private let subs = ["No more need to wait for menu.\nStart browsing menu at your\nown pace.",
        "Check what are in your food and\nwhat options you have to make\nyour food more delightful.",
        "Having difficulty figuring out how much\nyou have to pay? Just a few clicks\nwill get you the result. No math!",
        "No matter what you need, no need to look\naround a server. Just click from your\nmobile and get served instantly."];
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        


        createPageViewController()
        setupPageControl()
    }
    
    private func createPageViewController() {
        
        let pageController = self.storyboard!.instantiateViewControllerWithIdentifier("PageController") as! UIPageViewController
        pageController.dataSource = self
        pageController.delegate = self
        
        if contentImages.count > 0 {
            let firstController = getItemController(0)!
            let startingViewControllers: NSArray = [firstController]
            pageController.setViewControllers(startingViewControllers as? [UIViewController], direction: UIPageViewControllerNavigationDirection.Forward, animated: false, completion: nil)
        }
        
        pageViewController = pageController
        addChildViewController(pageViewController!)
        self.view.addSubview(pageViewController!.view)
        pageViewController!.didMoveToParentViewController(self)
    }
    
    private func setupPageControl() {
        UIPageControl().frame = CGRectMake(100, 30, 214, 80)
        let appearance = UIPageControl.appearance()
        appearance.pageIndicatorTintColor = UIColor.grayColor()
        appearance.currentPageIndicatorTintColor = UIColor.whiteColor()
        appearance.backgroundColor = UIColor.darkGrayColor()
    }
    
    // MARK: - UIPageViewControllerDataSource
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        
        let itemController = viewController as! TutoItemController
        
        print("Before itemController.itemIndex : \(itemController.itemIndex)")

        if(itemController.itemIndex < 3) {
            itemController.nextPage.hidden = true
        }
        
        if itemController.itemIndex > 0 {
            return getItemController(itemController.itemIndex-1)
        }
        
        return nil
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        
        let itemController = viewController as! TutoItemController
        
        print("After itemController.itemIndex : \(itemController.itemIndex)")

        if(itemController.itemIndex == 3) {
            itemController.nextPage.hidden = false
        }

        
        if itemController.itemIndex+1 < contentImages.count {
            return getItemController(itemController.itemIndex+1)
        }
        
        return nil
    }
    
    private func getItemController(itemIndex: Int) -> TutoItemController? {
        
        if itemIndex < contentImages.count {
            let pageItemController = self.storyboard!.instantiateViewControllerWithIdentifier("ItemController") as! TutoItemController
            pageItemController.itemIndex = itemIndex
            pageItemController.imageName = contentImages[itemIndex]
            pageItemController.tempTitle = titles[itemIndex]
            pageItemController.tempSub = subs[itemIndex]
            

            
            return pageItemController
        }
        
        return nil
    }

   
    
    // MARK: - Page Indicator
    
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        return contentImages.count
    }
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        return 0
    }
    
    func nextLoginPage(sender : AnyObject?) {
        self.performSegueWithIdentifier("goLogin", sender: nil)
    }

}
