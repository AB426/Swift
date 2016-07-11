//
//  MenuListTableCell.swift
//  tabb
//
//  Created by LeeDongMin on 2015. 11. 11..
//  Copyright © 2015년 LeeDongMin. All rights reserved.
//

import UIKit

class MenuListTableCell: UITableViewCell {
    
    @IBOutlet weak var menuListImg: UIImageView!
    @IBOutlet weak var menuListTitle: UILabel!
    @IBOutlet weak var menuListPrice: UILabel!
    @IBOutlet weak var menuListAdd: UIButton!
    
    @IBOutlet weak var menuListShadow: UIImageView!

    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var menuListStar1: UIImageView!
    @IBOutlet weak var menuListStar2: UIImageView!
    @IBOutlet weak var menuListStar3: UIImageView!
    @IBOutlet weak var menuListStar4: UIImageView!
    @IBOutlet weak var menuListStar5: UIImageView!
    
    @IBOutlet weak var menuListHeart: UIImageView!
    var badge: UILabel!
    
    var starList = Array<UIImageView>()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        starList.append(menuListStar1)
        starList.append(menuListStar2)
        starList.append(menuListStar3)
        starList.append(menuListStar4)
        starList.append(menuListStar5)
        
        badge = UILabel(frame: CGRect(x: 35, y: 20, width: 24, height: 24))
        badge.textColor = UIColor.whiteColor()
        badge.font = UIFont(name: roboto, size: 12)
        badge.layer.cornerRadius = badge.frame.size.height/2
        badge.backgroundColor = UIColor.redColor()
        badge.clipsToBounds = true
        badge.textAlignment = .Center
        self.addSubview(badge)
        
        menuListImg.layer.cornerRadius = (screen.size.height * 3.5) / 414
        menuListShadow.layer.cornerRadius = (screen.size.height * 3.5) / 414
        menuListShadow.clipsToBounds = true
        
        loadingView.layer.cornerRadius = (screen.size.height * 3.5) / 414
        loadingView.clipsToBounds = true
        
        menuListAdd.setBackgroundImage(UIImage(named: "icon_add"), forState: .Normal)
        
        self.backgroundColor = UIColorFromHex(0x222222, alpha: 1.0)
    }
    
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
