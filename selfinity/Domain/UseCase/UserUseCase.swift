//
//  LogInUseCase.swift
//  selfinity
//
//  Created by Apple on 2018/10/13.
//  Copyright © 2018年 Apple. All rights reserved.
//

import Foundation
import RxSwift

protocol UserUseCase: class {
    func login(_ dataStore: UserRepositoryInput, didLoginUser entity: UserEntity)
    func login(email: String, password: String)
    func signin(_ dataStore: UserRepositoryInput, didSigninUser entity: UserEntity)
    func signin(name: String, email: String, password: String)
    func onError()
}

protocol UserUseCasePresentationInput: class {
    func useCase(_ useCase: UserUseCase, didLoginUser user: UserModel?)
    func useCase(_ useCase: UserUseCase, didSigninUser user: UserModel?)
    func onError()
}

extension UserUseCasePresentationInput {
    func useCase(_ useCase: UserUseCase, didLoginUser user: UserModel?) {}
    func useCase(_ useCase: UserUseCase, didSigninUser user: UserModel?) {}
}

protocol UserUseCaseDataInput: class {
    func login(email: String, password: String)
    func signin(name: String, email: String, password: String)
}

final class UserUseCaseImpl: UserUseCase {
     
    fileprivate let repository: UserUseCaseDataInput
    fileprivate weak var presenter: UserUseCasePresentationInput?
    
    init(repository: UserUseCaseDataInput) {
        self.repository = repository
    }
    
    func inject(presenter: UserUseCasePresentationInput) {
        self.presenter = presenter
    }
    
    func login(email: String, password: String) {
        if !email.isEmpty && !password.isEmpty {
            self.repository.login(email: email, password: password)
        } else {
            self.presenter?.useCase(self, didLoginUser: nil)
        }
    }
    
    func login(_ dataStore: UserRepositoryInput, didLoginUser entity: UserEntity) {
        let repositoryModel = UserTranslator.translate(entity)
        self.presenter?.useCase(self, didLoginUser: repositoryModel)
    }
    
    func signin(_ dataStore: UserRepositoryInput, didSigninUser entity: UserEntity) {
        let repositoryModel = UserTranslator.translate(entity)
        self.presenter?.useCase(self, didSigninUser: repositoryModel)
    }
    
    func signin(name: String, email: String, password: String) {
        if !name.isEmpty ,!email.isEmpty && !password.isEmpty {
            self.repository.signin(name: name, email: email, password: password)
        } else {
            self.presenter?.useCase(self, didSigninUser: nil)
        }
    }
    
    func onError() {
        self.presenter?.onError()
    }
}
