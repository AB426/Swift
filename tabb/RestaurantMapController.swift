//
//  RestaurantMapController.swift
//  tabb
//
//  Created by LeeDongMin on 12/16/15.
//  Copyright © 2015 LeeDongMin. All rights reserved.
//

import UIKit
import MapKit

class RestaurantMapController: UIViewController {

    @IBOutlet weak var mapKit: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let statusBarView = UIView(frame: CGRectMake(0, 0,
            UIApplication.sharedApplication().statusBarFrame.size.width,
            UIApplication.sharedApplication().statusBarFrame.size.height))
        statusBarView.backgroundColor = UIColorFromHex(0xc13939, alpha: 1.0)
        self.view.addSubview(statusBarView)
        
        let longitude = restaurantView.objectForKey("longitude") as? Double
        let latitude = restaurantView.objectForKey("latitude") as? Double
        
        let location = CLLocationCoordinate2D(latitude: latitude!, longitude: longitude!)
        
        // 2
        let span = MKCoordinateSpanMake(0.05, 0.05)
        let region = MKCoordinateRegion(center: location, span: span)
        mapKit.setRegion(region, animated: true)
        
        //3
        let annotation = MKPointAnnotation()
        annotation.coordinate = location
        annotation.title = restaurantView.objectForKey("name") as? String
        annotation.subtitle = "Kuwait"
        mapKit.addAnnotation(annotation)
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
