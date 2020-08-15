//
//  UserListTVC.swift
//  Sabot Community
//
//  Created by Wakamoly on 8/6/20.
//  Copyright © 2020 LucidSoftworksLLC. All rights reserved.
//

import UIKit
import EnhancedCircleImageView

class UserListTVC: UITableViewCell {

    @IBOutlet weak var profileImage: EnhancedCircleImageView!
    @IBOutlet weak var online: EnhancedCircleImageView!
    @IBOutlet weak var verified: EnhancedCircleImageView!
    @IBOutlet weak var nickname: UILabel!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var desc: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
