//
//  LogInPresenter.swift
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

protocol LogInPresenter: class {
    func didTapLogInButton(email: String, password: String)
}

protocol LogInPresenterInput: class {
    func endAuth()
    func failAuth()
}

final class LogInPresenterImpl: LogInPresenter {
    
    fileprivate let useCase: UserUseCase
    fileprivate let wireframe: LogInWireframe
    fileprivate weak var viewController: LogInPresenterInput?
    
    init(useCase: UserUseCase, wireframe: LogInWireframe) {
        self.useCase   = useCase
        self.wireframe = wireframe
    }
    
    func inject(viewController: LogInPresenterInput) {
        self.viewController = viewController
    }
    
    func didTapLogInButton(email: String, password: String) {
        self.useCase.login(email: email, password: password)
    }
}

extension LogInPresenterImpl: UserUseCasePresentationInput {
    func useCase(_ useCase: UserUseCase, didLoginUser user: UserModel?) {
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
