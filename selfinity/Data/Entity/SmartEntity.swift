//
//  SmartEntity.swift
//  selfinity
//
//  Created by Apple on 2018/10/18.
//  Copyright © 2018年 Apple. All rights reserved.
//

import UIKit
import Foundation
import ObjectMapper
import Firebase
import SwiftDate

struct SmartsEntity: Mappable {
    var items: [SmartEntity] = []
    
    init?(map: Map) { }
    
    mutating func mapping(map: Map) {
        self.items <- map["items"]
    }
}

struct SmartEntity: Mappable {
    public var uid = NSUUID().uuidString
    public var specificSubject = ""
    public var specificVerb = ""
    public var timeBound = ""
    public var measurable = ""
    public var owner =  PrunedUserEntity()
    //public var causals = [CausalEntity()]
    public var `private` = false
    public var createdAt = Date.CurrentDate()
    public var updatedAt = Date.CurrentDate()
    
    init?(map: Map) { }
    
    init() { }
    
    mutating func mapping(map: Map) {
        self.uid                     <- map["uid"]
        //self.causals                 <- map["causals"]
        self.specificSubject         <- map["specificSubject"]
        self.specificVerb            <- map["specificVerb"]
        self.timeBound               <- map["timeBound"]
        self.measurable              <- map["measurable"]
        self.owner                   <- map["owner"]
        self.private                 <- map["private"]
        self.createdAt               <- map["createdAt"]
        self.updatedAt               <- map["updatedAt"]
    }
    
    init(snapshot:DataSnapshot) {
        self.uid                     = snapshot.childSnapshot(forPath: "uid").value as! String
        self.specificSubject         = snapshot.childSnapshot(forPath: "specificSubject").value as! String
        self.specificVerb            = snapshot.childSnapshot(forPath: "specificVerb").value as! String
        self.timeBound               = snapshot.childSnapshot(forPath: "timeBound").value as! String
        self.measurable              = snapshot.childSnapshot(forPath: "measurable").value as! String
        self.owner                   = PrunedUserEntity(snapshot: snapshot.childSnapshot(forPath: "owner"))
        self.private                 = (snapshot.childSnapshot(forPath: "private").value as! String).toBool() ?? false
        self.createdAt               = (snapshot.childSnapshot(forPath: "createdAt").value as! String).getPrunedDate() ?? Date.CurrentDate()
        self.updatedAt               = Date.CurrentDate()
    }
    
    func createJAText() -> String {
        return self.specificSubject + self.timeBound + self.measurable + self.specificVerb
    }
}
