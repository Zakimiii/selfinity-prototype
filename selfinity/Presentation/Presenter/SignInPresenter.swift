//
//  SignInPresenter.swift
//  selfinity
//
//  Created by Apple on 2018/10/13.
//  Copyright © 2018年 Apple. All rights reserved.
//

import UIKit
import Foundation
import RxSwift
import RxCocoa
import Foundation

protocol SignInPresenter: class {
    func didTapSignInButton(name: String, email: String, password: String)
}

protocol SignInPresenterInput: class {
    func endAuth()
    func failAuth()
}

final class SignInPresenterImpl: SignInPresenter {
    
    fileprivate let useCase: UserUseCase
    fileprivate let wireframe: SignInWireframe
    fileprivate weak var viewController: SignInPresenterInput?
    
    init(useCase: UserUseCase, wireframe: SignInWireframe) {
        self.useCase   = useCase
        self.wireframe = wireframe
    }
    
    func inject(viewController: SignInPresenterInput) {
        self.viewController = viewController
    }
    
    func didTapSignInButton(name: String, email: String, password: String) {
        self.useCase.signin(name: name, email: email, password: password)
    }
}

extension SignInPresenterImpl: UserUseCasePresentationInput {
    func useCase(_ useCase: UserUseCase, didSigninUser user: UserModel?) {
        guard user != nil else {
            self.viewController?.failAuth()
            return
        }
        self.viewController?.endAuth()
    }
    
    func onError() {
        self.viewController?.failAuth()
    }
}

