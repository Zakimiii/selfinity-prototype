//
//  FolderEntity.swift
//  selfinity
//
//  Created by Apple on 2018/10/16.
//  Copyright © 2018年 Apple. All rights reserved.
//

import UIKit
import Foundation
import ObjectMapper
import Firebase
import SwiftDate

struct FoldersEntity: Mappable {
    var items: [FolderEntity] = []
    
    init(items: [FolderEntity]) {
        self.items = items
    }
    
    init?(map: Map) { }
    
    mutating func mapping(map: Map) {
        self.items <- map["items"]
    }
}

struct FolderEntity: Mappable {
    public var uid = NSUUID().uuidString
    public var title = ""
    public var files = [FileEntity()]
    public var owner = PrunedUserEntity()
    public var `private` = false
    public var createdAt = Date.CurrentDate()
    public var updatedAt = Date.CurrentDate()
    
    init?(map: Map) { }
    
    init() { }
    
    mutating func mapping(map: Map) {
        self.uid                     <- map["uid"]
        self.title                   <- map["title"]
        self.files                   <- map["files"]
        self.owner                   <- map["owner"]
        self.private                 <- map["private"]
        self.createdAt               <- map["createdAt"]
        self.updatedAt               <- map["updatedAt"]
    }
    
    init(snapshot:DataSnapshot) {
        guard !snapshot.key.contains(Constant.allFolderPrefix) else {
            self.uid = snapshot.key
            var files = [FileEntity]()
            for child in snapshot.childSnapshot(forPath: "files").children {
                guard let child = child as? DataSnapshot else {
                    return
                }
                files.append(FileEntity(snapshot: child))
            }
            self.files = files
            return
        }
        self.uid                     = snapshot.childSnapshot(forPath: "uid").value as! String
        self.title                   = snapshot.childSnapshot(forPath: "title").value as! String
        self.owner                   = PrunedUserEntity(snapshot: snapshot.childSnapshot(forPath: "owner"))
        self.private                 = (snapshot.childSnapshot(forPath: "private").value as! String).toBool() ?? false
        self.createdAt               = (snapshot.childSnapshot(forPath: "createdAt").value as! String).getPrunedDate() ?? Date.CurrentDate()
        self.updatedAt               = Date.CurrentDate()
        
        var files = [FileEntity]()
        for child in snapshot.childSnapshot(forPath: "files").children {
            guard let child = child as? DataSnapshot else {
                return
            }
            files.append(FileEntity(snapshot: child))
        }
        self.files = files
    }
}
