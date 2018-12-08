//
//  PrunedUserEntity.swift
//  selfinity
//
//  Created by Apple on 2018/10/07.
//  Copyright © 2018年 Apple. All rights reserved.
//

import UIKit
import Foundation
import ObjectMapper
import Firebase
import SwiftDate

struct PrunedUsersEntity: Mappable {
    var items: [PrunedUserEntity] = []
    
    init?(map: Map) { }
    
    mutating func mapping(map: Map) {
        self.items <- map["items"]
    }
}

struct PrunedUserEntity: Mappable {
    public var uid = NSUUID().uuidString
    public var displayName = ""
    public var credit = 0
    public var sumCredit = 0
    public var profileImage = NSURL()
    public var backgroundImage = NSURL()
    public var registrationConfirmed = false
    public var permissions = false
    public var `private` = false
    public var createdAt = Date.CurrentDate()
    public var updatedAt = Date.CurrentDate()
    
    init?(map: Map) { }
    
    init() { }
    
    init(uid: String, credit: Int, sumCredit: Int, displayName: String, profileImage: NSURL, backgroundImage: NSURL, registrationConfirmed: Bool, permissions: Bool, `private`: Bool, createdAt: Date, updatedAt: Date) {
        self.uid = uid
        self.credit = credit
        self.sumCredit = sumCredit
        self.displayName = displayName
        self.profileImage = profileImage
        self.backgroundImage = backgroundImage
        self.registrationConfirmed = registrationConfirmed
        self.permissions = permissions
        self.private = `private`
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
    
    mutating func mapping(map: Map) {
        self.uid                    <- map["uid"]
        self.credit                  <- map["credit"]
        self.sumCredit                  <- map["sumCredit"]
        self.displayName                <- map["displayName"]
        self.profileImage            <- map["profileImage"]
        self.backgroundImage         <- map["backgroundImage"]
        self.registrationConfirmed   <- map["registrationConfirmed"]
        self.permissions             <- map["permissions"]
        self.private                 <- map["private"]
        self.createdAt               <- map["createdAt"]
        self.updatedAt               <- map["updatedAt"]
    }
    
    init(snapshot:DataSnapshot) {
        self.uid                     = snapshot.childSnapshot(forPath: "uid").value as! String
        self.credit                   = Int(snapshot.childSnapshot(forPath: "credit").value as! String)!
        self.sumCredit                   = Int(snapshot.childSnapshot(forPath: "sumCredit").value as! String)!
        self.displayName             = snapshot.childSnapshot(forPath: "displayName").value as! String
        self.profileImage            = NSURL(string: snapshot.childSnapshot(forPath: "profileImage").value as! String) ?? NSURL()
        self.backgroundImage         = NSURL(string: snapshot.childSnapshot(forPath: "backgroundImage").value as! String) ?? NSURL()
        self.registrationConfirmed   = (snapshot.childSnapshot(forPath: "registrationConfirmed").value as! String).toBool() ?? false
        self.permissions             = (snapshot.childSnapshot(forPath: "permissions").value as! String).toBool() ?? false
        self.private                 = (snapshot.childSnapshot(forPath: "private").value as! String).toBool() ?? false
        self.createdAt               = (snapshot.childSnapshot(forPath: "createdAt").value as! String).getPrunedDate() ?? Date.CurrentDate()
        self.updatedAt               = Date.CurrentDate()
    }
}
