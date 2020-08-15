//
//  ReviewsModel.swift
//  Sabot Community
//
//  Created by Wakamoly on 8/11/20.
//  Copyright © 2020 LucidSoftworksLLC. All rights reserved.
//

class ReviewsModel {
    
    var ratingnumber: Int?
    var title: String?
    var comments: String?
    var reply: String?
    var time: String?
    var profile_pic: String?
    var nickname: String?
    var userid: Int?
    var verified: String?
    var online: String?
    var rating_id: Int?
    
    init(ratingnumber: Int?,title: String?,comments: String?,reply: String?,time: String?,profile_pic: String?,nickname: String?,userid: Int?,verified: String?,online: String?,rating_id: Int?) {
        
        self.ratingnumber = ratingnumber
        self.title = title
        self.comments = comments
        self.reply = reply
        self.time = time
        self.profile_pic = profile_pic
        self.nickname = nickname
        self.userid = userid
        self.verified = verified
        self.online = online
        self.rating_id = rating_id
        
    }
}
