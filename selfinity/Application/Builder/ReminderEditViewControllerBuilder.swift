




//
//  ReminderEditViewControllerBuilder.swift
//  selfinity
//
//  Created by Apple on 2018/10/21.
//  Copyright © 2018年 Apple. All rights reserved.
//

import UIKit

struct ReminderEditViewControllerBuilder: ViewControllerBuilder {
    typealias ViewController = ReminderEditViewController
    
    static func build() -> ViewController {
        let viewController = ReminderEditViewController()
        let dataStore      = ReminderDataStoreImpl()
        let repository     = ReminderRepositoryImpl(dataStore: dataStore)
        let useCase        = ReminderUseCaseImpl(repository: repository)
        let presenter      = ReminderEditPresenterImpl(useCase: useCase, wireframe: ReminderEditWireframe(viewController: viewController))
        
        dataStore.inject(repository: repository)
        repository.inject(useCase: useCase)
        useCase.inject(presenter: presenter)
        presenter.inject(viewController: viewController)
        viewController.inject(presenter: presenter)
        
        return viewController
    }
    
    static func rebuild(_ viewController: ReminderEditViewController) {
        let dataStore      = ReminderDataStoreImpl()
        let repository     = ReminderRepositoryImpl(dataStore: dataStore)
        let useCase        = ReminderUseCaseImpl(repository: repository)
        let presenter      = ReminderEditPresenterImpl(useCase: useCase, wireframe: ReminderEditWireframe(viewController: viewController))
        
        dataStore.inject(repository: repository)
        repository.inject(useCase: useCase)
        useCase.inject(presenter: presenter)
        presenter.inject(viewController: viewController)
        viewController.inject(presenter: presenter)
    }
}

