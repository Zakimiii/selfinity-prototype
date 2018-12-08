//
//  StepToTaskTranslator.swift
//  selfinity
//
//  Created by Apple on 2018/10/20.
//  Copyright © 2018年 Apple. All rights reserved.
//

import UIKit
import Firebase
import SwiftDate

//IMPORTANT:This is a task generator!
final class StepToTaskTranslator: Translator {
    typealias Input  = StepModel
    typealias Output = TaskModel
    
    static func translate(_ entity: Input) -> Output {
        let timeBound = "1日に1度"//(entity.smart.timeBound.getDate()! - Date()).day ?? (entity.smart.timeBound.getDate()! - Date()).hour!
        let smart = SmartModel.init(uid: NSUUID().uuidString,
                                specificSubject: entity.smart.specificSubject,
                                specificVerb: entity.smart.specificVerb,
                                timeBound: timeBound,
                                measurable: entity.smart.measurable,
                                owner: entity.owner,
                                private: false,
                                createdAt: Date.CurrentDate(),
                                updatedAt: Date.CurrentDate()
        )
        
        return TaskModel.init(uid: NSUUID().uuidString,
                              text: smart.createJAText(),
                              credit: entity.credit,
                              smart: smart,
                              owner: entity.owner,
                              private: false,
                              createdAt: Date.CurrentDate(),
                              updatedAt: Date.CurrentDate()
        )
//            SmartModel(
//            uid: entity.uid,
//            specificSubject: entity.specificSubject,
//            specificVerb: entity.specificVerb,
//            timeBound: entity.timeBound,
//            measurable: entity.measurable,
//            owner: UserToPrunedTranslator.translate(Firebase.Auth.auth().currentUser?.uid ?? ""),
//            private: entity.private,
//            createdAt: entity.createdAt,
//            updatedAt: entity.updatedAt
//        )
    }
}
