//
//  ProfileNewsModel.swift
//  Sabot Community
//
//  Created by Wakamoly on 7/27/20.
//  Copyright © 2020 LucidSoftworksLLC. All rights reserved.
//

class ProfileNewsModel {
    
    var id: Int?
    var type: String?
    var likes:String?
    var body:String?
    var added_by:String?
    var user_to:String?
    var date_added:String?
    var user_closed:String?
    var deleted:String?
    var image:String?
    var user_id:String?
    var profile_pic:String?
    var verified:String?
    var online:String?
    var nickname:String?
    var username:String?
    var commentcount:String?
    var likedbyuser:String?
    var form:String?
    var edited:String?
    
    init(id: Int?, type: String?, likes:String?, body:String?, added_by:String?, user_to:String?, date_added:String?, user_closed:String?, deleted:String?, image:String?, user_id:String?, profile_pic:String?, verified:String?, online:String?, nickname:String?, username:String?, commentcount:String?, likedbyuser:String?, form:String?, edited:String?) {
        
        self.id = id
        self.type = type
        self.likes = likes
        self.body = body
        self.added_by = added_by
        self.user_to = user_to
        self.date_added = date_added
        self.user_closed = user_closed
        self.deleted = deleted
        self.image = image
        self.user_id = user_id
        self.profile_pic = profile_pic
        self.verified = verified
        self.online = online
        self.nickname = nickname
        self.username = username
        self.commentcount = commentcount
        self.likedbyuser = likedbyuser
        self.form = form
        self.edited = edited
        
    }
}
