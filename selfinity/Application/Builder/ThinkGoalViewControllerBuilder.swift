//
//  ThinkGoalViewControllerBuilder.swift
//  selfinity
//
//  Created by Apple on 2018/10/15.
//  Copyright © 2018年 Apple. All rights reserved.
//

import UIKit

struct ThinkGoalViewControllerBuilder: ViewControllerBuilder {
    typealias ViewController = ThinkGoalViewController
    
    static func build() -> ViewController {
        let viewController = ThinkGoalViewController()
        let dataStore      = HomeDataStoreImpl()
        let repository     = HomeRepositoryImpl(dataStore: dataStore)
        let useCase        = HomeUseCaseImpl(repository: repository)
        let presenter      = ThinkGoalPresenterImpl(useCase: useCase, wireframe: ThinkGoalWireframe(viewController: viewController))
        
        dataStore.inject(repository: repository)
        repository.inject(useCase: useCase)
        useCase.inject(presenter: presenter)
        presenter.inject(viewController: viewController)
        viewController.inject(presenter: presenter)
        
        return viewController
    }
    
    static func rebuild(_ viewController: ThinkGoalViewController) {
        let dataStore      = HomeDataStoreImpl()
        let repository     = HomeRepositoryImpl(dataStore: dataStore)
        let useCase        = HomeUseCaseImpl(repository: repository)
        let presenter      = ThinkGoalPresenterImpl(useCase: useCase, wireframe: ThinkGoalWireframe(viewController: viewController))
        
        dataStore.inject(repository: repository)
        repository.inject(useCase: useCase)
        useCase.inject(presenter: presenter)
        presenter.inject(viewController: viewController)
        viewController.inject(presenter: presenter)
    }
}
