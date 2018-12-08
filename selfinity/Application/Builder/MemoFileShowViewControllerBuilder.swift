//
//  MemoFileShowViewControllerBuilder.swift
//  selfinity
//
//  Created by Apple on 2018/10/16.
//  Copyright © 2018年 Apple. All rights reserved.
//

import UIKit

struct MemoFileShowViewControllerBuilder: ViewControllerBuilder {
    typealias ViewController = MemoFileShowViewController
    
    static func build() -> ViewController {
        let viewController = MemoFileShowViewController()
        let dataStore      = MemoDataStoreImpl()
        let repository     = MemoRepositoryImpl(dataStore: dataStore)
        let useCase        = MemoUseCaseImpl(repository: repository)
        let presenter      = MemoFileShowPresenterImpl(useCase: useCase, wireframe: MemoFileShowWireframe(viewController: viewController))
        
        dataStore.inject(repository: repository)
        repository.inject(useCase: useCase)
        useCase.inject(presenter: presenter)
        presenter.inject(viewController: viewController)
        viewController.inject(presenter: presenter)
        
        return viewController
    }
    
    static func rebuild(_ viewController: MemoFileShowViewController) {
        let dataStore      = MemoDataStoreImpl()
        let repository     = MemoRepositoryImpl(dataStore: dataStore)
        let useCase        = MemoUseCaseImpl(repository: repository)
        let presenter      = MemoFileShowPresenterImpl(useCase: useCase, wireframe: MemoFileShowWireframe(viewController: viewController))
        
        dataStore.inject(repository: repository)
        repository.inject(useCase: useCase)
        useCase.inject(presenter: presenter)
        presenter.inject(viewController: viewController)
        viewController.inject(presenter: presenter)
    }
}
