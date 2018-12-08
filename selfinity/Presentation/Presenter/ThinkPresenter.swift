//
//  ThinkPresenter.swift
//  selfinity
//
//  Created by Apple on 2018/10/15.
//  Copyright © 2018年 Apple. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

import Foundation

protocol ThinkPresenter: class {
    func didTapNewThinkCell()
    func didTapGoalThinkCell()
    func didTapStepThinkCell()
    func didTapSearchThinkCell()
}

protocol ThinkPresenterInput: class {
}

final class ThinkPresenterImpl: ThinkPresenter {
    fileprivate let useCase: HomeUseCase
    fileprivate let wireframe: ThinkWireframe
    fileprivate weak var viewController: ThinkPresenterInput?
    
    init(useCase: HomeUseCase, wireframe: ThinkWireframe) {
        self.useCase   = useCase
        self.wireframe = wireframe
    }
    
    func inject(viewController: ThinkPresenterInput) {
        self.viewController = viewController
    }
    
    func didTapNewThinkCell() {
        self.wireframe.toNew()
    }
    
    func didTapGoalThinkCell() {
        self.wireframe.toGoal()
    }
    
    func didTapStepThinkCell() {
        self.wireframe.toStep()
    }
    
    func didTapSearchThinkCell() {
        self.wireframe.toSearch()
    }
}

extension ThinkPresenterImpl: HomeUseCasePresentationInput {
    func onError() {
        //self.viewController?.onErrorIndex()
    }
}
