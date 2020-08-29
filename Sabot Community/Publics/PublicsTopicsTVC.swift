//
//  PublicsTopicsTVC.swift
//  Sabot Community
//
//  Created by Wakamoly on 8/29/20.
//  Copyright © 2020 LucidSoftworksLLC. All rights reserved.
//

import UIKit
import EnhancedCircleImageView

class PublicsTopicsTVC: UITableViewCell {
    
    @IBOutlet weak var profileImage: EnhancedCircleImageView!
    @IBOutlet weak var online: UIImageView!
    @IBOutlet weak var verified: UIImageView!
    @IBOutlet weak var eventDate: UILabel!
    @IBOutlet weak var numPlayersAdded: UILabel!
    @IBOutlet weak var numPlayersNeeded: UILabel!
    @IBOutlet weak var gamename: UILabel!
    @IBOutlet weak var profileName: UILabel!
    @IBOutlet weak var platform: UIImageView!
    @IBOutlet weak var context: UILabel!
    @IBOutlet weak var postTitle: UILabel!
    @IBOutlet weak var numComments: UILabel!
    @IBOutlet weak var dateView: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
