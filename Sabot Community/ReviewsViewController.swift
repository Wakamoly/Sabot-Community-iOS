//
//  ReviewsViewController.swift
//  Sabot Community
//
//  Created by Wakamoly on 8/6/20.
//  Copyright © 2020 LucidSoftworksLLC. All rights reserved.
//

import UIKit
import EnhancedCircleImageView
import AlamofireImage
import Alamofire
import SwiftyJSON
import ZGRatingView
import AARatingBar

class ReviewsViewController: UIViewController {
    
    var query:String = ""
    var queryName:String = ""
    var queryID:String = ""
    let defaultValues = UserDefaults.standard
    let deviceusername = UserDefaults.standard.string(forKey: "device_username")!
    let deviceuserid = UserDefaults.standard.string(forKey: "device_userid")!
    let indicator: UIActivityIndicatorView = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.large)
    
    @IBOutlet weak var reviewsScrollView: UIScrollView!
    @IBOutlet weak var profileImageReviewed: EnhancedCircleImageView!
    @IBOutlet weak var verifiedView: UIImageView!
    @IBOutlet weak var usernameView: UILabel!
    @IBOutlet weak var nicknameView: UILabel!
    @IBOutlet weak var onlineView: UIImageView!
    @IBOutlet weak var toReviewThisButton: UIButton!
    @IBOutlet weak var fiveStarBar: UIProgressView!
    @IBOutlet weak var fourStarBar: UIProgressView!
    @IBOutlet weak var threeStarBar: UIProgressView!
    @IBOutlet weak var twoStarBar: UIProgressView!
    @IBOutlet weak var oneStarBar: UIProgressView!
    @IBOutlet weak var numReviews: UILabel!
    @IBOutlet weak var reviewsAverage: UILabel!
    @IBOutlet weak var starReviewBar: AARatingBar!
    @IBOutlet weak var reviewsTableView: UITableView!
    @IBOutlet weak var noReviewsLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        toReviewThisButton.layer.cornerRadius = 05
        
        reviewsScrollView.isHidden = true
        
        //start loading indicator
        indicator.frame = CGRect(x: 0, y: 0, width: 60, height: 60)
        indicator.center = view.center
        self.view.addSubview(indicator)
        self.view.bringSubviewToFront(indicator)
        self.indicator.isOpaque = false
        self.indicator.layer.cornerRadius = 05
        self.indicator.backgroundColor = (UIColor .black .withAlphaComponent(0.6))
        
        self.navigationItem.title = "@"+queryName
        
        loadReviewsTop()
    }
    
    func loadReviewsTop(){
        indicator.startAnimating()
        self.indicator.stopAnimating()
        self.reviewsScrollView.isHidden = false
        
//        //TODO create backend
//
//        AF.request(URLConstants.ROOT_URL+"reviewsTopGet.php?userid="+deviceuserid+"&userQuery="+queryID+"&query="+query, method: .get).responseJSON{
//            response in
//            //printing response
//            print(response)
//
//            switch response.result {
//            case .success(let value):
//                let jsonObject = JSON(value)
//                let jsonData = jsonObject[0]
//                if (jsonData["id"].rawString() == userProfileIDS) {
//                    let thisProfileID = jsonData["id"].int
//                    let nickname = jsonData["nickname"].rawString()
//                    let username = jsonData["username"].rawString()
//                    let description = jsonData["description"].string
//                    let verified = jsonData["verified"].string
//                    let profile_pic = jsonData["profile_pic"].string
//                    let cover_pic = jsonData["cover_pic"].string
//                    //let num_posts = jsonData["num_posts"].rawString()
//                    let user_closed = jsonData["user_closed"].string
//                    let user_banned = jsonData["user_banned"].string
//                    let num_friends = jsonData["num_friends"].rawString()
//                    let followings = jsonData["followings"].rawString()
//                    let followers = jsonData["followers"].rawString()
//                    let twitch = jsonData["twitch"].string
//                    //let mixer = jsonData["mixer"].string
//                    let psn = jsonData["psn"].string
//                    let xbox = jsonData["xbox"].string
//                    let discord = jsonData["discord"].string
//                    let steam = jsonData["steam"].string
//                    let instagram = jsonData["instagram"].string
//                    let youtube = jsonData["youtube"].string
//                    let last_online = jsonData["last_online"].string
//                    let count = jsonData["count"].int
//                    let average = jsonData["average"].int
//                    let clantag = jsonData["clantag"].string
//                    let blocked = jsonData["blocked"].string
//                    let supporter = jsonData["supporter"].string
//                    let discord_user = jsonData["discord_user"].string
//                    let twitter = jsonData["twitter"].string
//                    let website = jsonData["website"].string
//                    let nintendo = jsonData["nintendo"].string
//                    let isFollowing = jsonData["isFollowing"].string
//                    let isConnected = jsonData["isConnected"].string
//                    let connections = jsonData["connections"].string
//
//
//                    self.userUsername = username!
//                    if(self.deviceuserid == self.userProfileID){
//                        //TODO: Profile buttons turn off/on
//                        self.sendMessageStack.isHidden = true
//                        self.addFriendStack.isHidden = true
//                        self.addFriendProgress.isHidden = true
//                        self.followProfileStack.isHidden = true
//                        self.editProfileStack.isHidden = false
//                        self.ivCoverPhotoPicker.isHidden = false
//                        self.ivProfilePhotoPicker.isHidden = false
//
//                        let fGuesture = UITapGestureRecognizer(target: self, action: #selector(ProfileViewController.showF(_:)))
//                        self.ivCoverPhotoPicker.addGestureRecognizer(fGuesture)
//
//                    }else{
//                        /*self.sendMessageStack.isHidden = false
//                         self.addFriendStack.isHidden = false
//                         self.addFriendProgress.isHidden = false
//                         self.followProfileStack.isHidden = false*/
//                        self.editProfileStack.isHidden = true
//                        self.ivCoverPhotoPicker.isHidden = true
//                        self.ivProfilePhotoPicker.isHidden = true
//                    }
//
//                    //TODO: parse out user defaults for if user is blocked, then add || isUserBlocked
//                    if(blocked=="yes"){
//                        self.noProfileView.isHidden = false
//                    }else if (user_closed=="yes"||user_banned=="yes"){
//                        self.noProfileView.isHidden = false
//                    }else{
//                        self.postsQueryButtonClicked(self.postsQueryButton)
//                    }
//
//                    if(clantag != ""){
//                        self.clanTagLabel.text = "["+clantag!+"]"
//                    }else{
//                        self.clanTagLabel.isHidden=true
//                    }
//
//                    if(!(supporter=="yes")){
//                        self.ivSupporter.isHidden=true
//                    }
//
//                    if(discord_user != ""){
//                        self.userDiscordProfile.text = discord_user
//                    }else{
//                        self.userDiscordProfileDetails.isHidden = true
//                    }
//                    if (twitter != "") {
//                        self.userTwitter.text = twitter
//                    }else{
//                        self.userTwitterDetails.isHidden = true
//                    }
//                    if (website != "") {
//                        self.profileWebsiteLabel.text = website!
//                        self.profileWebsiteLabel.handleURLTap { (URL) in
//                            UIApplication.shared.open(URL as URL, options: [:], completionHandler: nil)
//                        }
//                    }else{
//                        self.profileWebsiteContainer.isHidden = true
//                    }
//                    if (nintendo != "") {
//                        self.userSwitch.text = nintendo
//                    }else{
//                        self.userSwitchDetails.isHidden = true
//                    }
//
//                    //TODO: add profile cover click
//
//                    //TODO: add profile pic click
//
//                    //TODO: Add message button to message->user
//
//                    self.followersCount.text = followers!
//                    self.followingCount.text = followings!
//                    self.connectionsCount.text = num_friends!
//
//                    if (twitch != "") {
//                        self.userTwitch.text = twitch
//                    }else{
//                        self.userTwitchDetails.isHidden = true
//                    }
//                    if psn != "" {
//                        self.userPSN.text = psn
//                    }else{
//                        self.userPSNDetails.isHidden  = true
//                    }
//                    if xbox != "" {
//                        self.userXbox.text = xbox
//                    }else{
//                        self.userXboxDetails.isHidden = true
//                    }
//                    if discord != "" {
//                        self.userDiscord.text = "Discord Server"
//                    }else{
//                        self.userDiscordDetails.isHidden = true
//                    }
//                    if steam != "" {
//                        self.userSteam.text = steam
//                    }else{
//                        self.userSteamDetails.isHidden = true
//                    }
//                    if youtube != "" {
//                        self.userYoutube.text = "YouTube"
//                    }else{
//                        self.userYoutubeDetails.isHidden = true
//                    }
//                    if instagram != "" {
//                        self.userInstagram.text = instagram
//                    }else{
//                        self.userInstagramDetails.isHidden = true
//                    }
//
//                    let averageFloat = Float(average!)
//                    self.profileRating.value = CGFloat(averageFloat)
//                    //print(self.profileRating.value)
//                    self.reviewCount.text = String(count!)
//
//                    var username_to = ""
//                    if !(self.deviceusername == username) {
//                        //not our device's profile
//                        username_to = username!
//                        if (isFollowing == "yes") {
//                            self.followProfileStack.isHidden = true
//                            self.followedProfileStack.isHidden = false
//                        }
//                        if (isConnected == "yes") {
//                            // we are connected
//                            self.connectedStack.isHidden = false
//                            self.addFriendProgress.isHidden = true
//                            self.addPostStack.isHidden = false
//                        }else{
//                            // we are not connected
//                            self.connectionRequest(username!)
//                        }
//                        if (!(isConnected == "yes")) && !(userProfileIDS == self.deviceuserid) {
//                            // we are not connected and this is not our device's profile
//                            self.addPostStack.isHidden = true
//                        }
//                    }else{
//                        // profile is device user's
//                        username_to = "none"
//                        //TODO: Set our profile picture here in user defaults if they don't match
//                    }
//
//                    /*let fGuesture = UITapGestureRecognizer(target: self, action: #selector(ProfileViewController.showF(_:)))
//                     self.ivCoverPhotoPicker.addGestureRecognizer(fGuesture)*/
//
//                    //TODO submitStatusButton on click
//
//                    //TODO playerratingLayout on click
//
//                    //TODO moreButtonLayout on click
//
//                    //TODO followProfileButton on click
//                    //TODO followedProfileButton on click
//                    //TODO addFriendButton on click
//                    //TODO requestedFriendButton on click
//                    //TODO requestSentFriendButton on click
//                    //TODO addedFriendButton on click
//
//                    if description != "" {
//                        self.labelDescription.text = description!
//                    }else{
//                        self.profileStatusContainer.isHidden = true
//                    }
//                    if verified != "yes" {
//                        self.ivVerified.isHidden = true
//                    }
//                    if last_online != "yes" {
//                        self.ivOnline.isHidden = true
//                    }
//                    self.navigationItem.title = "@"+username!
//                    self.labelNickname.text = nickname
//                    //self.postsNumLabel.text = num_posts
//
//                    let filter = AspectScaledToFillSizeWithRoundedCornersFilter(
//                        size: self.profileCoverPic.frame.size,
//                        radius:0
//                    )
//                    self.profileCoverPic.af.setImage(
//                        withURL: URL(string:URLConstants.BASE_URL+cover_pic!)!,
//                        filter: filter,
//                        imageTransition: .crossDissolve(1.25)
//                    )
//                    self.profilePic.af.setImage(
//                        withURL: URL(string:URLConstants.BASE_URL+profile_pic!)!,
//                        imageTransition: .crossDissolve(1)
//                    )
//
//                    //TODO followersTextView on click
//                    //TODO followingTV on click
//                    //TODO connectionsTV on click
//
//                    self.indicator.stopAnimating()
//                    self.profileRefresh.endRefreshing()
//                    self.reviewsScrollView.isHidden = false
//
//                }else{
//                    self.indicator.stopAnimating()
//                    self.profileRefresh.endRefreshing()
//                    self.noProfileView.isHidden = false
//                }
//            case let .failure(error):
//                print(error)
//                self.indicator.stopAnimating()
//                self.profileRefresh.endRefreshing()
//                self.noProfileView.isHidden = false
//                self.view.showToast(toastMessage: "Network Error!", duration:2)
//            }
//        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
 
}
