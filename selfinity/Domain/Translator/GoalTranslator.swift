//
//  GoalTranslator.swift
//  selfinity
//
//  Created by Apple on 2018/10/15.
//  Copyright © 2018年 Apple. All rights reserved.
//

import Foundation
import Firebase

final class GoalsTranslator: Translator {
    typealias Input  = GoalsEntity
    typealias Output = GoalsModel
    
    static func translate(_ entity: Input) -> Output {
        let repositories: [GoalModel] = entity.items.map {
            GoalTranslator.translate($0)
        }
        
        return GoalsModel(repositories: repositories)
    }
}

final class GoalTranslator: Translator {
    typealias Input  = GoalEntity
    typealias Output = GoalModel
    
    static func translate(_ entity: Input) -> Output {
        var stepsModel: [StepModel] = []
        for step in entity.steps.enumerated() {
            stepsModel.append(StepTranslator.translate(step.element))
        }
        return GoalModel(
            uid: entity.uid,
            text: entity.text,
            credit: entity.credit,
            steps: stepsModel,
            smart: SmartTranslator.translate(entity.smart),
            owner: UserToPrunedTranslator.translate(Firebase.Auth.auth().currentUser?.uid ?? ""),
            private: entity.private,
            createdAt: entity.createdAt,
            updatedAt: entity.updatedAt
        )
    }
}
