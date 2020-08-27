//
//  ProfilePostsTVC.swift
//  Sabot Community
//
//  Created by Wakamoly on 7/27/20.
//  Copyright © 2020 LucidSoftworksLLC. All rights reserved.
//

import UIKit
import ActiveLabel

class ProfilePostsTVC: UITableViewCell {
    
    @IBOutlet weak var nicknameLabel: UILabel!
    @IBOutlet weak var profilePhoto: UIImageView!
    @IBOutlet weak var platformType: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var toUsernameLabel: UILabel!
    @IBOutlet weak var postBody: ActiveLabel!
    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var verifiedView: UIImageView!
    @IBOutlet weak var onlineView: UIImageView!
    @IBOutlet weak var numLikes: UILabel!
    @IBOutlet weak var numComments: UILabel!
    @IBOutlet weak var dateView: UILabel!
    @IBOutlet weak var likeView: UIImageView!
    @IBOutlet weak var likedView: UIImageView!
    @IBOutlet weak var editedLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
