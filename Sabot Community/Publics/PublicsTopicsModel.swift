//
//  PublicsTopicsModel.swift
//  Sabot Community
//
//  Created by Wakamoly on 8/29/20.
//  Copyright © 2020 LucidSoftworksLLC. All rights reserved.
//

class PublicsTopicsModel {
    
    var id: Int?
    var numposts: String?
    var subject: String?
    var date: String?
    var cat: String?
    var topic_by: String?
    var type: String?
    var user_id: Int?
    var profile_pic: String?
    var nickname: String?
    var username: String?
    var event_date: String?
    var zone: String?
    var context: String?
    var num_players: Int?
    var num_added: Int?
    var gamename: String?
    
    init(id: Int?, numposts: String?, subject: String?, date: String?, cat: String?, topic_by: String?, type: String?, user_id: Int?, profile_pic: String?, nickname: String?, username: String?, event_date: String?, zone: String?, context: String?, num_players: Int?, num_added: Int?, gamename: String?) {
        
        self.id = id
        self.numposts = numposts
        self.subject = subject
        self.date = date
        self.cat = cat
        self.topic_by = topic_by
        self.type = type
        self.user_id = user_id
        self.profile_pic = profile_pic
        self.nickname = nickname
        self.username = username
        self.event_date = event_date
        self.zone = zone
        self.context = context
        self.num_players = num_players
        self.num_added = num_added
        self.gamename = gamename
        
    }
}
