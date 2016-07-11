//
//  Checkbox.swift
//  PentaGoMobile
//
//  Created by Ștefan Godoroja on 8/9/14..
//  Copyright (c) 2014 Ștefan Godoroja. All rights reserved.
//

import UIKit

class Checkbox : UIButton {
    var mDelegate: CheckboxDelegate?;
    
    required init(coder: NSCoder) {
        super.init(coder: coder)!
    }
    
    init(frame: CGRect, selected: Bool, checkValue : Int) {
        super.init(frame: frame);
        
        self.adjustEdgeInsets();
        if(checkValue == 1) {
            self.applyStyle();
        } else {
            self.applyDishOptionStyle()
        }
        
        //self.setTitle(title, forState: UIControlState.Normal);
        self.addTarget(self, action: "onTouchUpInside:", forControlEvents: UIControlEvents.TouchUpInside);
    }

//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
    
    func adjustEdgeInsets() {
        let lLeftInset: CGFloat = 8.0;
        
        self.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Left;
        self.imageEdgeInsets = UIEdgeInsetsMake(0.0 as CGFloat, lLeftInset, 0.0 as CGFloat, 0.0 as CGFloat);
        //self.titleEdgeInsets = UIEdgeInsetsMake(0.0 as CGFloat, (lLeftInset * 2), 0.0 as CGFloat, 0.0 as CGFloat);
    }
    
    func applyStyle() {
        self.setImage(UIImage(named: "btn_check_on"), forState: UIControlState.Selected);
        self.setImage(UIImage(named: "btn_check_off"), forState: UIControlState.Normal);
        //self.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal);
    }
    
    func applyDishOptionStyle() {
        self.setImage(UIImage(named: "btn_check_on2"), forState: UIControlState.Selected);
        self.setImage(UIImage(named: "btn_check_off2"), forState: UIControlState.Normal);
        //self.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal);
    }
    
    func onTouchUpInside(sender: UIButton) {
        self.selected = !self.selected;
        mDelegate?.didSelectCheckbox(self.selected, identifier: self.tag);
    }
}