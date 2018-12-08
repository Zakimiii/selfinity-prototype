//
//  TaskEntity.swift
//  selfinity
//
//  Created by Apple on 2018/10/08.
//  Copyright © 2018年 Apple. All rights reserved.
//

import UIKit
import Foundation
import ObjectMapper
import Firebase
import SwiftDate

struct TasksEntity: Mappable {
    var items: [StepEntity] = []
    
    init?(map: Map) { }
    
    mutating func mapping(map: Map) {
        self.items <- map["items"]
    }
}

struct TaskEntity: Mappable {
    public var uid = NSUUID().uuidString
    public var text = ""
    public var credit = 0
    public var owner =  PrunedUserEntity()
    public var smart = SmartEntity()
    //public var causals = [CausalEntity()]
    public var `private` = false
    public var createdAt = Date.CurrentDate()
    public var updatedAt = Date.CurrentDate()
    
    init?(map: Map) { }
    
    init() { }
    
    mutating func mapping(map: Map) {
        self.uid                     <- map["uid"]
        self.text                    <- map["text"]
        self.credit                  <- map["credit"]
        //self.causals                 <- map["causals"]
        self.smart                   <- map["smart"]
        self.owner                   <- map["owner"]
        self.private                 <- map["private"]
        self.createdAt               <- map["createdAt"]
        self.updatedAt               <- map["updatedAt"]
    }
    
    init(snapshot:DataSnapshot) {
        self.uid                     = snapshot.childSnapshot(forPath: "uid").value as! String
        self.text                    = snapshot.childSnapshot(forPath: "text").value as! String
        self.credit                   = Int(snapshot.childSnapshot(forPath: "credit").value as! String)!
        self.smart                   = SmartEntity(snapshot: snapshot.childSnapshot(forPath: "smart"))
        self.owner                   = PrunedUserEntity(snapshot: snapshot.childSnapshot(forPath: "owner"))
        self.private                 = (snapshot.childSnapshot(forPath: "private").value as! String).toBool() ?? false
        self.createdAt               = (snapshot.childSnapshot(forPath: "createdAt").value as! String).getPrunedDate() ?? Date.CurrentDate()
        self.updatedAt               = Date.CurrentDate()
    }
}
