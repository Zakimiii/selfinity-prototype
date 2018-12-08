

//
//  ThinkTaskCreateViewControllerBuilder.swift
//  selfinity
//
//  Created by Apple on 2018/10/19.
//  Copyright © 2018年 Apple. All rights reserved.
//

import UIKit

struct ThinkTaskCreateViewControllerBuilder: ViewControllerBuilder {
    typealias ViewController = ThinkTaskCreateViewController
    
    static func build() -> ViewController {
        let viewController = ThinkTaskCreateViewController()
        let dataStore      = HomeDataStoreImpl()
        let repository     = HomeRepositoryImpl(dataStore: dataStore)
        let useCase        = HomeUseCaseImpl(repository: repository)
        let presenter      = ThinkTaskCreatePresenterImpl(useCase: useCase, wireframe: ThinkTaskCreateWireframe(viewController: viewController))
        
        dataStore.inject(repository: repository)
        repository.inject(useCase: useCase)
        useCase.inject(presenter: presenter)
        presenter.inject(viewController: viewController)
        viewController.inject(presenter: presenter)
        
        return viewController
    }
    
    static func rebuild(_ viewController: ThinkTaskCreateViewController) {
        let dataStore      = HomeDataStoreImpl()
        let repository     = HomeRepositoryImpl(dataStore: dataStore)
        let useCase        = HomeUseCaseImpl(repository: repository)
        let presenter      = ThinkTaskCreatePresenterImpl(useCase: useCase, wireframe: ThinkTaskCreateWireframe(viewController: viewController))
        
        dataStore.inject(repository: repository)
        repository.inject(useCase: useCase)
        useCase.inject(presenter: presenter)
        presenter.inject(viewController: viewController)
        viewController.inject(presenter: presenter)
    }
}
