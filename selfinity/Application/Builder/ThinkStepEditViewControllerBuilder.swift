//
//  ThinkStepEditViewControllerBuilder.swift
//  selfinity
//
//  Created by Apple on 2018/10/19.
//  Copyright © 2018年 Apple. All rights reserved.
//

import UIKit

struct ThinkStepEditViewControllerBuilder: ViewControllerBuilder {
    typealias ViewController = ThinkStepEditViewController
    
    static func build() -> ViewController {
        let viewController = ThinkStepEditViewController()
        let dataStore      = HomeDataStoreImpl()
        let repository     = HomeRepositoryImpl(dataStore: dataStore)
        let useCase        = HomeUseCaseImpl(repository: repository)
        let presenter      = ThinkStepEditPresenterImpl(useCase: useCase, wireframe: ThinkStepEditWireframe(viewController: viewController))
        
        dataStore.inject(repository: repository)
        repository.inject(useCase: useCase)
        useCase.inject(presenter: presenter)
        presenter.inject(viewController: viewController)
        viewController.inject(presenter: presenter)
        
        return viewController
    }
    
    static func rebuild(_ viewController: ThinkStepEditViewController) {
        let dataStore      = HomeDataStoreImpl()
        let repository     = HomeRepositoryImpl(dataStore: dataStore)
        let useCase        = HomeUseCaseImpl(repository: repository)
        let presenter      = ThinkStepEditPresenterImpl(useCase: useCase, wireframe: ThinkStepEditWireframe(viewController: viewController))
        
        dataStore.inject(repository: repository)
        repository.inject(useCase: useCase)
        useCase.inject(presenter: presenter)
        presenter.inject(viewController: viewController)
        viewController.inject(presenter: presenter)
    }
}
