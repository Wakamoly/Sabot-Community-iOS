//
//  ClansTVC.swift
//  Sabot Community
//
//  Created by Wakamoly on 8/28/20.
//  Copyright © 2020 LucidSoftworksLLC. All rights reserved.
//

import UIKit
import AARatingBar

class ClansTVC: UITableViewCell {
    
    @IBOutlet weak var clanImageView: UIImageView!
    @IBOutlet weak var clanTag: UILabel!
    @IBOutlet weak var clanName: UILabel!
    @IBOutlet weak var numMembers: UILabel!
    @IBOutlet weak var clanRating: AARatingBar!
    @IBOutlet weak var clanPosition: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
