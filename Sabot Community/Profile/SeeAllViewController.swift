//
//  SeeAllViewController.swift
//  Sabot Community
//
//  Created by Wakamoly on 8/28/20.
//  Copyright © 2020 LucidSoftworksLLC. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class SeeAllViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //Profile posts table view
    
    
    ///the method returning size of the list
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return profilePosts.count
    }
    
    ///handling cell view for table
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProfilePostsTVC2") as? ProfilePostsTVC2
        
        //getting the hero for the specified position
        let profilesNewsI: ProfileNewsModel
        profilesNewsI = profilePosts[indexPath.row]
        
        //displaying values
        cell!.usernameLabel.text = "@"+profilesNewsI.username!
        cell!.nicknameLabel.text = profilesNewsI.nickname
        cell!.postBody.text = profilesNewsI.body
        cell!.postBody.handleURLTap { (URL) in
            UIApplication.shared.open(URL as URL, options: [:], completionHandler: nil)
        }
        
        if profilesNewsI.user_to != "none"{
            cell!.toUsernameLabel.text = "to @"+profilesNewsI.user_to!
        }else{
            cell!.toUsernameLabel.isHidden = true
        }
        
        if profilesNewsI.likedbyuser == "yes"{
            cell!.likeView.isHidden = true
            cell!.likedView.isHidden = false
        }else{
            cell!.likeView.isHidden = false
            cell!.likedView.isHidden = true
        }
        if profilesNewsI.edited == "yes"{
            cell!.editedLabel.isHidden = false
        }else{
            cell!.editedLabel.isHidden = true
        }
        
        cell!.numLikes.text = profilesNewsI.likes
        cell!.numComments.text = profilesNewsI.commentcount
        cell!.dateView.text = profilesNewsI.date_added
        
        if profilesNewsI.online == "yes"{
            cell!.onlineView.isHidden = false
            cell!.onlineView.layer.borderColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1.0).cgColor
            cell!.onlineView.layer.masksToBounds = true
            cell!.onlineView.contentMode = .scaleToFill
            cell!.onlineView.layer.borderWidth = 1
        }else{
            cell!.onlineView.isHidden = true
        }
        if profilesNewsI.verified == "yes"{
            cell!.verifiedView.isHidden = false
        }else{
            cell!.verifiedView.isHidden = true
        }
        
        switch profilesNewsI.type{
        case "Xbox":
            cell!.platformType.image = UIImage(named: "icons8_xbox_50")
            break
        case "PlayStation":
            cell!.platformType.image = UIImage(named: "icons8_playstation_50")
            break
        case "Steam":
            cell!.platformType.image = UIImage(named: "icons8_steam_48")
            break
        case "PC":
            cell!.platformType.image = UIImage(named: "icons8_workstation_48")
            break
        case "Mobile":
            cell!.platformType.image = UIImage(named: "icons8_mobile_48")
            break
        case "Switch":
            cell!.platformType.image = UIImage(named: "icons8_nintendo_switch_48")
            break
        case "General":
            cell!.platformType.isHidden = true
            break
        default:
            cell!.platformType.image = UIImage(named: "icons8_question_mark_64")
        }
        
        let profilePicIndex = profilesNewsI.profile_pic?.firstIndex(of: ".")!
        let profile_pic = (profilesNewsI.profile_pic?.prefix(upTo: profilePicIndex!))!+"_r.JPG"
        cell!.profilePhoto.af.setImage(
            withURL: URL(string:URLConstants.BASE_URL+profile_pic)!,
            imageTransition: .crossDissolve(0.2)
        )
        
        if profilesNewsI.image != "" {
            cell!.postImage.isHidden = false
            cell!.postImage!.af.setImage(
                withURL: URL(string:URLConstants.BASE_URL+profilesNewsI.image!)!,
                imageTransition: .crossDissolve(0.2)
            )
        }else{
            cell!.postImage.isHidden = true
        }
        
        return cell!
    }
    
    ///handling cell view taps
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let alertController = UIAlertController(title: "Hint", message: "You have selected row \(indexPath.row).", preferredStyle: .alert)
        
        let alertAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        
        alertController.addAction(alertAction)
        
        present(alertController, animated: true, completion: nil)
        
    }
    
    ///number of sections in table view
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    //segue to this VC variables
    var queryIDextra:String = ""
    var method:String = ""
    var queryID:String = ""
    
    //table view cell models
    private var profilePosts = [ProfileNewsModel]()
    //private var profileClans = [ClansModel]()
    //private var profilePublics = [PublicsTopicsModel]()
    
    let defaultValues = UserDefaults.standard
    let deviceusername = UserDefaults.standard.string(forKey: "device_username")!
    let deviceuserid = UserDefaults.standard.string(forKey: "device_userid")!
    let indicator: UIActivityIndicatorView = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.large)
    
    @IBOutlet weak var errorView: UIView!
    @IBOutlet weak var seeAllTableView: UITableView!
    @IBOutlet weak var nothingToShow: UILabel!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        let nib = UINib(nibName: "ProfilePostsTVC2", bundle: nil)
        self.seeAllTableView.register(nib, forCellReuseIdentifier: "ProfilePostsTVC2")
        
        //setting up post table view
        seeAllTableView.dataSource = self
        seeAllTableView.delegate = self
        
        //start loading indicator
        indicator.frame = CGRect(x: 0, y: 0, width: 60, height: 60)
        indicator.center = view.center
        self.view.addSubview(indicator)
        self.view.bringSubviewToFront(indicator)
        self.indicator.isOpaque = false
        self.indicator.layer.cornerRadius = 05
        self.indicator.backgroundColor = (UIColor .black .withAlphaComponent(0.6))
        self.indicator.startAnimating()
        
        switch method {
        case "publics":
            self.navigationItem.title = "Publics Posts"
            //loadPublics()
            break
        case "posts":
            self.navigationItem.title = "Profile Posts"
            loadPosts()
            break
        case "clan_posts":
            self.navigationItem.title = "Clans"
            //loadClans()
            break
        default:
            self.navigationItem.title = "See All"
            self.seeAllTableView.isHidden = true
            self.errorView.isHidden = false
            break
        }
        
    }
    
    func loadPosts(){
        self.profilePosts.removeAll()
        AF.request(URLConstants.ROOT_URL+"see_all.php?queryid="+queryID+"&queryidextra="+queryIDextra+"&method="+method+"&userid="+deviceuserid+"&deviceusername="+deviceusername, method: .get).responseJSON{
            response in
            //printing response
            //print(response)

            switch response.result {
            case .success(let value):
                let jsonObject = JSON(value)
                if jsonObject.count == 0 {
                    self.seeAllTableView.isHidden = true
                    self.nothingToShow.isHidden = false
                }else{
                    self.nothingToShow.isHidden = true
                    for i in 0..<jsonObject.count{
                        let jsonData = jsonObject[i]
                        self.profilePosts.append(ProfileNewsModel(
                            id: jsonData["id"].int,
                            type: jsonData["type"].string,
                            likes: jsonData["likes"].rawString(),
                            body: jsonData["body"].rawString(),
                            added_by: jsonData["added_by"].rawString(),
                            user_to: jsonData["user_to"].rawString(),
                            date_added: jsonData["date_added"].string,
                            user_closed: jsonData["user_closed"].rawString(),
                            deleted: jsonData["deleted"].rawString(),
                            image: jsonData["image"].rawString(),
                            user_id: jsonData["user_id"].rawString(),
                            profile_pic: jsonData["profile_pic"].rawString(),
                            verified: jsonData["verified"].rawString(),
                            online: jsonData["online"].rawString(),
                            nickname: jsonData["nickname"].rawString(),
                            username: jsonData["username"].rawString(),
                            commentcount: jsonData["commentcount"].rawString(),
                            likedbyuser: jsonData["likedbyuseryes"].rawString(),
                            form: jsonData["form"].rawString(),
                            edited: jsonData["edited"].rawString()))
                    }
                    //displaying data in tableview
                    self.seeAllTableView.reloadData()
                }
                
                self.indicator.stopAnimating()
                
            case let .failure(error):
                print(error)
                self.indicator.stopAnimating()
                self.seeAllTableView.isHidden = true
                self.errorView.isHidden = false
                self.view.showToast(toastMessage: "Network Error!", duration:2)
            }
        }
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
