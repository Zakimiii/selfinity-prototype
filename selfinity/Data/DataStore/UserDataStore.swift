//
//  UserDataStore.swift
//  selfinity
//
//  Created by Apple on 2018/10/13.
//  Copyright © 2018年 Apple. All rights reserved.
//

import UIKit
import Foundation
import Alamofire
import SwiftyJSON
import RxCocoa
import RxSwift
import Firebase
import SwiftDate
import SDWebImage
protocol UserDataStore: class { }

final class UserDataStoreImpl: UserDataStore {
    fileprivate weak var repository: UserRepository?
    
    func inject(repository: UserRepository) {
        self.repository = repository
    }
}

extension UserDataStoreImpl: UserRepositoryInput, CurrentPrunedUserProtocol {
    
    func checkLogin() -> Observable<Bool> {
        return Observable.create { observer in
            if Auth.auth().currentUser != nil {
                observer.onNext(true)
            } else {
                observer.onNext(false)
            }
            return Disposables.create()
        }
    }
    
    func signUp(name: String, email: String, password: String) -> Observable<UserEntity> {
        return Observable.create { observer in
            Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
                if let e = error {
                    print(e.localizedDescription)
                    observer.onError(e)
                    return
                }
                guard let user = user else {
                    observer.onError(Exception.auth)
                    return
                }
                let ref = Database.database().reference()
                ref.keepSynced(true)
                let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
                changeRequest?.displayName = name
                changeRequest?.commitChanges { (error) in
                    if let e = error {
                        print(e.localizedDescription)
                        observer.onError(e)
                        return
                    }
                }
//                let uid = ref.childByAutoId().key!
                
                let postPrunedUser = ["uid": user.user.uid,
                                      "credit": String(describing: 0),
                                      "sumCredit": String(describing: 0),
                                      "displayName": name,
                                      "profileImage": "",
                                      "backgroundImage": "",
                                      "registrationConfirmed": "false",
                                      "permissions": "true",
                                      "private": "false",
                                      "createdAt": "\(Constant.getNowClockString())",
                                      "updatedAt": "\(Constant.getNowClockString())"
                    ]
                ref.child("prunedUsers").child("\(user.user.uid)").setValue(postPrunedUser)
                //MARK:: childrenするときの構造に注意！！！！！
                ref.child("user-prunedUsers").child(user.user.uid).child("\(user.user.uid)").setValue(postPrunedUser)
                
                var prunedUserEntity = PrunedUserEntity()
                prunedUserEntity.uid = user.user.uid
                prunedUserEntity.displayName = name
                prunedUserEntity.credit = 0
                prunedUserEntity.sumCredit = 0
                prunedUserEntity.permissions = true
                prunedUserEntity.createdAt = Date.CurrentDate()
                prunedUserEntity.updatedAt = Date.CurrentDate()
                self.setCurrentPrunedUser(enitity: prunedUserEntity)
                
                var userEntity = UserEntity()
                userEntity.uid = user.user.uid
                userEntity.providerID = user.user.providerID
                userEntity.displayName = user.user.displayName ?? ""
                userEntity.phoneNumber = user.user.phoneNumber ?? ""
                userEntity.photoURL = user.user.photoURL as NSURL? ?? NSURL()
                userEntity.email = user.user.email ?? ""
                observer.onNext(userEntity)
            }
            return Disposables.create()
        }
    }
    
    func sendEmailVerification() -> Observable<Void> {
        return Observable.create { observer in
            guard let user = Auth.auth().currentUser else {
                observer.onError(Exception.auth)
                return Disposables.create()
            }
            user.sendEmailVerification() { error in
                if let e = error {
                    print(e.localizedDescription)
                    observer.onError(e)
                    return
                }
                observer.onNext(())
            }
            return Disposables.create()
        }
    }
    
    func login(email: String, password: String) -> Observable<UserEntity> {
        return Observable.create { observer in
            Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
                if let e = error {
                    print(e.localizedDescription)
                    observer.onError(e)
                    return
                }
                guard let user = user else {
                    observer.onError(Exception.auth)
                    return
                }
                var userEntity = UserEntity()
                userEntity.uid = user.user.uid
                userEntity.providerID = user.user.providerID
                userEntity.displayName = user.user.displayName ?? ""
                userEntity.phoneNumber = user.user.phoneNumber ?? ""
                userEntity.photoURL = user.user.photoURL as NSURL? ?? NSURL()
                userEntity.email = user.user.email ?? ""
                observer.onNext(userEntity)
            }
            return Disposables.create()
        }
    }
    
    func fetchPrunedUser() {
        let ref = Database.database().reference()
        ref.keepSynced(true)
        ref.child("user-prunedUsers").child(Firebase.Auth.auth().currentUser!.uid).observe(.value) { (snapshot, error) in
            if let e = error as? Error {
                print(e.localizedDescription)
                return
            }
            for child in snapshot.children {
                guard let unwrappedChild = child as? DataSnapshot else {
                    return
                }
                var prunedUser =  PrunedUserEntity(snapshot: unwrappedChild)
                prunedUser.uid = Firebase.Auth.auth().currentUser!.uid
                self.setCurrentPrunedUser(enitity: prunedUser)
            }
        }
    }
}
