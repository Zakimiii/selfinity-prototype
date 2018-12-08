//
//  LabelDataStore.swift
//  selfinity
//
//  Created by Apple on 2018/10/24.
//  Copyright © 2018年 Apple. All rights reserved.
//

import UIKit
import Foundation
import Alamofire
import SwiftyJSON
import RxCocoa
import RxSwift
import Firebase

protocol LabelDataStore: class {
    func index() -> Observable<LabelsEntity>
    func create(repository: LabelModel) -> Observable<LabelModel>
    func create(repositories: LabelsModel) -> Observable<LabelsModel>
}

final class LabelDataStoreImpl: LabelDataStore {
//    fileprivate weak var repository: dRepository?
//
//    func inject(repository: ReminderRepository) {
//        self.repository = repository
//    }
}

extension LabelDataStoreImpl {
    func index() -> Observable<LabelsEntity> {
        var labels = LabelsEntity()
        let ref = Database.database().reference()
        ref.keepSynced(true)
        return Observable.create { observer in
            ref.child("user-labels").child(Firebase.Auth.auth().currentUser!.uid).observe(.value) { (snapshot, error) in
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
                    labels.items.append(LabelEntity(snapshot: unwrappedChild))
                }
                observer.onNext(labels)
                observer.onCompleted()
            }
            return Disposables.create()
        }
    }
    
    func create(repository: LabelModel) -> Observable<LabelModel> {
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
            
            let postLabel = ["uid": repository.uid,
                            "title": repository.title,
                            "tagUid": repository.tagUid,
                            "tagkind": repository.tagkind,
                            "owner": postPrunedUser,
                            "private":  String(describing: repository.private),
                            "createdAt":  String(describing: repository.createdAt),
                            "updateAt":  String(describing: repository.updatedAt)] as [String: Any]
            
            
            //MARK
            ref.child("user-labels").child("\(repository.owner.uid)").child("\(repository.tagUid)").setValue(postLabel)
            ref.child("labels").child("\(repository.tagUid)").setValue(postLabel)
            observer.onNext(repository)
            observer.onCompleted()
            return Disposables.create()
        }
    }
    
    func create(repositories: LabelsModel) -> Observable<LabelsModel> {
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
                
                let postLabel = ["uid": repository.element.uid,
                                    "title": repository.element.title,
                                    "tagUid": repository.element.tagUid,
                                    "tagkind": repository.element.tagkind,
                                    "owner": postPrunedUser,
                                    "private":  String(describing: repository.element.private),
                                    "createdAt":  String(describing: repository.element.createdAt),
                                    "updateAt":  String(describing: repository.element.updatedAt)] as [String: Any]
                
                ref.child("user-labels").child("\(repository.element.owner.uid)").child("\(repository.element.tagUid)").setValue(postLabel)
                ref.child("labels").child("\(repository.element.tagUid)").setValue(postLabel)
            }
            observer.onNext(repositories)
            observer.onCompleted()
            return Disposables.create()
        }
    }
}
