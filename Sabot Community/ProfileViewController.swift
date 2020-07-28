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

class ProfileViewController: UIViewController, UITextViewDelegate, UITableViewDataSource, UITableViewDelegate {
     
    

    private var profileNews = [ProfileNewsModel]()
    //test here by putting in either user id or username to load profile, or leave blank to load yours
    var userProfileID: String = ""
    var userUsername: String = ""
    let defaultValues = UserDefaults.standard
    let deviceusername = UserDefaults.standard.string(forKey: "device_username")!
    let deviceuserid = UserDefaults.standard.string(forKey: "device_userid")!
    let indicator: UIActivityIndicatorView = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.large)
    
    @IBOutlet weak var profileScrollView: UIScrollView!
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
    @IBOutlet weak var statusUpdate: UITextView!
    @IBOutlet weak var addPostView: UIView!
    @IBOutlet weak var postsQueryButton: UIButton!
    @IBOutlet weak var publicsPostsQueryButton: UIButton!
    @IBOutlet weak var clansQueryButton: UIButton!
    //@IBOutlet weak var postsNumLabel: UILabel!
    @IBOutlet weak var seeAllButton: UIButton!
    @IBOutlet weak var profilePostsTableView: UITableView!
    @IBOutlet weak var profileItemsLabel: UILabel!
    
    
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
                    let thisProfileID = jsonData["id"].int
                    let nickname = jsonData["nickname"].rawString()
                    let username = jsonData["username"].rawString()
                    let description = jsonData["description"].string
                    let verified = jsonData["verified"].string
                    let profile_pic = jsonData["profile_pic"].string
                    let cover_pic = jsonData["cover_pic"].string
                    //let num_posts = jsonData["num_posts"].rawString()
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
                        /*self.sendMessageStack.isHidden = false
                        self.addFriendStack.isHidden = false
                        self.addFriendProgress.isHidden = false
                        self.followProfileStack.isHidden = false*/
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
                        self.postsQueryButtonClicked(self.postsQueryButton)
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
                    if !(self.deviceusername == username) {
                        //not our device's profile
                        username_to = username!
                        if (isFollowing == "yes") {
                            self.followProfileStack.isHidden = true
                            self.followedProfileStack.isHidden = false
                        }
                        if (isConnected == "yes") {
                            // we are connected
                            self.connectedStack.isHidden = false
                            self.addFriendProgress.isHidden = true
                            self.addPostStack.isHidden = false
                        }else{
                            // we are not connected
                            self.connectionRequest(username!)
                        }
                        if (!(isConnected == "yes")) && !(userProfileIDS == self.deviceuserid) {
                            // we are not connected and this is not our device's profile
                            self.addPostStack.isHidden = true
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
                    self.navigationItem.title = "@"+username!
                    self.labelNickname.text = nickname
                    //self.postsNumLabel.text = num_posts
                    
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
    
    func loadProfileNews(){
        AF.request(URLConstants.ROOT_URL+"profilenews_api.php?userid="+deviceuserid+"&userprofileid="+userProfileID+"&thisusername="+deviceusername, method: .get).responseJSON{
            response in
            //printing response
            print(response)
            
            switch response.result {
            case .success(let value):
                let jsonObject = JSON(value)
                for i in 0..<jsonObject.count{
                    let jsonData = jsonObject[i]
                    self.profileNews.append(ProfileNewsModel(
                        id: jsonData["id"].int,
                        type: jsonData["type"].string,
                        likes: jsonData["likes"].rawString(),
                        body: jsonData["body"].rawString(),
                        added_by: jsonData["added_by"].rawString(),
                        user_to: jsonData["user_to"].rawString(),
                        date_added: jsonData["date_added"].rawString(),
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
                self.profilePostsTableView.reloadData()
            case let .failure(error):
                print(error)
            }
        }
    }
    
    func loadJoinedClans(){
        
    }
    
    func loadProfilePublics(){
        
    }
    
    func postsQueryButtonClicked(_ buttonPressed:UIButton){
        if(buttonPressed == self.postsQueryButton){
            self.postsQueryButton.backgroundColor = UIColor(named: "green")
            self.clansQueryButton.backgroundColor = UIColor(named: "grey_80")
            self.publicsPostsQueryButton.backgroundColor = UIColor(named: "grey_80")
            loadProfileNews()
            self.profileItemsLabel.text = "Profile Posts"
            self.seeAllButton.isHidden = false
        }else if (buttonPressed == self.clansQueryButton){
            self.postsQueryButton.backgroundColor = UIColor(named: "grey_80")
            self.clansQueryButton.backgroundColor = UIColor(named: "green")
            self.publicsPostsQueryButton.backgroundColor = UIColor(named: "grey_80")
            //loadJoinedClans()
            self.profileItemsLabel.text = "Clans Joined"
            self.seeAllButton.isHidden = true
        }else if (buttonPressed == self.publicsPostsQueryButton){
            self.postsQueryButton.backgroundColor = UIColor(named: "grey_80")
            self.clansQueryButton.backgroundColor = UIColor(named: "grey_80")
            self.publicsPostsQueryButton.backgroundColor = UIColor(named: "green")
            //loadProfilePublics()
            self.profileItemsLabel.text = "Clans Joined"
            self.seeAllButton.isHidden = true
        }
    }
    
    func getUserID(_ userUsernameS:String){
        let parameters: Parameters=["username":userUsernameS]
        AF.request(URLConstants.ROOT_URL+"get_userid.php", method: .post, parameters: parameters).responseJSON{
            response in
            //printing response
            print(response)
            
            switch response.result {
            case .success(let value):
                let jsonData = JSON(value)
                ///self.labelMessage.text = jsonData["message"].string
                if (jsonData["error"]==false){
                    self.userProfileID = jsonData["userid"].rawString()!
                    self.loadProfileTop(self.userProfileID)
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
        
        statusUpdate.delegate = self
        statusUpdate.text = "Let your followers know what you're up to..."
        statusUpdate.textColor = UIColor.lightGray
        
        /*for i in 0...1000 {
             data.append("\(i)")
        }*/
        //profilePostsTableView.register(UINib(nibName: "ProfilePostsTVC", bundle: nil), forCellReuseIdentifier: "postsReuse")
        profilePostsTableView.dataSource = self
        profilePostsTableView.delegate = self
        
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
    
    func followUser(_ usernameThis:String, _ followersThis:String, _ method:String){
        if(method == "follow"){
            self.followProfileStack.isHidden = true
            self.followedProfileStack.isHidden = false
            var numFollowers = Int(followersThis)
            numFollowers! += 1
            self.followersCount.text = String(numFollowers!)
        }else if (method == "unfollow"){
            self.followedProfileStack.isHidden = true
            self.followProfileStack.isHidden = false
            var numFollowers = Int(followersThis)
            numFollowers! -= 1
            self.followersCount.text = String(numFollowers!)
        }
        let parameters: Parameters=["username":deviceusername,"user_followed":usernameThis,"user_id":deviceuserid,"method":method]
        AF.request(URLConstants.ROOT_URL+"user_follow_api.php", method: .post, parameters: parameters).responseJSON{
            response in
            print(response)
            
            switch response.result {
            case .success(let value):
                let jsonData = JSON(value)
                if (jsonData["error"]==false){
                    self.view.showToast(toastMessage: jsonData["message"].string!, duration:2)
                }else{
                    self.view.showToast(toastMessage: "Server error!", duration:2)
                }
            case let .failure(error):
                print(error)
                self.view.showToast(toastMessage: "Could not un/follow user, please try again!", duration:2)
            }
        }
    }
    
    func connectionRequest(_ usernameQuery:String){
        let parameters: Parameters=["username":deviceusername,"thisusername":usernameQuery]
        AF.request(URLConstants.ROOT_URL+"get_profile_requests.php", method: .post, parameters: parameters).responseJSON{
            response in
            //printing response
            print(response)
            
            switch response.result {
            case .success(let value):
                let jsonData = JSON(value)
                if (jsonData["error"]==false){
                    if(jsonData["request_sent"].string == "yes"){
                        self.requestSentStack.isHidden = false
                        self.addFriendStack.isHidden = true
                        self.addFriendProgress.isHidden = true
                    }else if (jsonData["request_received"].string == "yes"){
                        self.requestedFriendStack.isHidden = false
                        self.addFriendStack.isHidden = true
                        self.addFriendProgress.isHidden = true
                    }else if (!(self.addFriendStack.isHidden || self.userProfileID == self.deviceuserid)){
                        self.addFriendStack.isHidden = false
                        self.addFriendProgress.isHidden = true
                    }
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
    
    func addConnection(_ usernameQuery:String){
        let parameters: Parameters=["username":deviceusername,"thisusername":usernameQuery]
        AF.request(URLConstants.ROOT_URL+"add_connection.php", method: .post, parameters: parameters).responseJSON{
            response in
            print(response)
            
            switch response.result {
            case .success(let value):
                let jsonData = JSON(value)
                if (jsonData["error"]==false){
                    if(jsonData["request_sent"] == "yes"){
                        self.view.showToast(toastMessage: "Request Sent!", duration:2)
                    }
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
    
    func acceptConnection(_ usernameQuery:String){
        let parameters: Parameters=["username":deviceusername,"thisusername":usernameQuery]
        AF.request(URLConstants.ROOT_URL+"accept_connection.php", method: .post, parameters: parameters).responseJSON{
            response in
            print(response)
            
            switch response.result {
            case .success(let value):
                let jsonData = JSON(value)
                if (jsonData["error"]==false){
                    if(jsonData["request_accepted"] == "yes"){
                        self.connectedStack.isHidden = false
                        self.requestedFriendStack.isHidden = true
                    }
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
    
    @objc func showF(_ sender: UITapGestureRecognizer){
        print("Yeetus SKeetus")
    }
    
    func textViewDidBeginEditing(_ statusUpdate: UITextView) {
        if statusUpdate.textColor == UIColor.lightGray {
            statusUpdate.text = nil
            statusUpdate.textColor = UIColor.white
        }
    }
    
    func textViewDidEndEditing(_ statusUpdate: UITextView) {
        if statusUpdate.text.isEmpty {
            statusUpdate.text = "Let your followers know what you're up to..."
            statusUpdate.textColor = UIColor.lightGray
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //the method returning size of the list
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return profileNews.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "postsReuse") as! ProfilePostsTVC
           
        //getting the hero for the specified position
        let profilesNewsI: ProfileNewsModel
        profilesNewsI = profileNews[indexPath.row]
        
        //displaying values
        cell.usernameLabel.text = "@"+profilesNewsI.username!
        cell.nicknameLabel.text = profilesNewsI.nickname
        cell.postBody.text = profilesNewsI.body
        
        if profilesNewsI.user_to != "none"{
            cell.toUsernameLabel.text = "to "+profilesNewsI.user_to!
        }else{
            cell.toUsernameLabel.isHidden = true
        }
        
        if profilesNewsI.likedbyuser == "yes"{
            cell.likeView.isHidden = true
            cell.likedView.isHidden = false
        }else{
            cell.likeView.isHidden = false
            cell.likedView.isHidden = true
        }
        
        cell.numLikes.text = profilesNewsI.likes
        cell.numComments.text = profilesNewsI.commentcount
        cell.dateView.text = profilesNewsI.date_added
        
        if profilesNewsI.online == "yes"{
            cell.onlineView.isHidden = false
            cell.onlineView.layer.borderColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1.0).cgColor
            cell.onlineView.layer.masksToBounds = true
            cell.onlineView.contentMode = .scaleToFill
            cell.onlineView.layer.borderWidth = 2
        }else{
            cell.onlineView.isHidden = true
        }
        if profilesNewsI.verified == "yes"{
            cell.verifiedView.isHidden = false
        }else{
            cell.verifiedView.isHidden = true
        }
        
        switch profilesNewsI.type{
            case "Xbox":
                cell.platformType.image = UIImage(named: "icons8_xbox_50")
                break
            case "PlayStation":
                cell.platformType.image = UIImage(named: "icons8_playstation_50")
                break
            case "Steam":
                cell.platformType.image = UIImage(named: "icons8_steam_48")
                break
            case "PC":
                cell.platformType.image = UIImage(named: "icons8_workstation_48")
                break
            case "Mobile":
                cell.platformType.image = UIImage(named: "icons8_mobile_48")
                break
            case "Switch":
                cell.platformType.image = UIImage(named: "icons8_nintendo_switch_48")
                break
            case "General":
                cell.platformType.isHidden = true
                break
        default:
            cell.platformType.image = UIImage(named: "icons8_question_mark_64")
        }
        
        let profilePicIndex = profilesNewsI.profile_pic?.firstIndex(of: ".")!
        let profile_pic = (profilesNewsI.profile_pic?.prefix(upTo: profilePicIndex!))!+"_r.JPG"
        cell.profilePhoto.af.setImage(
            withURL: URL(string:URLConstants.BASE_URL+profile_pic)!,
            imageTransition: .crossDissolve(0.2)
        )
        
        if profilesNewsI.image != "" {
            cell.postImage.isHidden = false
            cell.postImage!.af.setImage(
                withURL: URL(string:URLConstants.BASE_URL+profilesNewsI.image!)!,
                imageTransition: .crossDissolve(0.2)
            )
        }else{
            cell.postImage.isHidden = true
        }
           
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            
         let alertController = UIAlertController(title: "Hint", message: "You have selected row \(indexPath.row).", preferredStyle: .alert)
            
         let alertAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
            
         alertController.addAction(alertAction)
            
         present(alertController, animated: true, completion: nil)
            
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
}
