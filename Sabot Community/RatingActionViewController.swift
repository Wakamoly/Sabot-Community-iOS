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

protocol NotifyReloadReviews:class{
    func notifyDelegate()
}

class RatingActionViewController: UIViewController {
    
    
    weak var reviewDelegate: NotifyReloadReviews? = nil
    
    var queryID:String = ""
    var query:String = ""
    var subname:String = ""
    var tagname:String = ""
    var verified:String = ""
    var image:String = ""
    var online:String = ""
    
    @IBOutlet weak var reviewedImage: EnhancedCircleImageView!
    @IBOutlet weak var subnameLabel: UILabel!
    @IBOutlet weak var tagnameLabel: UILabel!
    @IBOutlet weak var starBar: AARatingBar!
    @IBOutlet weak var titleBox: UITextField!
    @IBOutlet weak var descBox: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var verifiedIV: EnhancedCircleImageView!
    @IBOutlet weak var onlineIV: EnhancedCircleImageView!
    

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
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        if (self.isBeingDismissed || self.isMovingFromParent) {
            self.reviewDelegate?.notifyDelegate()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
 
}
