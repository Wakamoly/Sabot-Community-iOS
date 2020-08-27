//
//  UserListModel.swift
//  Sabot Community
//
//  Created by Wakamoly on 8/5/20.
//  Copyright © 2020 LucidSoftworksLLC. All rights reserved.
//

class UserListModel {
    
    var id: Int?
    var user_id: String?
    var profile_pic:String?
    var nickname:String?
    var username:String?
    var verified:String?
    var online:String?
    var desc:String?
    
    init(id: Int?, user_id: String?,profile_pic:String?, nickname:String?, username:String?, verified:String?,  online:String?, desc:String?) {
        
        self.id = id
        self.user_id = user_id
        self.profile_pic = profile_pic
        self.verified = verified
        self.online = online
        self.nickname = nickname
        self.username = username
        self.desc = desc
        
    }
}
