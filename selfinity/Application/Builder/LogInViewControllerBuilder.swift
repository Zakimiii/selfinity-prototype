//
//  LogInViewControllerBuilder.swift
//  selfinity
//
//  Created by Apple on 2018/10/13.
//  Copyright © 2018年 Apple. All rights reserved.
//

import UIKit

class LogInViewControllerBuilder: ViewControllerBuilder {
    typealias ViewController = LogInViewController
    
    static func build() -> ViewController {
        let viewController = LogInViewController()
        let dataStore      = UserDataStoreImpl()
        let repository     = UserRepositoryImpl(dataStore: dataStore)
        let useCase        = UserUseCaseImpl(repository: repository)
        let presenter      = LogInPresenterImpl(useCase: useCase, wireframe: LogInWireframe(viewController: viewController))
        
        dataStore.inject(repository: repository)
        repository.inject(useCase: useCase)
        useCase.inject(presenter: presenter)
        presenter.inject(viewController: viewController)
        viewController.inject(presenter: presenter)
        
        return viewController
    }
    
    static func rebuild(_ viewController: LogInViewController) {
        let dataStore      = UserDataStoreImpl()
        let repository     = UserRepositoryImpl(dataStore: dataStore)
        let useCase        = UserUseCaseImpl(repository: repository)
        let presenter      = LogInPresenterImpl(useCase: useCase, wireframe: LogInWireframe(viewController: viewController))
        
        dataStore.inject(repository: repository)
        repository.inject(useCase: useCase)
        useCase.inject(presenter: presenter)
        presenter.inject(viewController: viewController)
        viewController.inject(presenter: presenter)
    }
}
