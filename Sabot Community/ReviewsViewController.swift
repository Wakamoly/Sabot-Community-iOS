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
import AARatingBar

class ReviewsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, NotifyReloadReviews {
    
    //resetting view for returning from another VC
    func notifyDelegate() {
        loadReviewsTop()
        self.view .setNeedsDisplay()
    }
    
    //segue to this VC variables
    var query:String = ""
    var queryName:String = ""
    var queryID:String = ""
    
    //segue to profile variables
    var toProfileID:String = ""
    
    //segue to review variables
    var canReviewThis:String = ""
    var subnameToReview:String = ""
    var tagnameToReview:String = ""
    var verifiedToReview:String = ""
    var imageToReview:String = ""
    var onlineToReview:String = ""
    
    //table view cell model
    private var reviews = [ReviewsModel]()
    
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
    @IBOutlet weak var cannotLoadView: UIView!
    @IBAction func toReviewButton(_ sender: Any) {
        if canReviewThis == "yes" {
            performSegue(withIdentifier: "toReview", sender: nil)
        }else{
            if query == "profile" {
                self.view.showToast(toastMessage: "You must connect with this user before creating a review!", duration:2)
            }else if query == "public"{
                self.view.showToast(toastMessage: "You must follow this game before creating a review!", duration:2)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        toReviewThisButton.layer.cornerRadius = 05
        
        reviewsScrollView.isHidden = true
        
        //setting up post table view
        reviewsTableView.dataSource = self
        reviewsTableView.delegate = self
        
        //start loading indicator
        indicator.frame = CGRect(x: 0, y: 0, width: 60, height: 60)
        indicator.center = view.center
        self.view.addSubview(indicator)
        self.view.bringSubviewToFront(indicator)
        self.indicator.isOpaque = false
        self.indicator.layer.cornerRadius = 05
        self.indicator.backgroundColor = (UIColor .black .withAlphaComponent(0.6))
        
        self.navigationItem.title = "@"+queryName
        
        //start UI query loading
        loadReviewsTop()
    }
    
    func loadReviewsTop(){
        indicator.startAnimating()

        AF.request(URLConstants.ROOT_URL+"reviewsTopGet.php?userid="+deviceuserid+"&queryID="+queryID+"&query="+query+"&username="+deviceusername, method: .get).responseJSON{
            response in
            //print(response)

            switch response.result {
            case .success(let value):
                let jsonObject = JSON(value)
                let reviewInfo = jsonObject["reviewinfo"][0]
                let count = reviewInfo["count"].int
                let average = reviewInfo["average"].rawString()
                let fivestarratings = reviewInfo["fivestarratings"].int
                let fourstarratings = reviewInfo["fourstarratings"].int
                let threestarratings = reviewInfo["threestarratings"].int
                let twostarratings = reviewInfo["twostarratings"].int
                let onestarratings = reviewInfo["onestarratings"].int
                
                if count! > 0 {
                    let numfive = Float(fivestarratings!/count!)
                    self.fiveStarBar.progress = numfive
                    
                    let numfour = Float(fourstarratings!/count!)
                    self.fourStarBar.progress = numfour
                    
                    let numthree = Float(threestarratings!/count!)
                    self.threeStarBar.progress = numthree
                    
                    let numtwo = Float(twostarratings!/count!)
                    self.twoStarBar.progress = numtwo
                    
                    let numone = Float(onestarratings!/count!)
                    self.oneStarBar.progress = numone
                }
                self.reviewsAverage.text = average
                self.numReviews.text = String(count!)

                let averageFloat = Float(average!)
                self.starReviewBar.value = CGFloat(averageFloat!)
                
                
                let infoarray = jsonObject["infoarray"][0]
                let thisID = infoarray["id"].int
                let image = infoarray["image"].rawString()
                let verified = infoarray["verified"].string
                let online = infoarray["online"].string
                let subname = infoarray["subname"].rawString()
                let tagname = infoarray["tagname"].rawString()
                let canReview = infoarray["canReview"].string
                
                if canReview == "yes"{
                    self.toReviewThisButton.backgroundColor = UIColor(named: "green")
                    self.toReviewThisButton.titleLabel!.text = "CREATE A REVIEW"
                    self.canReviewThis = canReview!
//                    let toReviewGesture = UITapGestureRecognizer(target: self, action: #selector(ReviewsViewController.toReview(_:)))
//                    self.toReviewThisButton.addGestureRecognizer(toReviewGesture)
                }else if self.queryID == self.deviceusername && self.query == "profile"{
                    self.toReviewThisButton.isHidden = true
                }
                
                self.profileImageReviewed.af.setImage(
                    withURL: URL(string:URLConstants.BASE_URL+image!)!,
                    imageTransition: .crossDissolve(1)
                )
                if verified == "yes"{
                    self.verifiedView.isHidden = false
                }else{
                    self.verifiedView.isHidden = true
                }
                if online == "yes"{
                    self.onlineView.isHidden = false
                }else{
                    self.onlineView.isHidden = true
                }
                self.nicknameView.text = subname
                self.usernameView.text = "@"+tagname!
                
                self.reviewsScrollView.isHidden = false
                self.loadReviews()
                
                
                self.subnameToReview = subname!
                self.tagnameToReview = tagname!
                self.verifiedToReview = verified!
                self.imageToReview = image!
                self.onlineToReview = online!
                
            case let .failure(error):
                print(error)
                self.indicator.stopAnimating()
                self.cannotLoadView.isHidden = false
                self.view.showToast(toastMessage: "Network Error!", duration:2)
            }
        }
    }
    
    func loadReviews(){
        AF.request(URLConstants.ROOT_URL+"reviewsGet.php?userid="+deviceuserid+"&queryID="+queryID+"&query="+query+"&username="+deviceusername, method: .get).responseJSON{
            response in
            //printing response
            print(response)

            switch response.result {
            case .success(let value):
                let jsonObject = JSON(value)
                if jsonObject.count == 0 {
                    self.reviewsTableView.isHidden = true
                    self.noReviewsLabel.isHidden = false
                }else{
                    self.noReviewsLabel.isHidden = true
                    for i in 0..<jsonObject.count{
                        let jsonData = jsonObject[i]
                        self.reviews.append(ReviewsModel(
                            ratingnumber: jsonData["ratingnumber"].int,
                            title: jsonData["title"].string,
                            comments: jsonData["comments"].rawString(),
                            reply: jsonData["reply"].rawString(),
                            time: jsonData["time"].rawString(),
                            profile_pic: jsonData["profile_pic"].rawString(),
                            nickname: jsonData["nickname"].rawString(),
                            userid: jsonData["userid"].int,
                            verified: jsonData["verified"].rawString(),
                            online: jsonData["online"].rawString(),
                            rating_id: jsonData["rating_id"].int))
                    }
                    //displaying data in tableview
                    self.reviewsTableView.reloadData()
                }
                
                self.indicator.stopAnimating()
                
            case let .failure(error):
                print(error)
                self.indicator.stopAnimating()
                self.cannotLoadView.isHidden = false
                self.view.showToast(toastMessage: "Network Error!", duration:2)
            }
        }
    }
    
    //alternative tap gesture function for segue
    @objc func toReview(_ sender: UITapGestureRecognizer){
        performSegue(withIdentifier: "toReview", sender: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Reviews table view
    
    
    ///the method returning size of the list
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return reviews.count
    }
    
    ///handling cell view for table
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reviewTableCell") as! ReviewsTVC
        
        let reviewI: ReviewsModel
        reviewI = reviews[indexPath.row]
        
        //displaying values
        cell.profileName.text = reviewI.nickname
        cell.bodyLabel.text = reviewI.comments
        
        cell.time.text = reviewI.time
        
        if reviewI.online == "yes"{
            cell.online.isHidden = false
            cell.online.layer.borderColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1.0).cgColor
            cell.online.layer.masksToBounds = true
            cell.online.contentMode = .scaleToFill
            cell.online.layer.borderWidth = 1
        }else{
            cell.online.isHidden = true
        }
        if reviewI.verified == "yes"{
            cell.verified.isHidden = false
        }else{
            cell.verified.isHidden = true
        }
        
        let profilePicIndex = reviewI.profile_pic?.firstIndex(of: ".")!
        let profile_pic = (reviewI.profile_pic?.prefix(upTo: profilePicIndex!))!+"_r.JPG"
        cell.profileImage.af.setImage(
            withURL: URL(string:URLConstants.BASE_URL+profile_pic)!,
            imageTransition: .crossDissolve(0.2)
        )
        
        let averageFloat = Float(reviewI.ratingnumber!)
        cell.ratingView.value = CGFloat(averageFloat)
        
        return cell
    }
    
    ///handling cell view taps
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let reviewI: ReviewsModel
        reviewI = reviews[indexPath.row]
        self.toProfileID = String(reviewI.userid!)
        performSegue(withIdentifier: "toProfile", sender: nil)
    }
    
    ///number of sections in table view
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    
    //Segue handling
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toReview" {
            if let destination = segue.destination as? RatingActionViewController {
                destination.query = self.query
                destination.queryID = self.queryID
                destination.subname = self.subnameToReview
                destination.tagname = self.tagnameToReview
                destination.verified = self.verifiedToReview
                destination.image = self.imageToReview
                destination.online = self.onlineToReview
            }
        }else if segue.identifier == "toProfile" {
            if let destination = segue.destination as? ProfileViewController {
                destination.userProfileID = self.toProfileID
            }
        }
        
    }
 
}
