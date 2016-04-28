//
//  CustomInfoWindow.swift
//  TestGoogleMapAPI
//
//  Created by appsynth on 12/4/15.
//  Copyright © 2015 appsynth. All rights reserved.
//

import UIKit



class CustomInfoWindow: UIImageView {

    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var distanceWithUnit: UILabel!
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
  
    override func didMoveToSuperview() {
        superview?.autoresizesSubviews = false;
    }
}
