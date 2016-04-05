//
//  AboutViewController.swift
//  TestGoogleMapAPI
//
//  Created by appsynth on 12/7/15.
//  Copyright © 2015 appsynth. All rights reserved.
//

import UIKit
import GoogleMaps

class AboutViewController: UIViewController {
    
    @IBOutlet weak var aboutTextView: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "About"
        
        let license = GMSServices.openSourceLicenseInfo()
        self.aboutTextView.text = license
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
