//
//  CausalEntity.swift
//  selfinity
//
//  Created by Apple on 2018/10/08.
//  Copyright © 2018年 Apple. All rights reserved.
//

import UIKit
import Foundation
import ObjectMapper
import Firebase

struct CausalsEntity: Mappable {
    var items: [CausalEntity] = []
    
    init?(map: Map) { }
    
    mutating func mapping(map: Map) {
        self.items <- map["items"]
    }
}

struct CausalEntity: Mappable {
    public var uid = ""
    public var credit = 0
    public var result = ThinkEntity()
    public var resultUid = ""
    public var reason = ThinkEntity()
    public var reasonUid = ""
    public var relation =  Causal.cause.rawValue
    public var `private` = false
    public var createdAt = Date.CurrentDate()
    public var updatedAt = Date.CurrentDate()
    
    init?(map: Map) { }
    
    init() { }
    
    mutating func mapping(map: Map) {
        self.uid                      <- map["uid"]
        self.result                  <- map["result"]
        self.reason                  <- map["reason"]
        self.relation                <- map["relation"]
        self.private                 <- map["private"]
        self.createdAt               <- map["createdAt"]
        self.updatedAt               <- map["updatedAt"]
    }
    
    init(snapshot:DataSnapshot) {
        self.uid                     = snapshot.childSnapshot(forPath: "uid").value as! String
        self.result                  = ThinkEntity(snapshot: snapshot.childSnapshot(forPath: "result"))
        self.resultUid               = snapshot.childSnapshot(forPath: "resultUid").value as! String
        self.reason                  = ThinkEntity(snapshot: snapshot.childSnapshot(forPath: "reason"))
        self.reasonUid               = snapshot.childSnapshot(forPath: "reasonUid").value as! String
        self.relation                   = Int(snapshot.childSnapshot(forPath: "relation").value as! String)!
        self.credit                  = Int(snapshot.childSnapshot(forPath: "credit").value as! String)!
        self.private                 = (snapshot.childSnapshot(forPath: "private").value as! String).toBool() ?? false
        self.createdAt               = (snapshot.childSnapshot(forPath: "createdAt").value as! String).getPrunedDate() ?? Date.CurrentDate()
        self.updatedAt               = Date.CurrentDate()
    }
}
