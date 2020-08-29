//
//  ClansModel.swift
//  Sabot Community
//
//  Created by Wakamoly on 8/29/20.
//  Copyright © 2020 LucidSoftworksLLC. All rights reserved.
//

class ClansModel {
    
    var position: String?
    var tag: String?
    var name: String?
    var num_members: String?
    var insignia: String?
    var games: String?
    var id: Int?
    var avg: String?
    
    init(position: String?, tag: String?, name: String?, num_members: String?, insignia: String?, games: String?, id: Int?, avg: String?) {
    
        self.position = position
        self.tag = tag
        self.name = name
        self.num_members = num_members
        self.insignia = insignia
        self.games = games
        self.id = id
        self.avg = avg
        
    }
}
