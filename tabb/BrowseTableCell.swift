//
//  BrowseTableCell.swift
//  tabb
//
//  Created by LeeDongMin on 2015. 10. 26..
//  Copyright © 2015년 LeeDongMin. All rights reserved.
//

import UIKit

class BrowseTableCell: UITableViewCell {

    @IBOutlet weak var listImg: UIImageView!
    @IBOutlet weak var listShadow: UIImageView!
    @IBOutlet weak var listName: UILabel!
    @IBOutlet weak var listFoodType: UILabel!
    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var listLikeHeart: UIButton!
    @IBOutlet weak var listStar1: UIImageView!
    @IBOutlet weak var listStar2: UIImageView!
    @IBOutlet weak var listStar3: UIImageView!
    @IBOutlet weak var listStar4: UIImageView!
    @IBOutlet weak var listStar5: UIImageView!
    
    var badge: UILabel!
    
    var starList = Array<UIImageView>()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        starList.append(listStar1)
        starList.append(listStar2)
        starList.append(listStar3)
        starList.append(listStar4)
        starList.append(listStar5)

        badge = UILabel(frame: CGRect(x: 35, y: 20, width: 24, height: 24))
        badge.textColor = UIColor.whiteColor()
        badge.font = UIFont(name: roboto, size: 12)
        badge.layer.cornerRadius = badge.frame.size.height/2
        badge.backgroundColor = UIColor.redColor()
        badge.clipsToBounds = true
        badge.textAlignment = .Center
        self.addSubview(badge)
        
        listFoodType.adjustsFontSizeToFitWidth = true
        listName.adjustsFontSizeToFitWidth = true
        
        listImg.layer.cornerRadius = (screen.size.height * 3.5) / 414
        listImg.clipsToBounds = true
        listShadow.layer.cornerRadius = (screen.size.height * 3.5) / 414
        listShadow.clipsToBounds = true
        
        loadingView.layer.cornerRadius = (screen.size.height * 3.5) / 414
        loadingView.clipsToBounds = true
        
        self.backgroundColor = UIColorFromHex(0x222222, alpha: 1.0)
        
        self.layer.cornerRadius = (screen.size.height * 3.5) / 414
    }

    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }

}
