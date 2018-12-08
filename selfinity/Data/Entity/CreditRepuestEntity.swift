//
//  CreditRepuestEntity.swift
//  selfinity
//
//  Created by Apple on 2018/10/25.
//  Copyright © 2018年 Apple. All rights reserved.
//

import UIKit
import Foundation
import ObjectMapper
import Firebase

struct CreditRepuestsEntity: Mappable {
    var items: [CreditRepuestEntity] = []
    
    init?(map: Map) { }
    
    init() { }
    
    mutating func mapping(map: Map) {
        self.items <- map["items"]
    }
}

struct CreditRepuestEntity: Mappable {
    public var uid = ""
    public var text =  ""
    public var credit = 0
    public var fromTagUid = NSUUID().uuidString
    public var fromTagKind = Tag.empty.rawValue
    public var toTagUid = NSUUID().uuidString
    public var toTagKind = Tag.empty.rawValue
    public var `private` = false
    public var createdAt = Date.CurrentDate()
    public var updatedAt = Date.CurrentDate()
    
    init?(map: Map) { }
    
    init() { }
    
    mutating func mapping(map: Map) {
        self.uid                     <- map["uid"]
        self.text                    <- map["text"]
        self.credit                  <- map["credit"]
        self.fromTagUid              <- map["fromTagUid"]
        self.fromTagKind             <- map["fromTagKind"]
        self.toTagUid                <- map["toTagUid"]
        self.toTagKind               <- map["toTagKind"]
        self.private                 <- map["private"]
        self.createdAt               <- map["createdAt"]
        self.updatedAt               <- map["updatedAt"]
    }
    
    init(snapshot:DataSnapshot) {
        self.uid                     = snapshot.childSnapshot(forPath: "uid").value as! String
        self.text                    = snapshot.childSnapshot(forPath: "text").value as! String
        self.credit                  = Int(snapshot.childSnapshot(forPath: "credit").value as! String)!
        self.fromTagUid              = snapshot.childSnapshot(forPath: "fromTagUid").value as! String
        self.fromTagKind             = snapshot.childSnapshot(forPath: "fromTagKind").value as! String
        self.toTagUid                = snapshot.childSnapshot(forPath: "toTagUid").value as! String
        self.toTagKind               = snapshot.childSnapshot(forPath: "toTagKind").value as! String
        self.private                 = (snapshot.childSnapshot(forPath: "private").value as! String).toBool() ?? false
        self.createdAt               = (snapshot.childSnapshot(forPath: "createdAt").value as! String).getPrunedDate() ?? Date.CurrentDate()
        self.updatedAt               = Date.CurrentDate()
    }
}
