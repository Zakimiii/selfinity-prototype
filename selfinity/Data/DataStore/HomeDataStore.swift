//
//  HomeDataStore.swift
//  selfinity
//
//  Created by Apple on 2018/10/12.
//  Copyright © 2018年 Apple. All rights reserved.
//

import UIKit
import Foundation
import Alamofire
import SwiftyJSON
import RxCocoa
import RxSwift
import Firebase

protocol HomeDataStore: class { }

final class HomeDataStoreImpl: HomeDataStore {
    fileprivate weak var repository: HomeRepository?
    
    func inject(repository: HomeRepository) {
        self.repository = repository
    }
}

extension HomeDataStoreImpl: HomeRepositoryInput {
    
    func index() -> Observable<GoalsEntity> {
        var goals = GoalsEntity()
        let ref = Database.database().reference()
        ref.keepSynced(true)
        return Observable.create { observer in
            ref.child("user-goals").child(Firebase.Auth.auth().currentUser!.uid).observe(.value) { (snapshot, error) in
                if let e = error as? Error {
                    print(e.localizedDescription)
                    observer.onError(e)
                    return
                }
                for child in snapshot.children {
                    guard let unwrappedChild = child as? DataSnapshot else {
                        observer.onError(Exception.server)
                        return
                    }
                    print(child)
                    goals.items.append(GoalEntity(snapshot: unwrappedChild))
                }
                observer.onNext(goals)
                observer.onCompleted()
            }
            return Disposables.create()
        }
    }
    
    func create(goalEntity: GoalModel) -> Observable<GoalModel> {
        return Observable.create { observer in
            let ref = Database.database().reference()
            ref.keepSynced(true)
            guard let user = CurrentPrunedUser.getCurrentPrunedUserModel() else {
                observer.onError(Exception.network)
                return Disposables.create()
            }
            let postPrunedUser = ["uid": user.uid,
                                  "displayName": user.displayName,
                                  "credit": String(describing: user.credit),
                                  "sumCredit": String(describing: user.sumCredit),
                                  "profileImage": String(describing: user.profileImage),
                                  "backgroundImage": String(describing: user.backgroundImage),
                                  "registrationConfirmed": String(describing: user.registrationConfirmed),
                                  "permissions": String(describing: user.permissions),
                                  "private": String(describing: user.private),
                                  "createdAt": String(describing: user.createdAt),
                                  "updatedAt": String(describing: user.updatedAt)
            ]
            
            let postGoalSmart = ["uid": goalEntity.smart.uid,
                                  "specificSubject": goalEntity.smart.specificSubject,
                                  "specificVerb": goalEntity.smart.specificVerb,
                                  "measurable": goalEntity.smart.measurable,
                                  "timeBound": goalEntity.smart.timeBound,
                                  "owner": postPrunedUser,
                                  "private": String(describing: goalEntity.smart.private),
                                  "createdAt": String(describing: goalEntity.smart.createdAt),
                                  "updatedAt": String(describing: goalEntity.smart.updatedAt)
            ] as [String : Any]
            
            var postTasks: [[[String : Any]]] = []
            var postSteps: [[String : Any]] = []
            for step in goalEntity.steps.enumerated() {
                postTasks.append([])
                for task in step.element.tasks.enumerated() {
                    let taskKey = task.element.uid
                    
                    let postTaskSmart = ["uid": task.element.smart.uid,
                                         "specificSubject": task.element.smart.specificSubject,
                                         "specificVerb": task.element.smart.specificVerb,
                                         "measurable": task.element.smart.measurable,
                                         "timeBound": task.element.smart.timeBound,
                                         "owner": postPrunedUser,
                                         "private": String(describing: task.element.smart.private),
                                         "createdAt": String(describing: task.element.smart.createdAt),
                                         "updatedAt": String(describing: task.element.smart.updatedAt)
                        ] as [String : Any]
                    
                    let postTask = ["uid": taskKey,
                                    "text": task.element.text,
                                    "credit": String(describing: task.element.credit),
                                    "owner": postPrunedUser,
                                    "smart": postTaskSmart,
                                    "private": "false",
                                    "createdAt": String(describing: Date.CurrentDate()),
                                    "updatedAt": String(describing: Date.CurrentDate())] as [String : Any]
                    postTasks[step.offset].append(postTask)
                    ref.child("tasks").child("\(taskKey)").setValue(postTask)
                    
                }
                let stepKey = step.element.uid
                
                let postStepSmart = ["uid": step.element.smart.uid,
                                     "specificSubject": step.element.smart.specificSubject,
                                     "specificVerb": step.element.smart.specificVerb,
                                     "measurable": step.element.smart.measurable,
                                     "timeBound": step.element.smart.timeBound,
                                     "owner": postPrunedUser,
                                     "private": String(describing: step.element.smart.private),
                                     "createdAt": String(describing: step.element.smart.createdAt),
                                     "updatedAt": String(describing: step.element.smart.updatedAt)
                    ] as [String : Any]
                
                let postStep = ["uid": stepKey,
                                "text": step.element.text,
                                "credit": String(describing: step.element.credit),
                                "tasks": postTasks[step.offset],
                                "owner": postPrunedUser,
                                "smart": postStepSmart,
                                "private": "false",
                                "createdAt": String(describing: Date.CurrentDate()),
                                "updatedAt": String(describing: Date.CurrentDate())] as [String : Any]
                postSteps.append(postStep)
                ref.child("steps").child("\(stepKey)").setValue(postStep)
            }
            let key = goalEntity.uid
            let postGoal = ["uid": key,
                        "text": goalEntity.text,
                        "credit": String(describing: goalEntity.credit),
                        "steps": postSteps,
                        "owner": postPrunedUser,
                        "smart": postGoalSmart,
                        "private": "false",
                        "createdAt": String(describing: Date.CurrentDate()),
                        "updatedAt": String(describing: Date.CurrentDate())] as [String : Any]
            ref.child("user-goals").child("\(user.uid)").child("\(key)").setValue(postGoal)
            ref.child("goals").child("\(key)").setValue(postGoal)
            
            observer.onNext(goalEntity)
            observer.onCompleted()
            return Disposables.create()
        }
    }
    
    func read() {
    }
    func update() {
    }
    func delete() {
    }
}
