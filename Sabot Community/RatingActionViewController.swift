//
//  RatingActionViewController.swift
//  Sabot Community
//
//  Created by Wakamoly on 8/12/20.
//  Copyright © 2020 LucidSoftworksLLC. All rights reserved.
//

import UIKit
import AARatingBar
import EnhancedCircleImageView
import Alamofire
import AlamofireImage
import PopupDialog
import SwiftyJSON

protocol NotifyReloadReviews:class{
    func notifyDelegate()
}

class RatingActionViewController: UIViewController {
    
    
    weak var reviewDelegate: NotifyReloadReviews? = nil
    
    let defaultValues = UserDefaults.standard
    let deviceusername = UserDefaults.standard.string(forKey: "device_username")!
    let deviceuserid = UserDefaults.standard.string(forKey: "device_userid")!
    let indicator: UIActivityIndicatorView = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.large)
    
    
    var queryID:String = ""
    var query:String = ""
    var subname:String = ""
    var tagname:String = ""
    var verified:String = ""
    var image:String = ""
    var online:String = ""
    var currentStarRating:CGFloat = 0.0
    
    @IBOutlet weak var reviewedImage: EnhancedCircleImageView!
    @IBOutlet weak var subnameLabel: UILabel!
    @IBOutlet weak var tagnameLabel: UILabel!
    @IBOutlet weak var starBar: AARatingBar!
    @IBOutlet weak var barLabel: UILabel!
    @IBOutlet weak var titleBox: UITextField!
    @IBOutlet weak var descBox: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var verifiedIV: EnhancedCircleImageView!
    @IBOutlet weak var onlineIV: EnhancedCircleImageView!
    @IBAction func submitButtonAction(_ sender: Any) {
        if (descBox.text!.count > 0 && descBox.text!.count < 500) && (titleBox.text!.count > 0 && titleBox.text!.count < 60) && !(starBar.value == 0.0) {
            
            // Dialog box view
            
            // Prepare the popup assets
            let title = "Submit review?"
            let message = "WARNING: You risk immediate account termination if your submitted review goes against our code of conduct.\nExamples of inappropriate content include (but are not limited to):\n" +
            "•Content that could be considered violent or threatening.\n" +
            "•References to illegal use of alcohol, illegal drugs/illicit substances.\n" +
            "•Content that is sexually suggestive or revealing, or could be considered objectionable.\n" +
            "•Content that may be considered insulting, non-constructive, defamatory to individuals/organizations.\n" +
            "•Staff/users' confidential or private information.\n" +
            "•Any other content that is inconsistent with Sabot Community policies, code of conduct, or mission statement.\n\nSubmit Review?"
            //let image = UIImage(named: "icons8_question_mark_64")

            // Create the dialog
            let popup = PopupDialog(title: title, message: message)

            // Create buttons
            let buttonNo = CancelButton(title: "Cancel") {
                print("Canceled")
                self.submitButton.isEnabled = true
            }

            // This button will not the dismiss the dialog
//            let buttonTwo = DefaultButton(title: "ADMIRE CAR", dismissOnTap: false) {
//                print("What a beauty!")
//            }

            let buttonYes = DefaultButton(title: "Submit", height: 60) {
                print("Submitted")
                
                let body = self.descBox.text
                let added_by = self.deviceusername
                let review_to = self.queryID
                let rating = String(format: "%.3f", Double(self.starBar.value))
                //let rating = String(self.starBar.value!)
                let title = self.titleBox.text
                self.submitReview(body!,added_by,review_to,rating,title!)
            }

            // Add buttons to dialog
            // Alternatively, you can use popup.addButton(buttonOne)
            // to add a single button
            popup.addButtons([buttonNo,buttonYes])

            // Present dialog
            self.present(popup, animated: true, completion: nil)
        }else{
            self.view.showToast(toastMessage: "You must enter the required fields! Title must be between 1-60 characters, description must be between 1-500.", duration:2)
            if starBar.value == 0.0 {
                barLabel.textColor = UIColor(named: "pin")
            }
        }
    }
    
    func submitReview(_ body:String,_ added_by:String,_ review_to:String,_ rating:String,_ title:String){
        self.indicator.frame = CGRect(x: 0, y: 0, width: 60, height: 60)
        self.indicator.center = self.view.center
        self.view.addSubview(self.indicator)
        self.view.bringSubviewToFront(self.indicator)
        self.indicator.startAnimating()
        self.submitButton.isEnabled = false
        let parameters: Parameters=["body":body,
            "added_by":added_by,
            "review_to":review_to,
            "rating":rating,
            "title":title,
            "query":self.query]
        AF.request(URLConstants.ROOT_URL+"review_submit.php", method: .post, parameters: parameters).responseJSON{
            response in
            //printing response
            //print(response)

            switch response.result {
            case .success(let value):
                let jsonData = JSON(value)
                if (!((jsonData["error"].string != nil))) {
                    if (jsonData["error"]==false){
                        self.view.showToast(toastMessage: "Review posted!", duration:2)
                        self.dismiss(animated: true, completion: nil)
                    }else{
                        self.view.showToast(toastMessage: "Network error! (E.2)", duration:2)
                        self.submitButton.isEnabled = true
                        self.indicator.stopAnimating()
                    }
                }else{
                    self.view.showToast(toastMessage: "Network Error! (E.1)", duration:2)
                }
            case let .failure(error):
                print(error)
            }
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if online != "yes" {
            onlineIV.isHidden = true
        }
        if verified != "yes" {
            verifiedIV.isHidden = true
        }
        subnameLabel.text = subname
        tagnameLabel.text = "@"+tagname
        reviewedImage.af.setImage(
            withURL: URL(string:URLConstants.BASE_URL+image)!,
            imageTransition: .crossDissolve(1)
        )
        
        starBar.ratingDidChange = {
            self.currentStarRating = $0
            print(self.currentStarRating)
            switch self.currentStarRating {
            case 1.0:
                self.barLabel.text = "Bad"
                break
            case 2.0:
                self.barLabel.text = "Could use some improvement"
                break
            case 3.0:
                self.barLabel.text = "Average"
                break
            case 4.0:
                self.barLabel.text = "Good"
                break
            case 5.0:
                self.barLabel.text = "Great!"
                break
            default:
                self.barLabel.text = "Please select a rating!"
                break
            }
        }
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        if (self.isBeingDismissed || self.isMovingFromParent) {
            self.reviewDelegate?.notifyDelegate()
            print("is bein' dismissed yo")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
 
}
