//
//  ThinkNewPresenter.swift
//  selfinity
//
//  Created by Apple on 2018/10/15.
//  Copyright © 2018年 Apple. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

import Foundation

protocol ThinkNewPresenter: class {
}

protocol ThinkNewPresenterInput: class {
}

final class ThinkNewPresenterImpl: ThinkNewPresenter {
    fileprivate let useCase: HomeUseCase
    fileprivate let wireframe: ThinkNewWireframe
    fileprivate weak var viewController: ThinkNewPresenterInput?
    
    init(useCase: HomeUseCase, wireframe: ThinkNewWireframe) {
        self.useCase   = useCase
        self.wireframe = wireframe
    }
    
    func inject(viewController: ThinkNewPresenterInput) {
        self.viewController = viewController
    }
}

extension ThinkNewPresenterImpl: HomeUseCasePresentationInput {
    func onError() {
        //self.viewController?.onErrorIndex()
    }
}
