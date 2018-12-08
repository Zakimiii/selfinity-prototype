//
//  SignInViewControllerBuilder.swift
//  selfinity
//
//  Created by Apple on 2018/10/13.
//  Copyright © 2018年 Apple. All rights reserved.
//

import UIKit

class SignInViewControllerBuilder: ViewControllerBuilder {
    typealias ViewController = SignUpViewController
    
    static func build() -> ViewController {
        let viewController = SignUpViewController()
        let dataStore      = UserDataStoreImpl()
        let repository     = UserRepositoryImpl(dataStore: dataStore)
        let useCase        = UserUseCaseImpl(repository: repository)
        let presenter      = SignInPresenterImpl(useCase: useCase, wireframe: SignInWireframe(viewController: viewController))
        
        dataStore.inject(repository: repository)
        repository.inject(useCase: useCase)
        useCase.inject(presenter: presenter)
        presenter.inject(viewController: viewController)
        viewController.inject(presenter: presenter)
        
        return viewController
    }
    
    static func rebuild(_ viewController: SignUpViewController) {
        let dataStore      = UserDataStoreImpl()
        let repository     = UserRepositoryImpl(dataStore: dataStore)
        let useCase        = UserUseCaseImpl(repository: repository)
        let presenter      = SignInPresenterImpl(useCase: useCase, wireframe: SignInWireframe(viewController: viewController))
        
        dataStore.inject(repository: repository)
        repository.inject(useCase: useCase)
        useCase.inject(presenter: presenter)
        presenter.inject(viewController: viewController)
        viewController.inject(presenter: presenter)
    }
}
