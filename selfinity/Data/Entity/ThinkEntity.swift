//
//  ThinkEntity.swift
//  selfinity
//
//  Created by Apple on 2018/10/07.
//  Copyright © 2018年 Apple. All rights reserved.
//

import UIKit
import Foundation
import ObjectMapper
import Firebase

struct ThinksEntity: Mappable {
    var items: [ThinkEntity] = []
    
    init?(map: Map) { }
    
    init() { }
    
    mutating func mapping(map: Map) {
        self.items <- map["items"]
    }
}

struct ThinkEntity: Mappable {
    public var uid = ""
    public var text =  ""
    public var credit = 0
    public var `private` = false
    public var createdAt = Date.CurrentDate()
    public var updatedAt = Date.CurrentDate()
    
    init?(map: Map) { }
    
    init() { }
    
    mutating func mapping(map: Map) {
        self.uid                     <- map["uid"]
        self.text                    <- map["text"]
        self.credit                  <- map["credit"]
        self.private                 <- map["private"]
        self.createdAt               <- map["createdAt"]
        self.updatedAt               <- map["updatedAt"]
    }
    
    init(snapshot:DataSnapshot) {
        self.uid                     = snapshot.childSnapshot(forPath: "uid").value as! String
        self.text                    = snapshot.childSnapshot(forPath: "text").value as! String
        self.credit                   = Int(snapshot.childSnapshot(forPath: "credit").value as! String)!
        self.private                 = (snapshot.childSnapshot(forPath: "private").value as! String).toBool() ?? false
        self.createdAt               = (snapshot.childSnapshot(forPath: "createdAt").value as! String).getPrunedDate() ?? Date.CurrentDate()
        self.updatedAt               = Date.CurrentDate()
    }
}
