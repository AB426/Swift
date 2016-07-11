//
//  SearchViewController.swift
//  tabb
//
//  Created by LeeDongMin on 2015. 11. 26..
//  Copyright © 2015년 LeeDongMin. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, UISearchBarDelegate {

    @IBOutlet weak var search: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        search.delegate = self
        
        search.placeholder = "Search by restaurant"
        
        let statusBarView = UIView(frame: CGRectMake(0, 0,
            UIApplication.sharedApplication().statusBarFrame.size.width,
            UIApplication.sharedApplication().statusBarFrame.size.height))
        statusBarView.backgroundColor = UIColorFromHex(0xc13939, alpha: 1.0)
        self.view.addSubview(statusBarView)
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        print("searchText \(searchText)")
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        print("searchText \(searchBar.text!)")
        
        self.dismissViewControllerAnimated(true, completion: nil)
        
        let window = UIApplication.sharedApplication().windows[0]
        let tab : UITabBarController = window.rootViewController as! UITabBarController
        tab.selectedIndex = 0
        
        searchCheck = true
        searchType = "NAME"
        searchName = (searchBar.text!)
        viewCount = 0
    }
    

    @IBAction func dismiss(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
        
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
