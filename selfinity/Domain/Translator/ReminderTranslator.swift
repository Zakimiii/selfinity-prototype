
//
//  ReminderTranslator.swift
//  selfinity
//
//  Created by Apple on 2018/10/20.
//  Copyright © 2018年 Apple. All rights reserved.
//

import Foundation
import Firebase

final class RemindersTranslator: Translator {
    typealias Input  = RemindersEntity
    typealias Output = RemindersModel
    
    static func translate(_ entity: Input) -> Output {
        let repositories: [ReminderModel] = entity.items.map {
            ReminderTranslator.translate($0)
        }
        
        return RemindersModel(repositories: repositories)
    }
}

final class ReminderTranslator: Translator {
    typealias Input  = ReminderEntity
    typealias Output = ReminderModel
    
    static func translate(_ entity: Input) -> Output {
        return ReminderModel(
            uid: entity.uid,
            title: entity.title,
            text: entity.text,
            time: entity.time,
            span: entity.span,
            repeat: entity.repeat,
            notification: entity.notification,
            longitude: entity.longitude,
            latitude: entity.latitude,
            address: entity.address,
            tagUid: entity.tagUid,
            tagKind: entity.tagKind,
            place: Place(rawValue: entity.place)!,
            owner: UserToPrunedTranslator.translate(Firebase.Auth.auth().currentUser?.uid ?? ""),
            private: entity.private,
            createdAt: entity.createdAt,
            updatedAt: entity.updatedAt
        )
    }
    
    static func translateFromGoal(_ entity: GoalModel) -> RemindersModel {
        var reminders = RemindersModel()
        reminders.repositories.append(ReminderModel(
            uid: NSUUID().uuidString,
            title: entity.text,
            text: ""/*entity.text*/,
            time: entity.smart.timeBound.getDate() ?? Date.CurrentDate(),
            span: 60 /*Int(entity.smart.measurable)*/,
            repeat: 0,
            notification: true,
            longitude: 0,
            latitude: 0,
            address: "",
            tagUid: entity.uid,
            tagKind: Tag.goal.rawValue,
            place: Place.empty,
            owner: entity.owner,
            private: entity.private,
            createdAt: entity.createdAt,
            updatedAt: entity.updatedAt
            )
        )
        for step in entity.steps.enumerated() {
            for task in step.element.tasks.enumerated() {
                reminders.repositories.append(ReminderModel(
                    uid: NSUUID().uuidString,
                    title: task.element.text,
                    text: ""/*entity.text*/,
                    time: task.element.smart.timeBound.getDate() ?? Date.CurrentDate(),
                    span: 60,
                    repeat: 0,
                    notification: true,
                    longitude: 0,
                    latitude: 0,
                    address: "",
                    tagUid: task.element.uid,
                    tagKind: Tag.task.rawValue,
                    place: Place.empty,
                    owner: task.element.owner,
                    private: task.element.private,
                    createdAt: task.element.createdAt,
                    updatedAt: task.element.updatedAt
                    )
                )
            }
            reminders.repositories.append(ReminderModel(
                uid: NSUUID().uuidString,
                title: step.element.text,
                text: ""/*entity.text*/,
                time: step.element.smart.timeBound.getDate() ?? Date.CurrentDate(),
                span: 60,
                repeat: 0,
                notification: true,
                longitude: 0,
                latitude: 0,
                address: "",
                tagUid: step.element.uid,
                tagKind: Tag.step.rawValue,
                place: Place.empty,
                owner: step.element.owner,
                private: step.element.private,
                createdAt: step.element.createdAt,
                updatedAt: step.element.updatedAt
            ))
        }
        return reminders
    }
}
