//
//  TutoItemController.swift
//  tabb
//
//  Created by LeeDongMin on 1/11/16.
//  Copyright © 2016 LeeDongMin. All rights reserved.
//

import UIKit

class TutoItemController: UIViewController {

    // MARK: - Variables
    var prev : UIImageView!
    var next : UIImageView!
    
    var itemIndex: Int = 0
    var imageName: String = "" {
        
        didSet {
            
            if let imageView = contentImageView {
                imageView.image = UIImage(named: imageName)
            }
            
        }
    }
    
    var tempTitle: String = "" {
        
        didSet {
            
            if let label = tutoTitle {
                label.text = tempTitle
            }
            
        }
    }
    
    var tempSub: String = "" {
        
        didSet {
            
            if let label = tutoSub {
                label.text = tempSub
            }
            
        }
    }
    
    @IBOutlet var contentImageView: UIImageView?
    
    @IBOutlet weak var nextPage: UIButton!
    @IBOutlet weak var tutoTitle: UILabel!
    @IBOutlet weak var tutoSub: UILabel!
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        contentImageView!.image = UIImage(named: imageName)
        
        tutoTitle.text = tempTitle
        tutoTitle.textColor = UIColor.whiteColor()
        
        tutoSub.text = tempSub
        tutoSub.textColor = UIColor.whiteColor()
        
        nextPage.addTarget(self, action: "nextLoginPage:", forControlEvents: UIControlEvents.TouchUpInside)
        nextPage.hidden = true
        
        prev = UIImageView(image: UIImage(named: "btn_tuto_prev"))
        prev.frame = CGRectMake(0, (screen.size.height * 448) / 736, (screen.size.width * 20) / 414, (screen.size.height * 40) / 736)
        self.view.addSubview(prev)
        
        next = UIImageView(image: UIImage(named: "btn_tuto_next"))
        next.frame = CGRectMake((screen.size.width * 394) / 414, (screen.size.height * 448) / 736, (screen.size.width * 20) / 414, (screen.size.height * 40) / 736)
        self.view.addSubview(next)
        
        print("test view??????")
        
        if(itemIndex == 0) {
            prev.alpha = 0.25
            next.alpha = 1.0
        } else if(itemIndex == 3) {
            prev.alpha = 1.0
            next.alpha = 0.25
        } else {
            prev.alpha = 1.0
            next.alpha = 1.0
        }

    }
    
    func nextLoginPage(sender : AnyObject?) {
        print("nextLogin")
        self.performSegueWithIdentifier("tutoLogin", sender: nil)
        
        pref.setBool(true, forKey: "tutoCheck")
    }

}
