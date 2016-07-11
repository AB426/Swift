//
//  BrowseMenuTableCell.swift
//  tabb
//
//  Created by LeeDongMin on 2015. 11. 11..
//  Copyright © 2015년 LeeDongMin. All rights reserved.
//

import UIKit

class BrowseMenuTableCell: UITableViewCell {

    @IBOutlet weak var browseMenuImg: UIImageView!
    @IBOutlet weak var browseMenuTitle: UILabel!
    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var browseShadow: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

        browseShadow.clipsToBounds = true
        browseShadow.layer.cornerRadius = (screen.size.height * 3.5) / 414
        browseMenuImg.layer.cornerRadius = (screen.size.height * 3.5) / 414
        
        loadingView.layer.cornerRadius = (screen.size.height * 3.5) / 414
        loadingView.clipsToBounds = true
        
        self.backgroundColor = UIColorFromHex(0x222222, alpha: 1.0)
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
