//
//  ReminderEntity.swift
//  selfinity
//
//  Created by Apple on 2018/10/20.
//  Copyright © 2018年 Apple. All rights reserved.
//

import UIKit
import Foundation
import ObjectMapper
import Firebase
import SwiftDate
import MapKit

struct RemindersEntity: Mappable {
    var items: [ReminderEntity] = []
    
    init?(map: Map) { }
    
    init() { }
    
    mutating func mapping(map: Map) {
        self.items <- map["items"]
    }
}

struct ReminderEntity: Mappable {
    public var uid = Constant.reminderPrefix
    public var title = "新規ファイル"
    public var text = ""
    public var time = Date.CurrentDate()
    public var span = 30
    public var `repeat` = 0
    public var notification = true
    public var longitude = CGFloat(0)
    public var latitude = CGFloat(0)
    public var address = ""
    public var tagUid = ""
    public var tagKind = Tag.empty.rawValue
    public var place = Place.in.rawValue
    public var owner = PrunedUserEntity()
    public var `private` = false
    public var createdAt = Date.CurrentDate()
    public var updatedAt = Date.CurrentDate()
    
    init?(map: Map) { }
    
    init() { }
    
    init(uid: String, title: String, text: String, time: Date, span: Int, `repeat`: Int, notification: Bool, longitude: CGFloat, latitude: CGFloat, address: String, tagUid: String, tagKind: String, place: Place, owner: PrunedUserEntity, private: Bool, createdAt: Date, updatedAt: Date) {
        self.uid = uid
        self.time = time
        self.span = span
        self.repeat = `repeat`
        self.title = title
        self.text = text
        self.notification = notification
        self.longitude = longitude
        self.latitude = latitude
        self.address = address
        self.tagUid = tagUid
        self.tagKind = tagKind
        self.place = place.rawValue
        self.owner = owner
        self.private = `private`
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
    
    mutating func mapping(map: Map) {
        self.uid                     <- map["uid"]
        self.title                   <- map["title"]
        self.text                    <- map["text"]
        self.span                    <- map["span"]
        self.time                    <- map["time"]
        self.repeat                  <- map["repeat"]
        self.notification            <- map["notification"]
        self.longitude               <- map["longitude"]
        self.latitude                <- map["latitude"]
        self.address                 <- map["address"]
        self.tagUid                  <- map["tagUid"]
        self.tagKind                 <- map["tagKind"]
        self.place                   <- map["place"]
        self.owner                   <- map["owner"]
        self.private                 <- map["private"]
        self.createdAt               <- map["createdAt"]
        self.updatedAt               <- map["updatedAt"]
    }
    
    init(snapshot:DataSnapshot) {
        self.uid                     = snapshot.childSnapshot(forPath: "uid").value as! String
        self.title                   = snapshot.childSnapshot(forPath: "title").value as! String
        self.time                    = (snapshot.childSnapshot(forPath: "time").value as! String).getPrunedDate() ?? Date.CurrentDate()
        self.span                    = Int(snapshot.childSnapshot(forPath: "span").value as! String)!
        self.repeat                  = Int(snapshot.childSnapshot(forPath: "repeat").value as! String)!
        self.notification            = (snapshot.childSnapshot(forPath: "notification").value as! String).toBool() ?? false
        self.longitude               = CGFloat(Float(snapshot.childSnapshot(forPath: "longitude").value as! String)!)
        self.latitude                = CGFloat(Float(snapshot.childSnapshot(forPath: "latitude").value as! String)!)
        self.address                 = snapshot.childSnapshot(forPath: "address").value as! String
        self.tagUid                  = snapshot.childSnapshot(forPath: "tagUid").value as! String
        self.tagKind                 = snapshot.childSnapshot(forPath: "tagKind").value as! String
        self.place                   = Int(snapshot.childSnapshot(forPath: "place").value as! String)!
        self.text                    = snapshot.childSnapshot(forPath: "text").value as! String
        self.owner                   = PrunedUserEntity(snapshot: snapshot.childSnapshot(forPath: "owner"))
        self.private                 = (snapshot.childSnapshot(forPath: "private").value as! String).toBool() ?? false
        self.createdAt               = (snapshot.childSnapshot(forPath: "createdAt").value as! String).getPrunedDate() ?? Date.CurrentDate()
        self.updatedAt               = Date.CurrentDate()
    }
}
