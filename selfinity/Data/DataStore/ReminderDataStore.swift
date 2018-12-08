//
//  ReminderDataStore.swift
//  selfinity
//
//  Created by Apple on 2018/10/20.
//  Copyright © 2018年 Apple. All rights reserved.
//

import UIKit
import Foundation
import Alamofire
import SwiftyJSON
import RxCocoa
import RxSwift
import Firebase

protocol ReminderDataStore: class { }

final class ReminderDataStoreImpl: ReminderDataStore {
    fileprivate weak var repository: ReminderRepository?
    
    func inject(repository: ReminderRepository) {
        self.repository = repository
    }
}

extension ReminderDataStoreImpl: ReminderRepositoryInput {
    func index() -> Observable<RemindersEntity> {
        var reminders = RemindersEntity()
        let ref = Database.database().reference()
        ref.keepSynced(true)
        return Observable.create { observer in
            ref.child("user-reminders").child(Firebase.Auth.auth().currentUser!.uid).observe(.value) { (snapshot, error) in
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
                    reminders.items.append(ReminderEntity(snapshot: unwrappedChild))
                }
                observer.onNext(reminders)
                observer.onCompleted()
            }
            return Disposables.create()
        }
    }
    
    func create(repository: ReminderModel) -> Observable<ReminderModel> {
        return Observable.create { observer in
            let ref = Database.database().reference()
            ref.keepSynced(true)
            let postPrunedUser = ["uid": repository.owner.uid,
                                  "displayName": repository.owner.displayName,
                                  "credit": String(describing: repository.owner.credit),
                                  "sumCredit": String(describing: repository.owner.sumCredit),
                                  "profileImage": String(describing: repository.owner.profileImage),
                                  "backgroundImage": String(describing: repository.owner.backgroundImage),
                                  "registrationConfirmed": String(describing: repository.owner.registrationConfirmed),
                                  "permissions": String(describing: repository.owner.permissions),
                                  "private": String(describing: repository.owner.private),
                                  "createdAt": String(describing: repository.owner.createdAt),
                                  "updatedAt": String(describing: repository.owner.updatedAt)
            ]
            
            let postReminder = ["uid": repository.uid,
                                "title": repository.title,
                                "text": repository.text,
                                "span": String(describing: repository.span),
                                "time": String(describing: repository.time),
                                "repeat": String(describing: repository.repeat),
                                "notification": String(describing: repository.notification),
                                "longitude": String(describing: repository.longitude),
                                "latitude": String(describing: repository.latitude),
                                "address": repository.address,
                                "tagUid": repository.tagUid,
                                "tagKind": repository.tagKind,
                                "place": String(describing: repository.place.rawValue),
                                "owner": postPrunedUser,
                                "private":  String(describing: repository.private),
                                "createdAt":  String(describing: repository.createdAt),
                                "updateAt":  String(describing: repository.updatedAt)] as [String: Any]
            
            ref.child("user-reminders").child("\(repository.owner.uid)").child("\(repository.uid)").setValue(postReminder)
            ref.child("reminders").child("\(repository.uid)").setValue(postReminder)
            observer.onNext(repository)
            observer.onCompleted()
            return Disposables.create()
        }
    }
    
    func create(repositories: RemindersModel) -> Observable<RemindersModel> {
        return Observable.create { observer in
            let ref = Database.database().reference()
            ref.keepSynced(true)
            
            for repository in repositories.repositories.enumerated() {
                let postPrunedUser = ["uid": repository.element.owner.uid,
                                      "displayName": repository.element.owner.displayName,
                                      "credit": String(describing: repository.element.owner.credit),
                                      "sumCredit": String(describing: repository.element.owner.sumCredit),
                                      "profileImage": String(describing: repository.element.owner.profileImage),
                                      "backgroundImage": String(describing: repository.element.owner.backgroundImage),
                                      "registrationConfirmed": String(describing: repository.element.owner.registrationConfirmed),
                                      "permissions": String(describing: repository.element.owner.permissions),
                                      "private": String(describing: repository.element.owner.private),
                                      "createdAt": String(describing: repository.element.owner.createdAt),
                                      "updatedAt": String(describing: repository.element.owner.updatedAt)
                ]
                
                let postReminder = ["uid": repository.element.uid,
                                    "title": repository.element.title,
                                    "text": repository.element.text,
                                    "span": String(describing: repository.element.span),
                                    "time": String(describing: repository.element.time),
                                    "repeat": String(describing: repository.element.repeat),
                                    "notification": String(describing: repository.element.notification),
                                    "longitude": String(describing: repository.element.longitude),
                                    "latitude": String(describing: repository.element.latitude),
                                    "address": repository.element.address,
                                    "tagUid": repository.element.tagUid,
                                    "tagKind": repository.element.tagKind,
                                    "place": String(describing: repository.element.place.rawValue),
                                    "owner": postPrunedUser,
                                    "private":  String(describing: repository.element.private),
                                    "createdAt":  String(describing: repository.element.createdAt),
                                    "updateAt":  String(describing: repository.element.updatedAt)] as [String: Any]
                
                ref.child("user-reminders").child("\(repository.element.owner.uid)").child("\(repository.element.uid)").setValue(postReminder)
                ref.child("reminders").child("\(repository.element.uid)").setValue(postReminder)
            }
            observer.onNext(repositories)
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
