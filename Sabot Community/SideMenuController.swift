//
//  SideMenuController.swift
//  Sabot Community
//
//  Created by Will Murphy on 7/24/20.
//  Copyright © 2020 LucidSoftworksLLC. All rights reserved.
//

import UIKit
import EnhancedCircleImageView
import Alamofire
import AlamofireImage

class SideMenuController: UIViewController {
    
    let defaultValues = UserDefaults.standard
    let deviceprofilepicture = UserDefaults.standard.string(forKey: "device_profilepic")!
    
    @IBOutlet weak var profileCover: UIImageView!
    @IBOutlet weak var bigPP: EnhancedCircleImageView!
//    @IBAction func profileTap(_ sender: Any) {
//        performSegue(withIdentifier: "toProfile", sender: nil)
//    }
    @IBAction func messagesTap(_ sender: Any) {
        print("Some bullshit")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bigPP.layer.borderColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1.0).cgColor
        bigPP.layer.masksToBounds = true
        bigPP.contentMode = .scaleToFill
        bigPP.layer.borderWidth = 5
        bigPP.af.setImage(
            withURL: URL(string:URLConstants.BASE_URL+deviceprofilepicture)!,
            imageTransition: .crossDissolve(0.2)
        )
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "toProfile" {
//            _ = segue.destination as? ProfileViewController
//        }
//    }
    
}
