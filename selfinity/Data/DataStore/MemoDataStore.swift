//
//  MemoDataStore.swift
//  selfinity
//
//  Created by Apple on 2018/10/16.
//  Copyright © 2018年 Apple. All rights reserved.
//


import UIKit
import Foundation
import Alamofire
import SwiftyJSON
import RxCocoa
import RxSwift
import Firebase

protocol MemoDataStore: class { }

final class MemoDataStoreImpl: MemoDataStore {
    fileprivate weak var repository: MemoRepository?
    
    func inject(repository: MemoRepository) {
        self.repository = repository
    }
}

extension MemoDataStoreImpl: MemoRepositoryInput {
    
    func index() -> Observable<FoldersEntity> {
        var folders = [FolderEntity]()
        return Observable.create { observer in
            let ref = Database.database().reference()
            ref.keepSynced(true)
            ref.child("user-folders").child(Firebase.Auth.auth().currentUser!.uid).observe(.value) { (snapshot, error) in
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
                    folders.append(FolderEntity(snapshot: unwrappedChild))
                }
                observer.onNext(FoldersEntity(items: folders))
                observer.onCompleted()
            }
            return Disposables.create()
        }
    }
    
    func createFolder(title: String) -> Observable<FolderEntity> {
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
            
            let folderKey = ref.childByAutoId().key!
            let postFolder = ["uid": folderKey,
                              "title": title,
                              "owner": postPrunedUser,
                              //"files": "",
                "private": "false",
                "createdAt": String(describing: Date.CurrentDate()),
                "updatedAt": String(describing: Date.CurrentDate())] as [String : Any]
            
            ref.child("user-folders").child("\(user.uid)").child("\(folderKey)").setValue(postFolder)
            ref.child("folders").child("\(folderKey)").setValue(postFolder)
            var folder = FolderEntity.init()
            folder.uid = folderKey
            folder.title = title
            folder.owner = CurrentPrunedUser.getCurrentPrunedUserEntity()!
            //folder.createdAt = Constant.getNowClockString().getDate()!
            //folder.updatedAt = Constant.getNowClockString().getDate()!
            observer.onNext(folder)
            return Disposables.create()
        }
    }
    
    func createMemo(title: String, text: String, html: String, folderUid: String, folderTitle: String) -> Observable<FileEntity> {
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
            
            let fileKey = ref.childByAutoId().key!
            let postFile = ["uid": fileKey,
                            "folderUid": folderUid,
                            "folderTitle": folderTitle,
                            "title": title,
                            "text": text,
                            "html": html,
                            "owner": postPrunedUser,
                            "private": "false",
                            "createdAt": String(describing: Date.CurrentDate()),
                            "updatedAt": String(describing: Date.CurrentDate())] as [String : Any]
            
            ref.child("user-folders").child("\(user.uid)").child("\(folderUid)").child("files").child("\(fileKey)").setValue(postFile)
            ref.child("user-files").child("\(user.uid)").child("\(fileKey)").setValue(postFile)
            ref.child("folders").child("\(folderUid)").child("files").child("\(fileKey)").setValue(postFile)
            ref.child("files").child("\(fileKey)").setValue(postFile)
            
            var file = FileEntity()
            file.uid = fileKey
            file.folderTitle = folderTitle
            file.folderUid = folderUid
            file.title = title
            file.text = text
            file.html = html
            observer.onNext(file)
            
            return Disposables.create()
        }
    }
    
    func updateFile(fileModel: FileModel, folderUid: String, folderTitle: String) -> Observable<FileEntity> {
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
            
            let fileKey = fileModel.uid
            let postFile = ["uid": fileKey,
                            "folderUid": fileModel.folderUid,
                            "folderTitle": fileModel.folderTitle,
                            "title": fileModel.title,
                            "text": fileModel.text,
                            "html": fileModel.html,
                            "owner": postPrunedUser,
                            "private": "\(fileModel.private)",
                            "createdAt": String(describing: Date.CurrentDate()),
                            "updatedAt": String(describing: Date.CurrentDate())] as [String : Any]
            
            ref.child("user-folders").child("\(user.uid)").child("\(folderUid)").child("files").child("\(fileKey)").setValue(postFile)
            ref.child("user-files").child("\(user.uid)").child("\(fileKey)").setValue(postFile)
            ref.child("folders").child("\(folderUid)").child("files").child("\(fileKey)").setValue(postFile)
            ref.child("files").child("\(fileKey)").setValue(postFile)
            
            var file = FileEntity()
            file.uid = fileKey
            file.folderTitle = folderTitle
            file.folderUid = folderUid
            file.title = fileModel.title
            file.text = fileModel.text
            file.html = fileModel.html
            observer.onNext(file)
            
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
