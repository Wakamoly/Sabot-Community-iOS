//
//  SideMenuController.swift
//  Sabot Community
//
//  Created by Will Murphy on 7/24/20.
//  Copyright © 2020 LucidSoftworksLLC. All rights reserved.
//

import UIKit
import Alamofire

class SideMenuController: UIViewController {
    
    @IBOutlet weak var trailCon: NSLayoutConstraint!
    @IBOutlet weak var leadCon: NSLayoutConstraint!
    
    var menuOut = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func menuPress(_ sender: Any) {
        
        if menuOut == false {
            leadCon.constant = 300
            trailCon.constant = -300
            menuOut = true
        } else {
            leadCon.constant = 0
            trailCon.constant = 0
            menuOut = false
        }
        
    }
    
}
