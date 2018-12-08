
//
//  SmartModel.swift
//  selfinity
//
//  Created by Apple on 2018/10/18.
//  Copyright © 2018年 Apple. All rights reserved.
//

import UIKit
import Foundation

struct SmartsModel {
    var repositories: [SmartModel] = []
}

struct SmartModel {
    let uid: String
    var specificSubject: String
    var specificVerb: String
    var timeBound: String
    var measurable: String
    let owner: PrunedUserModel
    let `private`: Bool
    let createdAt: Date
    let updatedAt: Date
    
    func createJAText() -> String {
        if self.timeBound != ""  {
            return self.specificSubject + "を" + self.timeBound + "までに" + self.measurable + self.specificVerb
        } else {
            return self.specificSubject + "を" + self.timeBound + self.measurable + self.specificVerb
        }
    }
    
    //todo 格助詞の測定 数助詞の測定
    
//    enum JATextTimeMode: Int {
//        case by
//        case when
//        case empty
//    }
}
