//
//  HomeIndexTranslator.swift
//  selfinity
//
//  Created by Apple on 2018/10/15.
//  Copyright © 2018年 Apple. All rights reserved.
//

import UIKit
import Foundation
import Firebase

final class HomeIndexesTranslator: Translator {
    typealias Input  = GoalsEntity
    typealias Output = HomeIndexesModel

    static func translate(_ entity: Input) -> Output {
        let repositories: [HomeIndexModel] = entity.items.map {
            HomeIndexTranslator.translate($0)
        }
        return HomeIndexesModel(items: repositories)
    }
}

final class HomeIndexTranslator: Translator {
    typealias Input  = GoalEntity
    typealias Output = HomeIndexModel
    
    static func translate(_ entity: Input) -> Output {
        var stepsModel: [StepModel] = []
        var tasksModel: [[TaskModel]] = []
        let tsModel: [TaskModel] = []
        for step in entity.steps.enumerated() {
            stepsModel.append(StepTranslator.translate(step.element))
            tasksModel.append(tsModel)
            for task in step.element.tasks.enumerated() {
                tasksModel[step.offset].append(TaskTranslator.translate(task.element))
            }
        }
        return HomeIndexModel(
            uid: entity.uid,
            goal: GoalTranslator.translate(entity),
            steps: stepsModel,
            tasks: tasksModel,
            private: entity.private,
            createdAt: entity.createdAt,
            updatedAt: entity.updatedAt
        )
    }
    
    static func translateForModel(_ entity: GoalModel) -> Output {
        var stepsModel: [StepModel] = []
        var tasksModel: [[TaskModel]] = []
        let tsModel: [TaskModel] = []
        for step in entity.steps.enumerated() {
            stepsModel.append(StepTranslator.translateForModel(step.element))
            tasksModel.append(tsModel)
            for task in step.element.tasks.enumerated() {
                tasksModel[step.offset].append(TaskTranslator.translateForModel(task.element))
            }
        }
        return HomeIndexModel(
            uid: entity.uid,
            goal: entity,
            steps: stepsModel,
            tasks: tasksModel,
            private: entity.private,
            createdAt: entity.createdAt,
            updatedAt: entity.updatedAt
        )
    }
}
