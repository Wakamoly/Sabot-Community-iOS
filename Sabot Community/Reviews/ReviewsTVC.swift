//
//  ReviewsTVC.swift
//  Sabot Community
//
//  Created by Wakamoly on 8/11/20.
//  Copyright © 2020 LucidSoftworksLLC. All rights reserved.
//

import UIKit
import EnhancedCircleImageView
import AARatingBar

class ReviewsTVC: UITableViewCell {

    @IBOutlet weak var profileImage: EnhancedCircleImageView!
    @IBOutlet weak var online: EnhancedCircleImageView!
    @IBOutlet weak var verified: EnhancedCircleImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var bodyLabel: UILabel!
    @IBOutlet weak var ratingView: AARatingBar!
    @IBOutlet weak var profileName: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var replyLayout: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
