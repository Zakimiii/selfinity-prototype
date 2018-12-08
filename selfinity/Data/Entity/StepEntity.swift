//
//  StepEntity.swift
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

struct StepsEntity: Mappable {
    var items: [StepEntity] = []
    
    init?(map: Map) { }
    
    init(items: [StepEntity]) {
        self.items = items
    }
    
    mutating func mapping(map: Map) {
        self.items <- map["items"]
    }
}

struct StepEntity: Mappable {
    public var uid = ""
    public var text = ""
    public var credit = 0
    public var tasks = [TaskEntity()]
    public var smart = SmartEntity()
    //public var causals = [CausalEntity()]
    public var owner =  PrunedUserEntity()
    public var `private` = false
    public var createdAt = Date.CurrentDate()
    public var updatedAt = Date.CurrentDate()
    
    init?(map: Map) { }
    
    init() { }
    
    mutating func mapping(map: Map) {
        self.uid                     <- map["uid"]
        self.text                    <- map["text"]
        self.tasks                   <- map["tasks"]
        self.credit                  <- map["credit"]
        self.smart                   <- map["smart"]
        //self.causals                 <- map["causals"]
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
        
        var tasks = [TaskEntity]()
        for child in snapshot.childSnapshot(forPath: "tasks").children {
            guard let child = child as? DataSnapshot else {
                return
            }
            tasks.append(TaskEntity(snapshot: child))
        }
        self.tasks = tasks
    }
}
