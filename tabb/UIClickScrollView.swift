//
//  UIClickScrollView.swift
//  tabb
//
//  Created by LeeDongMin on 12/1/15.
//  Copyright © 2015 LeeDongMin. All rights reserved.
//

import UIKit

class UIClickScrollView: UIScrollView {
    override func touchesShouldCancelInContentView(view: UIView) -> Bool {
        if (view.isKindOfClass(UIButton)) {
            return true
        }
        
        return super.touchesShouldCancelInContentView(view)
        
    }
}
