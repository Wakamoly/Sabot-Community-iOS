//
//  ProfilePostsTVC2.swift
//  Sabot Community
//
//  Created by Wakamoly on 8/28/20.
//  Copyright © 2020 LucidSoftworksLLC. All rights reserved.
//

import UIKit
import ActiveLabel
import EnhancedCircleImageView

class ProfilePostsTVC2: UITableViewCell {
    
    @IBOutlet weak var nicknameLabel: UILabel!
    @IBOutlet weak var profilePhoto: EnhancedCircleImageView!
    @IBOutlet weak var platformType: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var toUsernameLabel: UILabel!
    @IBOutlet weak var postBody: ActiveLabel!
    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var verifiedView: UIImageView!
    @IBOutlet weak var onlineView: EnhancedCircleImageView!
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
