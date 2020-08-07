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

class ReviewsViewController: UIViewController {
    
    @IBOutlet weak var profileImageReviewed: EnhancedCircleImageView!
    @IBOutlet weak var verifiedView: UIImageView!
    @IBOutlet weak var usernameView: UILabel!
    @IBOutlet weak var nicknameView: UILabel!
    @IBOutlet weak var onlineView: UIImageView!
    @IBOutlet weak var toReviewThisButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        toReviewThisButton.layer.cornerRadius = 05
        loadReviewsTop()
    }
    
    func loadReviewsTop(){
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
 
}
