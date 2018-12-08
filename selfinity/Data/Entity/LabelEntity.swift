//
//  LabelEntity.swift
//  selfinity
//
//  Created by Apple on 2018/10/24.
//  Copyright © 2018年 Apple. All rights reserved.
//

import UIKit
import Foundation
import ObjectMapper
import Firebase
import SwiftDate

struct LabelsEntity: Mappable {
    var items: [LabelEntity] = []
    
    init() { }
    
    init?(map: Map) { }
    
    mutating func mapping(map: Map) {
        self.items <- map["items"]
    }
}

struct LabelEntity: Mappable {
    public var uid = NSUUID().uuidString
    public var tagUid = NSUUID().uuidString
    public var title = ""
    public var tagkind = Tag.empty.rawValue
    public var owner = PrunedUserEntity()
    public var `private` = false
    public var createdAt = Date.CurrentDate()
    public var updatedAt = Date.CurrentDate()
    
    init?(map: Map) { }
    
    init() { }
    
    mutating func mapping(map: Map) {
        self.uid                     <- map["uid"]
        self.title                   <- map["title"]
        self.tagUid                  <- map["tagUid"]
        self.tagkind                 <- map["tagKind"]
        self.owner                   <- map["owner"]
        self.private                 <- map["private"]
        self.createdAt               <- map["createdAt"]
        self.updatedAt               <- map["updatedAt"]
    }
    
    init(snapshot:DataSnapshot) {
        self.uid                     = snapshot.childSnapshot(forPath: "uid").value as! String
        self.title                   = snapshot.childSnapshot(forPath: "title").value as! String
        self.tagkind                 = snapshot.childSnapshot(forPath: "tagKind").value as! String
        self.tagUid                  = snapshot.childSnapshot(forPath: "tagUid").value as! String
        self.owner                   = PrunedUserEntity(snapshot: snapshot.childSnapshot(forPath: "owner"))
        self.private                 = (snapshot.childSnapshot(forPath: "private").value as! String).toBool() ?? false
        self.createdAt               = (snapshot.childSnapshot(forPath: "createdAt").value as! String).getPrunedDate() ?? Date.CurrentDate()
        self.updatedAt               = Date.CurrentDate()
    }
}
