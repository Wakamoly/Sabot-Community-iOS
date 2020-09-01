//
//  EditProfilePostVC.swift
//  Sabot Community
//
//  Created by Wakamoly on 8/31/20.
//  Copyright © 2020 LucidSoftworksLLC. All rights reserved.
//

import UIKit
import EnhancedCircleImageView
import Alamofire
import SwiftyJSON

class EditProfilePostVC: UIViewController {
    
    let defaultValues = UserDefaults.standard
    let deviceusername = UserDefaults.standard.string(forKey: "device_username")!
    let deviceuserid = UserDefaults.standard.string(forKey: "device_userid")!
    let indicator: UIActivityIndicatorView = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.large)
    
    var postID:String = ""
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var online: EnhancedCircleImageView!
    @IBOutlet weak var numLikes: UILabel!
    @IBOutlet weak var numComments: UILabel!
    @IBOutlet weak var editedView: UILabel!
    @IBOutlet weak var verified: UIImageView!
    @IBOutlet weak var profilePhoto: EnhancedCircleImageView!
    @IBOutlet weak var likeView: UIImageView!
    @IBOutlet weak var likedView: UIImageView!
    @IBOutlet weak var dateView: UILabel!
    @IBOutlet weak var profileName: UILabel!
    @IBOutlet weak var platformType: UIImageView!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var toUsername: UILabel!
    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var postBodyTV: UITextView!
    @IBOutlet weak var saveButtonOutlet: UIButton!
    @IBAction func saveButton(_ sender: Any) {
        savePost()
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "Edit Post"
        contentView.isHidden = true
        
        //start loading indicator
        indicator.frame = CGRect(x: 0, y: 0, width: 60, height: 60)
        indicator.center = view.center
        self.view.addSubview(indicator)
        self.view.bringSubviewToFront(indicator)
        self.indicator.isOpaque = false
        self.indicator.layer.cornerRadius = 05
        self.indicator.backgroundColor = (UIColor .black .withAlphaComponent(0.6))
        
        loadPost()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }

    func loadPost(){
        self.indicator.startAnimating()
        AF.request(URLConstants.ROOT_URL+"profilePostEdit.php?postID="+postID+"&username="+deviceusername+"&userid="+deviceuserid, method: .get).responseJSON{
            response in
            //printing response
            print(response)
            
            switch response.result {
            case .success(let value):
                let jsonObject = JSON(value)
                let jsonData = jsonObject[0]
                if (jsonData["username"].rawString() == self.deviceusername) {
                    
                    //let id = jsonData["id"].int
                    let type = jsonData["type"].string
                    let likes = jsonData["likes"].rawString()
                    let body = jsonData["body"].rawString()
                    //let added_by = jsonData["added_by"].rawString()
                    let user_to = jsonData["user_to"].rawString()
                    let date_added = jsonData["date_added"].rawString()
                    let image = jsonData["image"].rawString()
                    let profile_pic = jsonData["profile_pic"].rawString()
                    let verified = jsonData["verified"].rawString()
                    let online = jsonData["online"].rawString()
                    let nickname = jsonData["nickname"].rawString()
                    let username = jsonData["username"].rawString()
                    let commentcount = jsonData["commentcount"].rawString()
                    let likedbyuser = jsonData["likedbyuseryes"].rawString()
                    let form = jsonData["form"].rawString()
                    
                    if !(user_to == "none"){
                        self.toUsername.isHidden = false
                        switch form {
                        case "user":
                            self.toUsername.text = "to @"+user_to!
                            break
                        case "clan":
                            self.toUsername.text = "to ["+user_to!.capitalized+"]"
                            self.toUsername.textColor = UIColor(named: "pin")
                            break
                        case "event":
                            self.toUsername.text = "to @"+user_to!
                            break
                        default:
                            self.toUsername.isHidden = true
                        }
                    }else{
                        self.toUsername.isHidden = true
                    }
                    
                    switch type{
                    case "Xbox":
                        self.platformType.image = UIImage(named: "icons8_xbox_50")
                        break
                    case "PlayStation":
                        self.platformType.image = UIImage(named: "icons8_playstation_50")
                        break
                    case "Steam":
                        self.platformType.image = UIImage(named: "icons8_steam_48")
                        break
                    case "PC":
                        self.platformType.image = UIImage(named: "icons8_workstation_48")
                        break
                    case "Mobile":
                        self.platformType.image = UIImage(named: "icons8_mobile_48")
                        break
                    case "Switch":
                        self.platformType.image = UIImage(named: "icons8_nintendo_switch_48")
                        break
                    case "Cross-Platform":
                        self.platformType.image = UIImage(named: "icons8_collect_40")
                        break
                    case "General":
                        self.platformType.isHidden = true
                        break
                    default:
                        self.platformType.image = UIImage(named: "icons8_question_mark_64")
                    }
                    
                    self.profileName.text = nickname
                    self.username.text = "@"+username!
                    self.postBodyTV.text = body
                    self.dateView.text = date_added
                    self.numLikes.text = likes
                    self.numComments.text = commentcount
                    
                    if online == "yes" {
                        self.online.isHidden = false
                    }else{
                        self.online.isHidden = true
                    }
                    
                    if verified == "yes"{
                        self.verified.isHidden = false
                    }else{
                        self.verified.isHidden = true
                    }
                    
                    if(likedbyuser == "yes"){
                        self.likeView.isHidden = true
                        self.likedView.isHidden = false
                    }else{
                        self.likeView.isHidden = false
                        self.likedView.isHidden = true
                    }
                    
                    let profilePicIndex = profile_pic?.firstIndex(of: ".")!
                    let profile_pic2 = (profile_pic?.prefix(upTo: profilePicIndex!))!+"_r.JPG"
                    self.profilePhoto.af.setImage(
                        withURL: URL(string:URLConstants.BASE_URL+profile_pic2)!,
                        imageTransition: .crossDissolve(0.2)
                    )
                    
                    if image != "" {
                        self.postImage.isHidden = false
                        self.postImage!.af.setImage(
                            withURL: URL(string:URLConstants.BASE_URL+image!)!,
                            imageTransition: .crossDissolve(0.2)
                        )
                    }else{
                        self.postImage.isHidden = true
                    }

                    self.contentView.isHidden = false
                }else{
                    self.view.showToast(toastMessage: "Network Error!", duration:2)
                }
                self.indicator.stopAnimating()
            case let .failure(error):
                print(error)
                self.indicator.stopAnimating()
                self.view.showToast(toastMessage: "Network Error!", duration:2)
            }
        }
    }
    
    func savePost(){
        self.saveButtonOutlet.isHidden = true
        self.indicator.startAnimating()
        self.view.endEditing(true)
        
        //TODO Add delegate from ProfileVC to unwind and reset Profile after finishing
    }

}
