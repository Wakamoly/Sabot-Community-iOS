//
//  SideMenuController.swift
//  Sabot Community
//
//  Created by Will Murphy on 7/24/20.
//  Copyright © 2020 LucidSoftworksLLC. All rights reserved.
//

// NOTES: We need to add gesture taps for navigation to the various views. Attempted to do this and for some reason it kept crashing giving me "constraint" issues. We can add these once all the appropriate pages are built. I'll need to open a seperate project and play around with the pages opening up the right way and not in the same way this menu does. When i tried it in here it caused the entire app to crash.
//      oof - B


import UIKit
import EnhancedCircleImageView
import Alamofire
import AlamofireImage
import SwiftyJSON

class SideMenuController: UIViewController {
    
    let defaultValues = UserDefaults.standard
    let deviceprofilepicture = UserDefaults.standard.string(forKey: "device_profilepic")!
    let device_username = UserDefaults.standard.string(forKey: "device_username")!
    
    @IBOutlet weak var profileCover: UIImageView!
    @IBOutlet weak var bigPP: EnhancedCircleImageView!
//    @IBAction func profileTap(_ sender: Any) {
//        performSegue(withIdentifier: "toProfile", sender: nil)
//    }
    
    func getCoverPhoto(){
        AF.request(URLConstants.ROOT_URL+"get_coverphoto.php?username="+device_username, method: .get).responseJSON{
            response in
            //printing response
            print(response)
            
            switch response.result {
            case .success(let value):
                let jsonData = JSON(value)
                ///self.labelMessage.text = jsonData["message"].string
                if (jsonData["error"]==false){
                    self.profileCover.af.setImage(
                        withURL: URL(string:URLConstants.BASE_URL+jsonData["url"].string!)!,
                        imageTransition: .crossDissolve(1.25)
                    )
                }else{
                    let message = jsonData["message"].string
                    self.view.showToast(toastMessage: message!, duration:2)
                }
            case let .failure(error):
                print(error)
                self.view.showToast(toastMessage: "Network error!", duration:2)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bigPP.layer.borderColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1.0).cgColor
        bigPP.layer.masksToBounds = true
        bigPP.contentMode = .scaleToFill
        bigPP.layer.borderWidth = 5
        bigPP.af.setImage(
            withURL: URL(string:URLConstants.BASE_URL+deviceprofilepicture)!,
            imageTransition: .crossDissolve(1)
        )
        getCoverPhoto()
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "toProfile" {
//            _ = segue.destination as? ProfileViewController
//        }
//    }
    
}
