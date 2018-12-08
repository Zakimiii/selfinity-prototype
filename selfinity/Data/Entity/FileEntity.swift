//
//  FileEntity.swift
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

struct FilesEntity: Mappable {
    var items: [FileEntity] = []
    
    init?(map: Map) { }
    
    mutating func mapping(map: Map) {
        self.items <- map["items"]
    }
}

struct FileEntity: Mappable {
    public var uid = Constant.filePrefix
    public var folderUid = ""
    public var folderTitle = ""
    public var title = "新規ファイル"
    public var text = ""
    public var html = ""
    public var owner = PrunedUserEntity()
    public var `private` = false
    public var createdAt = Date.CurrentDate()
    public var updatedAt = Date.CurrentDate()
    
    init?(map: Map) { }
    
    init() { }
    
    mutating func mapping(map: Map) {
        self.uid                     <- map["uid"]
        self.folderUid               <- map["folderUid"]
        self.folderTitle             <- map["folderTitle"]
        self.title                   <- map["title"]
        self.text                    <- map["text"]
        self.html                    <- map["html"]
        self.owner                   <- map["owner"]
        self.private                 <- map["private"]
        self.createdAt               <- map["createdAt"]
        self.updatedAt               <- map["updatedAt"]
    }
    
    init(snapshot:DataSnapshot) {
        self.uid                     = snapshot.childSnapshot(forPath: "uid").value as! String
        self.folderUid               = snapshot.childSnapshot(forPath: "folderUid").value as! String
        self.folderTitle             = snapshot.childSnapshot(forPath: "folderTitle").value as! String
        self.title                   = snapshot.childSnapshot(forPath: "title").value as! String
        self.html                    = snapshot.childSnapshot(forPath: "html").value as! String
        self.text                    = snapshot.childSnapshot(forPath: "text").value as! String
        self.owner                   = PrunedUserEntity(snapshot: snapshot.childSnapshot(forPath: "owner"))
        self.private                 = (snapshot.childSnapshot(forPath: "private").value as! String).toBool() ?? false
        self.createdAt               = (snapshot.childSnapshot(forPath: "createdAt").value as! String).getPrunedDate() ?? Date.CurrentDate()
        self.updatedAt               = Date.CurrentDate()
    }
}
