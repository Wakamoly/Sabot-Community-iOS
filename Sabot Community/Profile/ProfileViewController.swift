//
//  ProfileViewController.swift
//  Sabot Community
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
import ActiveLabel
import iOSDropDown
import SafariServices
import CropViewController

// isModal to find out if VC is presented modally, disabling scroll-up refreshing
extension UIViewController {
    var isModal: Bool {
        if let index = navigationController?.viewControllers.firstIndex(of: self), index > 0 {
            return false
        } else if presentingViewController != nil {
            return true
        } else if let navigationController = navigationController, navigationController.presentingViewController?.presentedViewController == navigationController {
            return true
        } else if let tabBarController = tabBarController, tabBarController.presentingViewController is UITabBarController {
            return true
        } else {
            return false
        }
    }
}

class ProfileViewController: UIViewController, UITextViewDelegate, UITableViewDataSource, UITableViewDelegate, NotifyReloadProfileData, UIImagePickerControllerDelegate & UINavigationControllerDelegate, CropViewControllerDelegate {
    
    
    //resetting view for returning from another VC, most likely when settings/profile images are changed
    func notifyDelegate() {
        userProfileID = defaultValues.string(forKey: "device_userid")!
        loadProfileTop(userProfileID)
        self.view .setNeedsDisplay()
    }
    //resetting view after post submit
    func postSubmitReset() {
        let storyboard = UIStoryboard(name: "AppMainContent", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ProfileViewController")
        var viewcontrollers = self.navigationController!.viewControllers
        viewcontrollers.removeLast()
        viewcontrollers.append(vc)
        self.navigationController?.setViewControllers(viewcontrollers, animated: true)
        userProfileID = defaultValues.string(forKey: "device_userid")!
        loadProfileTop(userProfileID)
        newPostImage = nil
    }
    
    var profileRefresh:UIRefreshControl!
    private var profileNews = [ProfileNewsModel]()
    private var profilePublics = [PublicsTopicsModel]()
    private var profileClans = [ClansModel]()
    
    //test here by putting in either user id or username to load profile, or leave blank to load yours
    var userProfileID: String = ""
    var userUsername: String = ""
    
    var username_to:String = ""
    let defaultValues = UserDefaults.standard
    let deviceusername = UserDefaults.standard.string(forKey: "device_username")!
    let deviceuserid = UserDefaults.standard.string(forKey: "device_userid")!
    let indicator: UIActivityIndicatorView = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.large)
    //var platformDropdown:NJDropDown! = nil
    
    //segue variables
    var coverPhotoURL:String = ""
    var profilePhotoURL:String = ""
    var profileWebsiteURL:String = ""
    var twitchURL:String = ""
    var psnURL:String = ""
    var xboxURL:String = ""
    var discordURL:String = ""
    var steamURL:String = ""
    var youtubeURL:String = ""
    var instagramURL:String = ""
    var twitterURL:String = ""
    var discordUserURL:String = ""
    var seeAllSegue:String = ""
    
    //profile post image variable
    var newPostImage:UIImage? = nil
    
    
    //view setup
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
    @IBOutlet weak var profileWebsiteLabel: ActiveLabel!
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
    @IBOutlet weak var platformDropdownTextField: DropDown!
    @IBOutlet weak var noPostsToShowView: UILabel!
    
    @IBAction func profilePicSelectorTap(_ sender: Any) {
        print("Profile pic selector tapped")
        performSegue(withIdentifier: "toUploadImage", sender: nil)
    }
    @IBAction func seeAllButton(_ sender: Any) {
        let seeAllVC = SeeAllViewController(nibName: "SeeAllViewController", bundle: nil)
        seeAllVC.queryID = self.userUsername
        seeAllVC.queryIDextra = self.userProfileID
        seeAllVC.method = seeAllSegue
        navigationController?.pushViewController(seeAllVC, animated: true)
    }
    @IBAction func clansQueryButton(_ sender: Any) {
        postsQueryButtonClicked(clansQueryButton)
    }
    @IBAction func publicsQueryButton(_ sender: Any) {
        postsQueryButtonClicked(publicsPostsQueryButton)
    }
    @IBAction func postQueryButton(_ sender: Any) {
        postsQueryButtonClicked(postsQueryButton)
    }
    
    
    //These two can't be tapped for some reason
    @IBAction func coverPhotoTap(_ sender: Any) {
        print("Cover photo tapped")
        let zoomvc = ZoomImageViewController(nibName: "ZoomImageViewController", bundle: nil)
        zoomvc.image = self.coverPhotoURL
        navigationController?.pushViewController(zoomvc, animated: true)
    }
    @IBAction func profilePicTap(_ sender: Any) {
        print("Profile pic tapped")
        let zoomvc = ZoomImageViewController(nibName: "ZoomImageViewController", bundle: nil)
        zoomvc.image = self.profilePhotoURL
        navigationController?.pushViewController(zoomvc, animated: true)
    }
    
    
    @IBAction func ReviewsTap(_ sender: Any) {
        print("Reviews tapped")
        //Go to reviews VC
        performSegue(withIdentifier: "toReviews", sender: nil)
    }
    @IBAction func followingTap(_ sender: Any) {
        print("Followings tapped")
        //Go to user list VC
        performSegue(withIdentifier: "toUserListFollowing", sender: nil)
    }
    @IBAction func connectionsTap(_ sender: Any) {
        print("Connections tapped")
        //Go to user list VC
        performSegue(withIdentifier: "toUserListConnections", sender: nil)
    }
    @IBAction func followsTap(_ sender: Any) {
        performSegue(withIdentifier: "toUserListFollowers", sender: nil)
    }
    @IBAction func nintendoTap(_ sender: Any) {
        print("Nintendo tapped")
    }
    @IBAction func twitterTap(_ sender: Any) {
        showWebView(for: "https://twitter.com/"+twitterURL)
    }
    @IBAction func discordUserTap(_ sender: Any) {
        print("Discord User tapped")
        //TODO: Add popup with copy-able text
    }
    @IBAction func twitchTap(_ sender: Any) {
        showWebView(for: "https://www.twitch.tv/"+twitchURL)
    }
    @IBAction func instaTapped(_ sender: Any) {
        showWebView(for: "https://instagram.com/"+instagramURL)
    }
    @IBAction func youtubeTap(_ sender: Any) {
        showWebView(for: "https://youtube.com/channel/"+youtubeURL)
    }
    @IBAction func steamTap(_ sender: Any) {
        showWebView(for: "https://steamcommunity.com/id/"+steamURL)
    }
    @IBAction func discordTap(_ sender: Any) {
        showWebView(for: "https://www.discord.gg/"+discordURL)
    }
    @IBAction func xboxTap(_ sender: Any) {
        showWebView(for: "https://account.xbox.com/en-us/profile?gamertag="+xboxURL)
    }
    @IBAction func psnTap(_ sender: Any) {
        showWebView(for: "https://psnprofiles.com/"+psnURL)
    }
    @IBAction func profileMorePressed(_ sender: Any) {
        print("More button pressed")
        
    }
    @IBAction func sendMessagePressed(_ sender: Any) {
        print("Send message pressed")
    }
    @IBAction func requestSentPressed(_ sender: Any) {
        print("Connection request has been sent")
    }
    @IBAction func requestedConnectionPressed(_ sender: Any) {
        print("Accept request?")
    }
    @IBAction func connectedPressed(_ sender: Any) {
        print("Cannot disconnect, loser")
    }
    @IBAction func addConnectionPressed(_ sender: Any) {
        print("Add connection")
    }
    @IBAction func editProfilePressed(_ sender: Any) {
        print("Edit profile")
    }
    @IBAction func followedUserPressed(_ sender: Any) {
        print("Unfollow user")
    }
    @IBAction func followUserPressed(_ sender: Any) {
        print("Follow user")
    }
    
    //new post image selecting
    @IBAction func postImageSelectorPressed(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
        
        self.present(imagePicker, animated: true, completion: nil)
    }
    @IBOutlet weak var newPostImageButton: UIButton!
    //MARK: ImagePicker Controller Delegate methods
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
        
        newPostImage = (info[.originalImage] as? UIImage)!
        picker.dismiss(animated: true, completion: nil)
        presentCropViewController()
    }
    
    func presentCropViewController() {
        let image: UIImage = newPostImage!
        
        var cropViewController:CropViewController? = nil
        cropViewController = CropViewController(image: image)
        cropViewController!.delegate = self
        present(cropViewController!, animated: true, completion: nil)
    }
    
    public func cropViewController(_ cropViewController: CropViewController, didCropToImage croppedImage: UIImage, withRect cropRect: CGRect, angle: Int) {
        
        newPostImageButton.setImage(croppedImage, for: .normal)
        newPostImage = croppedImage
        cropViewController.dismiss(animated: false, completion: nil)
    }
    
    
    
    @IBAction func postPlatformPressed(_ sender: Any) {
        self.platformDropdownTextField.touchAction()
    }
    @IBAction func postSubmit(_ sender: Any) {
        print("Submit button pressed")
        let spinnerText = self.platformDropdownTextField.text!
        let form = "user"
        if(!(statusUpdate.text == "") && !(statusUpdate.text == "Let your followers know what you're up to...") && !(platformDropdownTextField.text == "")){
            self.profileScrollView.isHidden = true
            self.indicator.startAnimating()
            self.submitStatus(self.statusUpdate.text!,self.deviceusername,self.userUsername,spinnerText,form)
            self.view.endEditing(true)
        }
    }
    
    func submitStatus(_ body:String, _ added_by:String, _ user_to:String, _ type:String, _ form:String){
        //print("body:"+body+" added_by:"+added_by+" user_to:"+user_to+" type:"+type+" form:"+form)
        
        
        let parameters: Parameters=["body":body,
            "added_by":added_by,
            "user_to":user_to,
            "user_id":deviceuserid,
            "type":type,
            "form":form]
        AF.request(URLConstants.ROOT_URL+"new_post.php", method: .post, parameters: parameters).responseJSON{
            response in
            //printing response
            //print(response)

            switch response.result {
            case .success(let value):
                let jsonData = JSON(value)
                if (!((jsonData["error"].string != nil))) {
                    if (jsonData["error"]==false){
                        if(self.newPostImage != nil){
                            let post_id = jsonData["postid"].int
                            self.postImageUpload(self.newPostImage!, String(post_id!))
                        }
                        self.postSubmitReset()
                    }else{
                        self.view.showToast(toastMessage: "Network error! (E.2)", duration:2)
                        self.profileScrollView.isHidden = false
                        self.indicator.stopAnimating()
                    }
                }else{
                    self.view.showToast(toastMessage: "Network Error! (E.1)", duration:2)
                    self.profileScrollView.isHidden = false
                    self.indicator.stopAnimating()
                }
            case let .failure(error):
                print(error)
            }
        }
    }
    
    func postImageUpload(_ imageToUpload: UIImage, _ post_id:String) {
        var request = URLRequest(url: NSURL(string: URLConstants.ROOT_URL+"new_post_image_upload.php")! as URL)
        request.httpMethod = "POST";
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let imageData:NSData = imageToUpload.jpegData(compressionQuality: 0.75)! as NSData
        // convert the NSData to base64 encoding
        let encodedImage:String = imageData.base64EncodedString(options: Data.Base64EncodingOptions.lineLength64Characters)
        
        let jsonObject = ["name":Int64(Date().timeIntervalSince1970 * 1000),
                          "post_id":post_id,
                          "added_by":deviceusername,
                          "image":encodedImage] as [String : Any]
        
        request.httpBody = try! JSONSerialization.data(withJSONObject: jsonObject)
        // probably shouldn't uncomment this, could crash mac -> print(jsonObject)
        
        AF.request(request)
            .responseJSON { response in
                print(response)
                
                switch response.result {
                case .success(let value):
                    let jsonData = JSON(value)
                    if (jsonData["error"].string=="true"){
                        let message = jsonData["message"].string
                        self.view.showToast(toastMessage: message!, duration:2)
                    }
                case let .failure(error):
                    print(error)
                    self.view.showToast(toastMessage: "Network error! Please try again.", duration:2)
                }
        }
    }
    
    
    @IBAction func showAddPostView(_ sender: Any) {
        if self.addPostView.isHidden {
            self.addPostView.isHidden = false
            statusUpdate.delegate = self
            statusUpdate.text = "Let your followers know what you're up to..."
            statusUpdate.textColor = UIColor.lightGray
        }else{
            self.addPostView.isHidden = true
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    
    //Logging out device user
    @IBAction func buttonLogout(_ sender: UIButton) {
        //removing values from default
        defaultValues.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
        defaultValues.synchronize()
        performSegue(withIdentifier: "ToLogin", sender: nil)
    }
    
    
    //Load profile from user id
    func loadProfileTop(_ userProfileIDS:String){
        indicator.startAnimating()
        AF.request(URLConstants.ROOT_URL+"profiletop_api.php?userid="+deviceuserid+"&userid2="+userProfileIDS+"&deviceusername="+deviceusername, method: .get).responseJSON{
            response in
            //printing response
            //print(response)
            
            switch response.result {
            case .success(let value):
                let jsonObject = JSON(value)
                let jsonData = jsonObject[0]
                if (jsonData["id"].rawString() == userProfileIDS) {
                    //let thisProfileID = jsonData["id"].int
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
                    //let connections = jsonData["connections"].string
                    
                    
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
                        
                        let fGuesture = UITapGestureRecognizer(target: self, action: #selector(self.toImageUploadVC(_:)))
                        self.ivCoverPhotoPicker.addGestureRecognizer(fGuesture)
                        
                    }else{
                        self.editProfileStack.isHidden = true
                        self.ivCoverPhotoPicker.isHidden = true
                        self.ivProfilePhotoPicker.isHidden = true
                    }
                    
                    var isUserBlocked = "no"
                    let blocked_users:String = self.defaultValues.string(forKey: "device_blockedarray")!
                    let blocked_array = blocked_users.components(separatedBy:",")
                    if blocked_array.contains(username!){isUserBlocked = "yes"}
                    if(blocked=="yes" || isUserBlocked == "yes"){
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
                        self.discordUserURL = discord_user!
                    }else{
                        self.userDiscordProfileDetails.isHidden = true
                    }
                    if (twitter != "") {
                        self.userTwitter.text = twitter
                        self.twitterURL = twitter!
                    }else{
                        self.userTwitterDetails.isHidden = true
                    }
                    if (website != "") {
                        self.profileWebsiteLabel.text = website!
                        self.profileWebsiteURL = website!
                        
                        let websiteGesture = UITapGestureRecognizer(target: self, action: #selector(self.websiteTap(_:)))
                        self.profileWebsiteLabel.addGestureRecognizer(websiteGesture)
                    }else{
                        self.profileWebsiteContainer.isHidden = true
                    }
                    if (nintendo != "") {
                        self.userSwitch.text = nintendo
                    }else{
                        self.userSwitchDetails.isHidden = true
                    }
                    
                    //TODO: Add message button to message->user
                    
                    self.followersCount.text = followers!
                    self.followingCount.text = followings!
                    self.connectionsCount.text = num_friends!
                    
                    if (twitch != "") {
                        self.userTwitch.text = twitch
                        self.twitchURL = twitch!
                    }else{
                        self.userTwitchDetails.isHidden = true
                    }
                    if psn != "" {
                        self.userPSN.text = psn
                        self.psnURL = psn!
                    }else{
                        self.userPSNDetails.isHidden  = true
                    }
                    if xbox != "" {
                        self.userXbox.text = xbox
                        self.xboxURL = xbox!
                    }else{
                        self.userXboxDetails.isHidden = true
                    }
                    if discord != "" {
                        self.userDiscord.text = "Discord Server"
                        self.discordURL = discord!
                    }else{
                        self.userDiscordDetails.isHidden = true
                    }
                    if steam != "" {
                        self.userSteam.text = steam
                        self.steamURL = steam!
                    }else{
                        self.userSteamDetails.isHidden = true
                    }
                    if youtube != "" {
                        self.userYoutube.text = "YouTube"
                        self.youtubeURL = youtube!
                    }else{
                        self.userYoutubeDetails.isHidden = true
                    }
                    if instagram != "" {
                        self.userInstagram.text = instagram
                        self.instagramURL = instagram!
                    }else{
                        self.userInstagramDetails.isHidden = true
                    }
                    
                    let averageFloat = Float(average!)
                    self.profileRating.value = CGFloat(averageFloat)
                    self.reviewCount.text = String(count!)
                    
                    
                    if !(self.deviceusername == username) {
                        //not our device's profile
                        self.username_to = username!
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
                        self.username_to = "none"
                        self.defaultValues.set(profile_pic, forKey: "device_profilepic")
                    }
                    
                    /*let fGuesture = UITapGestureRecognizer(target: self, action: #selector(ProfileViewController.showF(_:)))
                     self.ivCoverPhotoPicker.addGestureRecognizer(fGuesture)*/
                    
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
                    
                    let filter = AspectScaledToFillSizeWithRoundedCornersFilter(
                        size: self.profileCoverPic.frame.size,
                        radius:0
                    )
                    self.profileCoverPic.af.setImage(
                        withURL: URL(string:URLConstants.BASE_URL+cover_pic!)!,
                        filter: filter,
                        imageTransition: .crossDissolve(1.25)
                    )
                    self.profilePic.af.setImage(
                        withURL: URL(string:URLConstants.BASE_URL+profile_pic!)!,
                        imageTransition: .crossDissolve(1)
                    )
                    self.coverPhotoURL = cover_pic!
                    self.profilePhotoURL = profile_pic!
                    
                    self.indicator.stopAnimating()
                    self.profileRefresh.endRefreshing()
                    self.profileScrollView.isHidden = false
                    
                }else{
                    self.indicator.stopAnimating()
                    self.profileRefresh.endRefreshing()
                    self.noProfileView.isHidden = false
                }
            case let .failure(error):
                print(error)
                self.indicator.stopAnimating()
                self.profileRefresh.endRefreshing()
                self.noProfileView.isHidden = false
                self.view.showToast(toastMessage: "Network Error!", duration:2)
            }
        }
    }
    
    
    func loadProfileNews(){
        let nib = UINib(nibName: "ProfilePostsTVC2", bundle: nil)
        self.profilePostsTableView.register(nib, forCellReuseIdentifier: "ProfilePostsTVC2")
        
        self.indicator.startAnimating()
        self.profileNews.removeAll()
        AF.request(URLConstants.ROOT_URL+"profilenews_api.php?userid="+deviceuserid+"&userprofileid="+userProfileID+"&thisusername="+deviceusername, method: .get).responseJSON{
            response in
            //printing response
            //print(response)
            
            switch response.result {
            case .success(let value):
                let jsonObject = JSON(value)
                if jsonObject.count == 0 {
                    self.profilePostsTableView.isHidden = true
                    self.noPostsToShowView.isHidden = false
                    self.noPostsToShowView.text = "No posts to show!"
                }else{
                    self.noPostsToShowView.isHidden = true
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
                    self.indicator.stopAnimating()
                }
            case let .failure(error):
                print(error)
                self.indicator.stopAnimating()
                self.view.showToast(toastMessage: "Network Error!", duration:2)
                self.noProfileView.isHidden = false
            }
        }
    }
    
    func loadJoinedClans(){
        let nib = UINib(nibName: "ClansTVC", bundle: nil)
        self.profilePostsTableView.register(nib, forCellReuseIdentifier: "ClansTVC")
        
        self.indicator.startAnimating()
        self.profileClans.removeAll()
        AF.request(URLConstants.ROOT_URL+"user_joined_clans.php?userid="+userProfileID+"&username="+userUsername, method: .get).responseJSON{
            response in
            //printing response
            print(response)

            switch response.result {
            case .success(let value):
                let jsonObject = JSON(value)
                let jsonArray = jsonObject["clans"]
                if jsonArray.count == 0 {
                    self.profilePostsTableView.isHidden = true
                    self.noPostsToShowView.isHidden = false
                    self.noPostsToShowView.text = "No clans to show!"
                }else{
                    self.noPostsToShowView.isHidden = true
                    for i in 0..<jsonArray.count{
                        let jsonData = jsonArray[i]
                        self.profileClans.append(ClansModel(
                            position: jsonData["position"].rawString(),
                            tag: jsonData["tag"].rawString(),
                            name: jsonData["name"].rawString(),
                            num_members: jsonData["num_members"].rawString(),
                            insignia: jsonData["insignia"].rawString(),
                            games: jsonData["games"].rawString(),
                            id: jsonData["id"].int,
                            avg: jsonData["avg"].rawString()))
                    }
                    //displaying data in tableview
                    self.profilePostsTableView.reloadData()
                }
                self.indicator.stopAnimating()
            case let .failure(error):
                print(error)
                self.indicator.stopAnimating()
                self.view.showToast(toastMessage: "Network Error!", duration:2)
            }
        }
    }
    
    func loadProfilePublics(){
        let nib = UINib(nibName: "PublicsTopicsTVC", bundle: nil)
        self.profilePostsTableView.register(nib, forCellReuseIdentifier: "PublicsTopicsTVC")
        
        self.indicator.startAnimating()
        self.profilePublics.removeAll()
        AF.request(URLConstants.ROOT_URL+"profilepublicsnews_api.php?username="+userUsername, method: .get).responseJSON{
            response in
            //printing response
            //print(response)

            switch response.result {
            case .success(let value):
                let jsonObject = JSON(value)
                if jsonObject.count == 0 {
                    self.profilePostsTableView.isHidden = true
                    self.noPostsToShowView.isHidden = false
                    self.noPostsToShowView.text = "No Publics posts to show!"
                }else{
                    self.noPostsToShowView.isHidden = true
                    for i in 0..<jsonObject.count{
                        let jsonData = jsonObject[i]
                        self.profilePublics.append(PublicsTopicsModel(
                            id: jsonData["id"].int,
                            numposts: jsonData["numposts"].rawString(),
                            subject: jsonData["subject"].rawString(),
                            date: jsonData["date"].rawString(),
                            cat: jsonData["cat"].rawString(),
                            topic_by: jsonData["topic_by"].rawString(),
                            type: jsonData["type"].string,
                            user_id: jsonData["user_id"].int,
                            profile_pic: jsonData["profile_pic"].rawString(),
                            nickname: jsonData["nickname"].rawString(),
                            username: jsonData["username"].rawString(),
                            event_date: jsonData["event_date"].rawString(),
                            zone: jsonData["zone"].rawString(),
                            context: jsonData["context"].rawString(),
                            num_players: jsonData["num_players"].int,
                            num_added: jsonData["num_added"].int,
                            gamename: jsonData["gamename"].rawString()))
                    }
                    //displaying data in tableview
                    self.profilePostsTableView.reloadData()
                }
                self.indicator.stopAnimating()
            case let .failure(error):
                print(error)
                self.indicator.stopAnimating()
                self.view.showToast(toastMessage: "Network Error!", duration:2)
            }
        }
    }
    
    
    //Buttons to load different post cells in tableview
    func postsQueryButtonClicked(_ buttonPressed:UIButton){
        if(buttonPressed == self.postsQueryButton){
            self.seeAllSegue = "posts"
            self.postsQueryButton.backgroundColor = UIColor(named: "green")
            self.clansQueryButton.backgroundColor = UIColor(named: "grey_80")
            self.publicsPostsQueryButton.backgroundColor = UIColor(named: "grey_80")
            loadProfileNews()
            self.profileItemsLabel.text = "Profile Posts"
            self.seeAllButton.isHidden = false
        }else if (buttonPressed == self.clansQueryButton){
            self.seeAllSegue = "clans"
            self.postsQueryButton.backgroundColor = UIColor(named: "grey_80")
            self.clansQueryButton.backgroundColor = UIColor(named: "green")
            self.publicsPostsQueryButton.backgroundColor = UIColor(named: "grey_80")
            loadJoinedClans()
            self.profileItemsLabel.text = "Clans Joined"
            self.seeAllButton.isHidden = true
        }else if (buttonPressed == self.publicsPostsQueryButton){
            self.seeAllSegue = "publics"
            self.postsQueryButton.backgroundColor = UIColor(named: "grey_80")
            self.clansQueryButton.backgroundColor = UIColor(named: "grey_80")
            self.publicsPostsQueryButton.backgroundColor = UIColor(named: "green")
            loadProfilePublics()
            self.profileItemsLabel.text = "Publics posts"
            self.seeAllButton.isHidden = false
        }
    }
    
    
    //Getting username's user id and moving it to load profile
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
    
    
    //Refreshing profile when pulled down from top, and redrawing views with ".setNeedsDisplay()" <--- essential
    @objc func refresh(){
        //self.view.showToast(toastMessage: "Refreshing...", duration:2)
        indicator.startAnimating()
        if !(userProfileID==""){
            loadProfileTop(userProfileID)
        }else if !(userUsername==""){
            getUserID(userUsername)
        }else{
            userProfileID = defaultValues.string(forKey: "device_userid")!
            loadProfileTop(userProfileID)
        }
        self.view .setNeedsDisplay()
    }
    
    //may not be necessary, but adding refresh control to UIScrollView when pulled down from top, currently pretty basic setup
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        profileRefresh = UIRefreshControl()
        if !isModal{
            profileRefresh.addTarget(self, action: #selector(refresh), for:
            .valueChanged)
            profileScrollView.refreshControl = profileRefresh
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        profileScrollView.isHidden = true
        
        //start loading indicator
        indicator.frame = CGRect(x: 0, y: 0, width: 60, height: 60)
        indicator.center = view.center
        self.view.addSubview(indicator)
        self.view.bringSubviewToFront(indicator)
        self.indicator.isOpaque = false
        self.indicator.layer.cornerRadius = 05
        self.indicator.backgroundColor = (UIColor .black .withAlphaComponent(0.6))
        self.indicator.startAnimating()

        //setting up post table view
        profilePostsTableView.dataSource = self
        profilePostsTableView.delegate = self
        
        //getting user data from defaults
        if defaultValues.string(forKey: "device_userid") == nil{
            //user not signed in
            defaultValues.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
            defaultValues.synchronize()
            performSegue(withIdentifier: "ToLogin", sender: nil)
        }
        
        //figuring out what user to load, if user id is given, load that profile, else get user id of username if given, then pass to load that profile from the received id, else load device user's profile
        if !(userProfileID==""){
            loadProfileTop(userProfileID)
        }else if !(userUsername==""){
            getUserID(userUsername)
        }else{
            userProfileID = defaultValues.string(forKey: "device_userid")!
            loadProfileTop(userProfileID)
        }
        
        //placing border around user's profile pic
        profilePic.layer.borderColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1.0).cgColor
        profilePic.layer.masksToBounds = true
        profilePic.contentMode = .scaleToFill
        profilePic.layer.borderWidth = 7
        
        //new post's platform option button
        platformDropdownTextField.optionArray = ["General","PlayStation","Xbox","Steam","PC","Mobile","Switch"]
        ///platformDropdownTextField.optionImageArray = [UIImage(named: "ic_quote")!,UIImage(named: "icons8_playstation_50")!,UIImage(named: "icons8_xbox_50")!,UIImage(named: "icons8_steam_48")!,UIImage(named: "icons8_workstation_48")!,UIImage(named: "icons8_mobile_48")!,UIImage(named: "icons8_nintendo_switch_48")]
        platformDropdownTextField.didSelect { (selectedPlatform, index, id) in
            self.platformDropdownTextField.text = selectedPlatform
        }
        platformDropdownTextField.tintColor = UIColor.white
        
    }
    
    
    //Device user to follow profile user
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
    
    
    //View to tell us whether or not user has been requested/requested the device user
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
    
    //Request to add connection
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
    
    //Accept user's connection request
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
    
    
    //alternative tap gesture function for segue to cover image upload
    @objc func toImageUploadVC(_ sender: UITapGestureRecognizer){
        performSegue(withIdentifier: "toUploadCover", sender: nil)
    }
    
    @objc func websiteTap(_ sender: UITapGestureRecognizer){
        showWebView(for: self.profileWebsiteURL)
    }
    
    //New post view handling of textview
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
    
    
    
    
    //Profile posts table view
    
    
    ///the method returning size of the list
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        var rowCount:Int? = 0
        if seeAllSegue == "posts"{
            rowCount = profileNews.count
        }else if seeAllSegue == "publics"{
            rowCount = profilePublics.count
        }else if seeAllSegue == "clans"{
            rowCount = profileClans.count
        }
        
        return rowCount!
    }
    
    ///handling cell view for table
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if seeAllSegue == "posts"{
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProfilePostsTVC2") as! ProfilePostsTVC2
            
            //getting the hero for the specified position
            let profilesNewsI: ProfileNewsModel
            profilesNewsI = profileNews[indexPath.row]
            
            //displaying values
            cell.usernameLabel.text = "@"+profilesNewsI.username!
            cell.nicknameLabel.text = profilesNewsI.nickname
            cell.postBody.text = profilesNewsI.body
            cell.postBody.handleURLTap { (URL) in
                UIApplication.shared.open(URL as URL, options: [:], completionHandler: nil)
            }
            
            if profilesNewsI.user_to != "none"{
                cell.toUsernameLabel.text = "to @"+profilesNewsI.user_to!
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
            if profilesNewsI.edited == "yes"{
                cell.editedLabel.isHidden = false
            }else{
                cell.editedLabel.isHidden = true
            }
            
            cell.numLikes.text = profilesNewsI.likes
            cell.numComments.text = profilesNewsI.commentcount
            cell.dateView.text = profilesNewsI.date_added
            
            if profilesNewsI.online == "yes"{
                cell.onlineView.isHidden = false
                cell.onlineView.layer.borderColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1.0).cgColor
                cell.onlineView.layer.masksToBounds = true
                cell.onlineView.contentMode = .scaleToFill
                cell.onlineView.layer.borderWidth = 1
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
        }else if seeAllSegue == "publics"{
            let cell = tableView.dequeueReusableCell(withIdentifier: "PublicsTopicsTVC") as! PublicsTopicsTVC
            
            let publicsTopicI: PublicsTopicsModel
            publicsTopicI = profilePublics[indexPath.row]
            
            cell.postTitle.text = publicsTopicI.subject
            cell.dateView.text = publicsTopicI.date
            cell.numComments.text = publicsTopicI.numposts
            cell.profileName.text = publicsTopicI.nickname
            cell.gamename.text = publicsTopicI.gamename
            cell.eventDate.text = publicsTopicI.event_date
            cell.numPlayersAdded.text = String(publicsTopicI.num_added!)
            cell.numPlayersNeeded.text = String(publicsTopicI.num_players!)
            cell.context.text = publicsTopicI.context
            
            switch publicsTopicI.type{
            case "Xbox":
                cell.platform.image = UIImage(named: "icons8_xbox_50")
                break
            case "PlayStation":
                cell.platform.image = UIImage(named: "icons8_playstation_50")
                break
            case "Steam":
                cell.platform.image = UIImage(named: "icons8_steam_48")
                break
            case "PC":
                cell.platform.image = UIImage(named: "icons8_workstation_48")
                break
            case "Mobile":
                cell.platform.image = UIImage(named: "icons8_mobile_48")
                break
            case "Switch":
                cell.platform.image = UIImage(named: "icons8_nintendo_switch_48")
                break
            case "Cross-Platform":
                cell.platform.image = UIImage(named: "icons8_collect_40")
                break
            case "General":
                cell.platform.isHidden = true
                break
            default:
                cell.platform.image = UIImage(named: "icons8_question_mark_64")
            }
            
            let profilePicIndex = publicsTopicI.profile_pic?.firstIndex(of: ".")!
            let profile_pic = (publicsTopicI.profile_pic?.prefix(upTo: profilePicIndex!))!+"_r.JPG"
            cell.profileImage.af.setImage(
                withURL: URL(string:URLConstants.BASE_URL+profile_pic)!,
                imageTransition: .crossDissolve(0.2)
            )
            
            if (publicsTopicI.event_date == "ended"){
                cell.eventDate.textColor = UIColor(named: "pin")
            }else if (publicsTopicI.event_date == "now"){
                cell.eventDate.textColor = UIColor(named: "green")
            }
            
            return cell
        }else if seeAllSegue == "clans"{
            let cell = tableView.dequeueReusableCell(withIdentifier: "ClansTVC") as! ClansTVC
            
            let clansI: ClansModel
            clansI = profileClans[indexPath.row]
            
            cell.clanTag.text = clansI.tag?.uppercased()
            cell.clanName.text = clansI.name
            cell.numMembers.text = clansI.num_members
            cell.clanPosition.text = clansI.position

            let averageFloat = Float(clansI.avg!)
            if(averageFloat != nil && !(averageFloat == 0.0)){
                cell.clanRating.isHidden = false
                cell.clanRating.value = CGFloat(averageFloat!)
            }else{
                cell.clanRating.color = UIColor(named: "colorPrimary")!
            }
            
            var insignia = clansI.insignia!.replacingOccurrences(of: " ", with: "%20")
            insignia = URLConstants.BASE_URL+insignia
            if insignia != URLConstants.BASE_URL{
                cell.clanImageView.af.setImage(
                    withURL: URL(string:insignia)!,
                    imageTransition: .crossDissolve(0.2)
                )
            }
            return cell
        }
        
        return UITableViewCell()
    }
    
    ///handling cell view taps
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if seeAllSegue == "posts"{
            let alertController = UIAlertController(title: "Hint", message: "You have profile post row \(indexPath.row).", preferredStyle: .alert)
            
            let alertAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
            
            alertController.addAction(alertAction)
            
            present(alertController, animated: true, completion: nil)
        }else if seeAllSegue == "publics"{
            let alertController = UIAlertController(title: "Hint", message: "You have publics topic row \(indexPath.row).", preferredStyle: .alert)
            
            let alertAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
            
            alertController.addAction(alertAction)
            
            present(alertController, animated: true, completion: nil)
        }else if seeAllSegue == "clans"{
            let alertController = UIAlertController(title: "Hint", message: "You have clan row \(indexPath.row).", preferredStyle: .alert)
            
            let alertAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
            
            alertController.addAction(alertAction)
            
            present(alertController, animated: true, completion: nil)
        }
        
    }
    
    ///number of sections in table view
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    
    //Segue handling
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toUploadImage" {
            if let destination = segue.destination as? UploadPhotoController {
                destination.imageUploadTo = "profile_pic"
                destination.profileDelegate = self
            }
        }else if segue.identifier == "toUploadCover" {
            if let destination = segue.destination as? UploadPhotoController {
                destination.imageUploadTo = "cover"
                destination.profileDelegate = self
            }
        }else if segue.identifier == "ToLogin" {
            _ = segue.destination as? LoginViewController
        }else if segue.identifier == "toUserListFollowing" {
            if let destination = segue.destination as? UserListViewController {
                destination.query = "following"
                destination.queryID = self.userUsername
            }
        }else if segue.identifier == "toUserListConnections" {
            if let destination = segue.destination as? UserListViewController {
                destination.query = "connections"
                destination.queryID = self.userUsername
            }
        }else if segue.identifier == "toUserListFollowers" {
            if let destination = segue.destination as? UserListViewController {
                destination.query = "followers"
                destination.queryID = self.userUsername
            }
        }else if segue.identifier == "toReviews" {
            if let destination = segue.destination as? ReviewsViewController {
                destination.query = "profile"
                destination.queryID = self.userUsername
                destination.queryName = self.userUsername
            }
        }
        
        
    }
    
    func showWebView(for url: String) {
        //Thanks billhole
        guard let url = URL(string: url) else {
            self.view.showToast(toastMessage: "Error - Invalid URL!", duration:2)
            return
        }
        
        let webView = SFSafariViewController(url: url)
        present(webView, animated: true)
    }
    
    
    
}
