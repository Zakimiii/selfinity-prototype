//
//  HomeBuilder.swift
//  selfinity
//
//  Created by Apple on 2018/10/12.
//  Copyright © 2018年 Apple. All rights reserved.
//

import UIKit

struct HomeViewControllerBuilder: ViewControllerBuilder {
    typealias ViewController = HomeViewController
    
    static func build() -> ViewController {
        let viewController = HomeViewController()
        let dataStore      = HomeDataStoreImpl()
        let repository     = HomeRepositoryImpl(dataStore: dataStore)
        let useCase        = HomeUseCaseImpl(repository: repository)
        let presenter      = HomePresenterImpl(useCase: useCase, wireframe: HomeWireframe(viewController: viewController))
        
        dataStore.inject(repository: repository)
        repository.inject(useCase: useCase)
        useCase.inject(presenter: presenter)
        presenter.inject(viewController: viewController)
        viewController.inject(presenter: presenter)
        
        return viewController
    }
    
    static func rebuild(_ viewController: HomeViewController) {
        let dataStore      = HomeDataStoreImpl()
        let repository     = HomeRepositoryImpl(dataStore: dataStore)
        let useCase        = HomeUseCaseImpl(repository: repository)
        let presenter      = HomePresenterImpl(useCase: useCase, wireframe: HomeWireframe(viewController: viewController))
        
        dataStore.inject(repository: repository)
        repository.inject(useCase: useCase)
        useCase.inject(presenter: presenter)
        presenter.inject(viewController: viewController)
        viewController.inject(presenter: presenter)
    }
}
