//
//  StepTranslator.swift
//  selfinity
//
//  Created by Apple on 2018/10/15.
//  Copyright © 2018年 Apple. All rights reserved.
//

import Foundation
import Firebase

final class StepsTranslator: Translator {
    typealias Input  = StepsEntity
    typealias Output = StepsModel
    
    static func translate(_ entity: Input) -> Output {
        let repositories: [StepModel] = entity.items.map {
            StepTranslator.translate($0)
        }
        
        return StepsModel(repositories: repositories)
    }
}

final class StepTranslator: Translator {
    typealias Input  = StepEntity
    typealias Output = StepModel
    
    static func translate(_ entity: Input) -> Output {
        var tasksModel: [TaskModel] = []
        for task in entity.tasks.enumerated() {
            tasksModel.append(TaskTranslator.translate(task.element))
        }
        return StepModel(
            uid: entity.uid,
            text: entity.text,
            credit: entity.credit,
            smart: SmartTranslator.translate(entity.smart),
            tasks: tasksModel,
            owner: UserToPrunedTranslator.translate(Firebase.Auth.auth().currentUser?.uid ?? ""),
            private: entity.private,
            createdAt: entity.createdAt,
            updatedAt: entity.updatedAt
        )
    }
    
    static func translateForModel(_ entity: StepModel) -> Output {
        var tasksModel: [TaskModel] = []
        for task in entity.tasks.enumerated() {
            tasksModel.append(TaskTranslator.translateForModel(task.element))
        }
        return StepModel(
            uid: entity.uid,
            text: entity.text,
            credit: entity.credit,
            smart: entity.smart,
            tasks: tasksModel,
            owner: UserToPrunedTranslator.translate(Firebase.Auth.auth().currentUser?.uid ?? ""),
            private: entity.private,
            createdAt: entity.createdAt,
            updatedAt: entity.updatedAt
        )
    }
}
