//
//  UserRepository.swift
//  selfinity
//
//  Created by Apple on 2018/10/13.
//  Copyright © 2018年 Apple. All rights reserved.
//

import UIKit
import Foundation
import RxSwift
import RxCocoa
import Firebase

protocol UserRepository: class {
}

protocol UserRepositoryInput: class {
    func checkLogin() -> Observable<Bool>
    func signUp(name: String, email: String, password: String) -> Observable<UserEntity>
    func sendEmailVerification() -> Observable<Void>
    func login(email: String, password: String) -> Observable<UserEntity>
    func fetchPrunedUser()
}

final class UserRepositoryImpl: UserRepository {
    fileprivate let dataStore: UserRepositoryInput
    fileprivate weak var useCase: UserUseCase?
    fileprivate let disposeBag = DisposeBag()
    
    init(dataStore: UserRepositoryInput) {
        self.dataStore = dataStore
    }
    
    func inject(useCase: UserUseCase) {
        self.useCase = useCase
    }
    
    func dataStore(_ dataStore: UserRepositoryInput, didLogInUser entity: UserEntity) {
        self.useCase?.login(self.dataStore, didLoginUser: entity)
    }
    
    func dataStore(_ dataStore: UserRepositoryInput, didSignInUser entity: UserEntity) {
        self.useCase?.signin(self.dataStore, didSigninUser: entity)
    }
    
    func onErrorDataStore(_ dataStore: UserRepositoryInput) {
        self.useCase?.onError()
    }
}

extension UserRepositoryImpl: UserUseCaseDataInput {
    func login(email: String, password: String) {
        self.dataStore.login(email: email, password: password).subscribe(onNext: { response in
            self.dataStore(self.dataStore, didLogInUser: response)
            self.dataStore.fetchPrunedUser()
        }, onError: { error in
            self.onErrorDataStore(self.dataStore)
        }).disposed(by: self.disposeBag)
    }
    
    func signin(name: String, email: String, password: String) {
        self.dataStore.signUp(name: name, email: email, password: password).subscribe(onNext: { response in
            self.dataStore(self.dataStore, didSignInUser: response)
        }, onError: { error in
            self.onErrorDataStore(self.dataStore)
        }).disposed(by: self.disposeBag)
    }
}
