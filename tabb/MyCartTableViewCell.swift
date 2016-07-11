//
//  MyCartTableViewCell.swift
//  tabb
//
//  Created by LeeDongMin on 2015. 11. 23..
//  Copyright © 2015년 LeeDongMin. All rights reserved.
//

import UIKit

class MyCartTableViewCell: UITableViewCell {

    @IBOutlet weak var cartImage: UIImageView!
    @IBOutlet weak var cartTitle: UILabel!
    @IBOutlet weak var cartOption: UILabel!
    @IBOutlet weak var cartPrice: UILabel!
    @IBOutlet weak var cartDel: UIButton!
    @IBOutlet weak var cartAdd: UIButton!
    @IBOutlet weak var cartAmount: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
