//
//  HomePresenter.swift
//  selfinity
//
//  Created by Apple on 2018/10/12.
//  Copyright © 2018年 Apple. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

import Foundation

protocol HomePresenter: class {
    func index()
    func bind()
    func unbind()
}

protocol HomePresenterInput: class {
    func index( didFetchRepositories repositories: HomeIndexesModel)
    func onErrorIndex()
    func showLoadingView()
    func hideLoadingView()
}

final class HomePresenterImpl: HomePresenter {
    fileprivate let useCase: HomeUseCase
    fileprivate let wireframe: HomeWireframe
    fileprivate weak var viewController: HomePresenterInput?
    
    init(useCase: HomeUseCase, wireframe: HomeWireframe) {
        self.useCase   = useCase
        self.wireframe = wireframe
    }
    
    func inject(viewController: HomePresenterInput) {
        self.viewController = viewController
    }
    
    func index() {
        self.useCase.index()
    }
    
    func bind() {
        self.viewController?.showLoadingView()
    }
    
    func unbind() {
        self.viewController?.hideLoadingView()
    }
}

extension HomePresenterImpl: HomeUseCasePresentationInput {
    func onError() {
        self.viewController?.onErrorIndex()
    }
    
    func useCase(_ useCase: HomeUseCase, didFetchRepositories repositories: HomeIndexesModel) {
        self.viewController?.index(didFetchRepositories: repositories)
    }
}
