//
//  ChatEntity.swift
//  selfinity
//
//  Created by Apple on 2018/10/25.
//  Copyright © 2018年 Apple. All rights reserved.
//

import UIKit
import Foundation
import ObjectMapper
import Firebase
import SwiftDate

struct ChatsEntity: Mappable {
    var items: [ChatEntity] = []
    
    init() { }
    
    init?(map: Map) { }
    
    mutating func mapping(map: Map) {
        self.items <- map["items"]
    }
}

struct ChatEntity: Mappable {
    
    public var uid = NSUUID().uuidString
    public var credit = 0
    public var text = ""
    public var userType = UserType.I.rawValue
    public var ownerUid = ""
    public var `private` = false
    public var createdAt = Date.CurrentDate()
    public var updatedAt = Date.CurrentDate()
    
    init?(map: Map) { }
    
    init() { }
    
    public func isMyChat() -> Bool {
        return userType == "I"
    }
    
    mutating func mapping(map: Map) {
        self.uid                     <- map["uid"]
        self.credit                  <- map["credit"]
        self.text                    <- map["text"]
        self.userType                <- map["userType"]
        self.ownerUid                <- map["ownerUid"]
        self.private                 <- map["private"]
        self.createdAt               <- map["createdAt"]
        self.updatedAt               <- map["updatedAt"]
    }
    
    init(snapshot:DataSnapshot) {
        self.uid                     = snapshot.childSnapshot(forPath: "uid").value as! String
        self.credit                   = Int(snapshot.childSnapshot(forPath: "credit").value as! String)!
        self.text                    = snapshot.childSnapshot(forPath: "text").value as! String
        self.userType                = snapshot.childSnapshot(forPath: "userType").value as! String
        self.ownerUid                = snapshot.childSnapshot(forPath: "ownerUid").value as! String
        self.private                 = (snapshot.childSnapshot(forPath: "private").value as! String).toBool() ?? false
        self.createdAt               = (snapshot.childSnapshot(forPath: "createdAt").value as! String).getPrunedDate() ?? Date.CurrentDate()
        self.updatedAt               = Date.CurrentDate()
    }
}

public enum UserType: String {
    case I     =  "I"
    case You   =  "You"
}
