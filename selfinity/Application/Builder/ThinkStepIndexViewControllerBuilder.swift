

//
//  ThinkStepIndexViewControllerBuilder.swift
//  selfinity
//
//  Created by Apple on 2018/10/19.
//  Copyright © 2018年 Apple. All rights reserved.
//

import UIKit

struct ThinkStepIndexViewControllerBuilder: ViewControllerBuilder {
    typealias ViewController = ThinkStepIndexViewController
    
    static func build() -> ViewController {
        let viewController = ThinkStepIndexViewController()
        let dataStore      = HomeDataStoreImpl()
        let repository     = HomeRepositoryImpl(dataStore: dataStore)
        let useCase        = HomeUseCaseImpl(repository: repository)
        let presenter      = ThinkStepIndexPresenterImpl(useCase: useCase, wireframe: ThinkStepIndexWireframe(viewController: viewController))
        
        dataStore.inject(repository: repository)
        repository.inject(useCase: useCase)
        useCase.inject(presenter: presenter)
        presenter.inject(viewController: viewController)
        viewController.inject(presenter: presenter)
        
        return viewController
    }
    
    static func rebuild(_ viewController: ThinkStepIndexViewController) {
        let dataStore      = HomeDataStoreImpl()
        let repository     = HomeRepositoryImpl(dataStore: dataStore)
        let useCase        = HomeUseCaseImpl(repository: repository)
        let presenter      = ThinkStepIndexPresenterImpl(useCase: useCase, wireframe: ThinkStepIndexWireframe(viewController: viewController))
        
        dataStore.inject(repository: repository)
        repository.inject(useCase: useCase)
        useCase.inject(presenter: presenter)
        presenter.inject(viewController: viewController)
        viewController.inject(presenter: presenter)
    }
}
