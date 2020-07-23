//
//  ProfileViewController.swift
//  SecondIphoneApp
//
//  Created by Wakamoly on 5/20/20.
//  Copyright © 2020 LucidSoftworksLLC. All rights reserved.
//

import UIKit
import EnhancedCircleImageView
import Alamofire
import AlamofireImage
import SwiftyJSON
import AARatingBar

class ProfileViewController: UIViewController {
    
    //test here by putting in either user id or username to load profile, or leave blank to load ours
    var userProfileID: String = ""
    var userUsername: String = "vesanity322"
    let defaultValues = UserDefaults.standard
    let deviceusername = UserDefaults.standard.string(forKey: "device_username")!
    let deviceuserid = UserDefaults.standard.string(forKey: "device_userid")!
    let indicator: UIActivityIndicatorView = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.large)
    
    @IBOutlet weak var profileScrollView: UIScrollView!
    @IBOutlet weak var labelUsername: UILabel!
    @IBOutlet weak var ivCoverPhotoPicker: UIImageView!
    @IBOutlet weak var ivProfilePhotoPicker: UIImageView!
    @IBOutlet weak var ivSupporter: UIImageView!
    @IBOutlet weak var ivVerified: UIImageView!
    @IBOutlet weak var labelNickname: UILabel!
    @IBOutlet weak var profileCoverPic: UIImageView!
    @IBOutlet weak var profilePic: EnhancedCircleImageView!
    @IBOutlet weak var clanTagLabel: UILabel!
    @IBOutlet weak var ivOnline: UIImageView!
    @IBOutlet weak var profileRating: AARatingBar!
    @IBOutlet weak var reviewCount: UILabel!
    @IBOutlet weak var followersCount: UILabel!
    @IBOutlet weak var connectionsCount: UILabel!
    @IBOutlet weak var followingCount: UILabel!
    @IBOutlet weak var userPSNDetails: UIStackView!
    @IBOutlet weak var userXboxDetails: UIStackView!
    @IBOutlet weak var userDiscordDetails: UIStackView!
    @IBOutlet weak var userSteamDetails: UIStackView!
    @IBOutlet weak var userYoutubeDetails: UIStackView!
    @IBOutlet weak var userInstagramDetails: UIStackView!
    @IBOutlet weak var userTwitchDetails: UIStackView!
    @IBOutlet weak var userDiscordProfileDetails: UIStackView!
    @IBOutlet weak var userTwitterDetails: UIStackView!
    @IBOutlet weak var userSwitchDetails: UIStackView!
    @IBOutlet weak var userPSN: UILabel!
    @IBOutlet weak var userXbox: UILabel!
    @IBOutlet weak var userDiscord: UILabel!
    @IBOutlet weak var userSteam: UILabel!
    @IBOutlet weak var userYoutube: UILabel!
    @IBOutlet weak var userInstagram: UILabel!
    @IBOutlet weak var userTwitch: UILabel!
    @IBOutlet weak var userDiscordProfile: UILabel!
    @IBOutlet weak var userTwitter: UILabel!
    @IBOutlet weak var userSwitch: UILabel!
    @IBOutlet weak var profileStatusContainer: UIStackView!
    @IBOutlet weak var labelDescription: UILabel!
    @IBOutlet weak var addPostStack: UIStackView!
    @IBOutlet weak var followProfileStack: UIStackView!
    @IBOutlet weak var followedProfileStack: UIStackView!
    @IBOutlet weak var editProfileStack: UIStackView!
    @IBOutlet weak var addFriendProgress: UIStackView!
    @IBOutlet weak var addFriendStack: UIStackView!
    @IBOutlet weak var connectedStack: UIStackView!
    @IBOutlet weak var requestedFriendStack: UIStackView!
    @IBOutlet weak var requestSentStack: UIStackView!
    @IBOutlet weak var sendMessageStack: UIStackView!
    @IBOutlet weak var moreStack: UIStackView!
    @IBOutlet weak var profileWebsiteContainer: UIStackView!
    @IBOutlet weak var profileWebsiteLabel: UILabel!
    @IBOutlet weak var noProfileView: UIView!
    
    
    @IBAction func buttonLogout(_ sender: UIButton) {
        
        //removing values from default
        defaultValues.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
        defaultValues.synchronize()
        
        //switching to login screen
        /*let loginViewController = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
         self.navigationController?.pushViewController(loginViewController, animated: true)
         self.dismiss(animated: false,completion: nil)*/
        performSegue(withIdentifier: "ToLogin", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ToLogin" {
            _ = segue.destination as? LoginViewController
        }
    }
    
    func loadProfileTop(_ userProfileIDS:String){
        indicator.startAnimating()
        AF.request(URLConstants.ROOT_URL+"profiletop_api.php?userid="+deviceuserid+"&userid2="+userProfileIDS+"&deviceusername="+deviceusername, method: .get).responseJSON{
            response in
            //printing response
            print(response)
            
            switch response.result {
            case .success(let value):
                let jsonObject = JSON(value)
                let jsonData = jsonObject[0]
                if (jsonData["id"].rawString() == userProfileIDS) {
                    let thisProfileID = jsonData["id"]
                    let nickname = jsonData["nickname"].rawString()
                    let username = jsonData["username"].rawString()
                    let description = jsonData["description"].string
                    let verified = jsonData["verified"].string
                    let profile_pic = jsonData["profile_pic"].string
                    let cover_pic = jsonData["cover_pic"].string
                    let num_posts = jsonData["num_posts"].rawString()
                    let user_closed = jsonData["user_closed"].string
                    let user_banned = jsonData["user_banned"].string
                    let num_friends = jsonData["num_friends"].rawString()
                    let followings = jsonData["followings"].rawString()
                    let followers = jsonData["followers"].rawString()
                    let twitch = jsonData["twitch"].string
                    //let mixer = jsonData["mixer"].string
                    let psn = jsonData["psn"].string
                    let xbox = jsonData["xbox"].string
                    let discord = jsonData["discord"].string
                    let steam = jsonData["steam"].string
                    let instagram = jsonData["instagram"].string
                    let youtube = jsonData["youtube"].string
                    let last_online = jsonData["last_online"].string
                    let count = jsonData["count"].int
                    let average = jsonData["average"].int
                    let clantag = jsonData["clantag"].string
                    let blocked = jsonData["blocked"].string
                    let supporter = jsonData["supporter"].string
                    let discord_user = jsonData["discord_user"].string
                    let twitter = jsonData["twitter"].string
                    let website = jsonData["website"].string
                    let nintendo = jsonData["nintendo"].string
                    let isFollowing = jsonData["isFollowing"].string
                    let isConnected = jsonData["isConnected"].string
                    let connections = jsonData["connections"].string
                    
                    
                    
                    self.userUsername = username!
                    if(self.deviceuserid == self.userProfileID){
                        //TODO: Profile buttons turn off/on
                        self.sendMessageStack.isHidden = true
                        self.addFriendStack.isHidden = true
                        self.addFriendProgress.isHidden = true
                        self.followProfileStack.isHidden = true
                        self.editProfileStack.isHidden = false
                        self.ivCoverPhotoPicker.isHidden = false
                        self.ivProfilePhotoPicker.isHidden = false
                        
                        let fGuesture = UITapGestureRecognizer(target: self, action: #selector(ProfileViewController.showF(_:)))
                        self.ivCoverPhotoPicker.addGestureRecognizer(fGuesture)

                        
                    }else{
                        self.sendMessageStack.isHidden = false
                        self.addFriendStack.isHidden = false
                        self.addFriendProgress.isHidden = false
                        self.followProfileStack.isHidden = false
                        self.editProfileStack.isHidden = true
                        self.ivCoverPhotoPicker.isHidden = true
                        self.ivProfilePhotoPicker.isHidden = true
                    }
                    
                    //TODO: parse out user defaults for if user is blocked, then add || isUserBlocked
                    if(blocked=="yes"){
                        self.noProfileView.isHidden = false
                    }else if (user_closed=="yes"||user_banned=="yes"){
                        self.noProfileView.isHidden = false
                    }else{
                        //TODO: load profile posts
                        //postsQueryButtonClicked(profilePostsButton)
                    }
                    
                    if(clantag != ""){
                        self.clanTagLabel.text = "["+clantag!+"]"
                    }else{
                        self.clanTagLabel.isHidden=true
                    }
                    
                    if(!(supporter=="yes")){
                        self.ivSupporter.isHidden=true
                    }
                    
                    if(discord_user != ""){
                        self.userDiscordProfile.text = discord_user
                    }else{
                        self.userDiscordProfileDetails.isHidden = true
                    }
                    if (twitter != "") {
                        self.userTwitter.text = twitter
                    }else{
                        self.userTwitterDetails.isHidden = true
                    }
                    if (website != "") {
                        self.profileWebsiteLabel.text = website!
                    }else{
                        self.profileWebsiteContainer.isHidden = true
                    }
                    if (nintendo != "") {
                        self.userSwitch.text = nintendo
                    }else{
                        self.userSwitchDetails.isHidden = true
                    }
                    
                    //TODO: add profile cover click
                    
                    //TODO: add profile pic click
                    
                    //TODO: Add message button to message->user
                    
                    self.followersCount.text = followers!
                    self.followingCount.text = followings!
                    self.connectionsCount.text = num_friends!
                    
                    if (twitch != "") {
                        self.userTwitch.text = twitch
                    }else{
                        self.userTwitchDetails.isHidden = true
                    }
                    if psn != "" {
                        self.userPSN.text = psn
                    }else{
                        self.userPSNDetails.isHidden  = true
                    }
                    if xbox != "" {
                        self.userXbox.text = xbox
                    }else{
                        self.userXboxDetails.isHidden = true
                    }
                    if discord != "" {
                        self.userDiscord.text = "Discord Server"
                    }else{
                        self.userDiscordDetails.isHidden = true
                    }
                    if steam != "" {
                        self.userSteam.text = steam
                    }else{
                        self.userSteamDetails.isHidden = true
                    }
                    if youtube != "" {
                        self.userYoutube.text = "YouTube"
                    }else{
                        self.userYoutubeDetails.isHidden = true
                    }
                    if instagram != "" {
                        self.userInstagram.text = instagram
                    }else{
                        self.userInstagramDetails.isHidden = true
                    }
                    
                    let averageFloat = Float(average!)
                    self.profileRating.value = CGFloat(averageFloat)
                    //print(self.profileRating.value)
                    self.reviewCount.text = String(count!)
                    
                    var username_to = ""
                    if self.deviceusername == username {
                        username_to = username!
                        if isFollowing == "yes" {
                            //
                        }
                        if isConnected == "yes" {
                            //
                        }else{
                            //connectionRequest(username)
                        }
                        if (!(isConnected == "no")) && !(userProfileIDS == self.deviceuserid) {
                            //
                        }
                    }else{
                        // profile is device user's
                        username_to = "none"
                        //TODO: Set our profile picture here in user defaults if they don't match
                    }
                    
                    //TODO submitStatusButton on click
                    
                    //TODO playerratingLayout on click
                    
                    //TODO moreButtonLayout on click
                    
                    //TODO followProfileButton on click
                    //TODO followedProfileButton on click
                    //TODO addFriendButton on click
                    //TODO requestedFriendButton on click
                    //TODO requestSentFriendButton on click
                    //TODO addedFriendButton on click
                    
                    if description != "" {
                        self.labelDescription.text = description!
                    }else{
                        self.profileStatusContainer.isHidden = true
                    }
                    if verified != "yes" {
                        self.ivVerified.isHidden = true
                    }
                    if last_online != "yes" {
                        self.ivOnline.isHidden = true
                    }
                    self.labelUsername.text = "@"+username!
                    self.labelNickname.text = nickname
                    //self.postsnum set text num_posts
                    
                    let filter = AspectScaledToFillSizeWithRoundedCornersFilter(
                        size: self.profileCoverPic.frame.size,
                        radius:0
                    )
                    self.profileCoverPic.af.setImage(
                        withURL: URL(string:URLConstants.BASE_URL+cover_pic!)!,
                        filter: filter,
                        imageTransition: .crossDissolve(0.2)
                    )
                    self.profilePic.af.setImage(
                        withURL: URL(string:URLConstants.BASE_URL+profile_pic!)!,
                        imageTransition: .crossDissolve(0.2)
                    )
                    
                    //TODO followersTextView on click
                    //TODO followingTV on click
                    //TODO connectionsTV on click
                    
                    self.indicator.stopAnimating()
                    self.profileScrollView.isHidden = false
                    
                }else{
                    self.indicator.stopAnimating()
                    self.noProfileView.isHidden = false
                }
            case let .failure(error):
                print(error)
                self.indicator.stopAnimating()
                self.noProfileView.isHidden = false
                self.view.showToast(toastMessage: "Network Error!", duration:2)
            }
        }
    }
    
    func getUserID(_ userUsernameS:String){
        let parameters: Parameters=["username":userUsernameS]
        AF.request(URLConstants.ROOT_URL+"get_userid.php", method: .post, parameters: parameters).responseJSON{
            response in
            //printing response
            print(response)
            
            //yeet
            //yeet 2
            
            switch response.result {
            case .success(let value):
                let jsonData = JSON(value)
                ///self.labelMessage.text = jsonData["message"].string
                if (!((jsonData["error"].string != nil))) {
                    if (jsonData["error"].string=="false"){
                        self.userProfileID = jsonData["userid"].rawString()!
                        self.loadProfileTop(self.userProfileID)
                    }else{
                        let message = jsonData["message"].string
                        self.view.showToast(toastMessage: message!, duration:2)
                    }
                }else{
                    self.view.showToast(toastMessage: "An error occured!", duration:2)
                }
            case let .failure(error):
                print(error)
                self.view.showToast(toastMessage: "Network error!", duration:2)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //ivVerified.circled.image = UIImage()
        //ivCoverPhotoPicker.circled.image = UIImage()
        //ivProfilePhotoPicker.circled.image = UIImage()
        //profilePic.circled.image = UIImage()
        //hiding back button -- no need since nav controller is set to be invisible in storyboard
        /*let backButton = UIBarButtonItem(title: "", style: UIBarButtonItem.Style.plain, target: navigationController, action: nil)
         navigationItem.leftBarButtonItem = backButton*/
        
        profileScrollView.isHidden = true
        indicator.frame = CGRect(x: 0, y: 0, width: 60, height: 60)
        indicator.center = view.center
        self.view.addSubview(indicator)
        self.view.bringSubviewToFront(indicator)
        
        //getting user data from defaults
        if defaultValues.string(forKey: "device_userid") == nil{
            //user not signed in
            defaultValues.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
            defaultValues.synchronize()
            performSegue(withIdentifier: "ToLogin", sender: nil)
        }
        
        if !(userProfileID==""){
            loadProfileTop(userProfileID)
        }else if !(userUsername==""){
            getUserID(userUsername)
        }else{
            userProfileID = defaultValues.string(forKey: "device_userid")!
            loadProfileTop(userProfileID)
        }
        
        profilePic.layer.borderColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1.0).cgColor
        profilePic.layer.masksToBounds = true
        profilePic.contentMode = .scaleToFill
        profilePic.layer.borderWidth = 7
        
        /*let imageurl: String=URLConstants.BASE_URL+defaultValues.string(forKey: "device_profilepic")!
         let url = URL(string:imageurl)
         
         let filter = AspectScaledToFillSizeWithRoundedCornersFilter(
         size: profileCoverPic.frame.size,
         radius:0
         )
         
         profileCoverPic.af.setImage(
         withURL: url!,
         filter: filter,
         imageTransition: .crossDissolve(0.2)
         )
         
         AF.request(URLConstants.BASE_URL+defaultValues.string(forKey: "device_profilepic")!,method: .get).response{ response in
         
         switch response.result {
         case .success(let responseData):
         self.profilePic.image = UIImage(data: responseData!, scale:1)
         self.profilePic.af.setImage(withURL: url!)
         print("Image set",response.result)
         case .failure(let error):
         print("error--->",error)
         }
         }*/
        
        /*AF.request( "https://robohash.org/123.png",method: .get).response{ response in
         
         switch response.result {
         case .success(let responseData):
         self.bottomImageView.image = UIImage(data: responseData!, scale:1)
         print("bottomImage set",response.result)
         case .failure(let error):
         print("error--->",error)
         }
         }*/
        
        
        
    }
    
    @objc func showF(_ sender: UITapGestureRecognizer){
        print("Yeetus SKeetus")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
