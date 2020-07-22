//
//  CircleImageView.swift
//  Sabot Community
//
//  Created by Wakamoly on 7/20/20.
//  Copyright © 2020 LucidSoftworksLLC. All rights reserved.
//

import UIKit

extension UIImageView{
    var circled : UIImageView{
        self.layer.cornerRadius = self.frame.width / 2;
        self.layer.borderWidth = 2
        self.layer.borderColor = UIColor.white.cgColor
        self.clipsToBounds = true
        return self
    }
}
