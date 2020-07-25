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
   
    @IBOutlet weak var trailing: NSLayoutConstraint!
    @IBOutlet weak var leading: NSLayoutConstraint!
    @IBOutlet weak var bigPP: UIImageView!
    @IBOutlet weak var menuPress: UIBarButtonItem!
    
    var menuOut = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    @IBAction func menuPress(_ sender: Any) {
        
    //      if menuOut == false (
    //         leading.Constraint = 250
    //        trailing.Constraint = -250
    //  )
    
    // TODO: Find out why this is being a pain in the ass and not working properly when its not 2am.
    // Why does this open as a seperate tab rather than side / overlay? Fix and test contraints and see if this resolves this issue.
    // gather profile picture display using Alamofire.
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */


    
}
