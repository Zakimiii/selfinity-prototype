//
//  ThinkStepPresenter.swift
//  selfinity
//
//  Created by Apple on 2018/10/15.
//  Copyright © 2018年 Apple. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

import Foundation

protocol ThinkStepPresenter: class {
    func preIndex()
    func bind()
    func unbind()
    func toEdit()
}

protocol ThinkStepPresenterInput: class {
    func preIndex( didFetchRepository repository: GoalModel)
    func onErrorIndex()
    func showLoadingView()
    func hideLoadingView()
}

final class ThinkStepPresenterImpl: ThinkStepPresenter {
    fileprivate let useCase: HomeUseCase
    fileprivate let wireframe: ThinkStepWireframe
    fileprivate weak var viewController: ThinkStepPresenterInput?
    
    init(useCase: HomeUseCase, wireframe: ThinkStepWireframe) {
        self.useCase   = useCase
        self.wireframe = wireframe
    }
    
    func inject(viewController: ThinkStepPresenterInput) {
        self.viewController = viewController
    }
    
    func preIndex() {
        self.viewController?.preIndex(didFetchRepository: GoalModel.init(
            uid: NSUUID().uuidString,
            text: "",
            credit: 0,
            steps: [/*StepModel.init(uid: NSUUID().uuidString,
                                   text: "",
                                   smart: SmartModel.init(uid: NSUUID().uuidString,
                                                          specificSubject: "",
                                                          specificVerb: "",
                                                          timeBound: "",
                                                          measurable: "",
                                                          owner: CurrentPrunedUser.getToCurrentPrunedUserModel()!,
                                                          private: false,
                                                          createdAt: Date(),
                                                          updatedAt: Date()),
                                   tasks: [],
                                   owner: CurrentPrunedUser.getToCurrentPrunedUserModel()!,
                                   private: false,
                                   createdAt: Date(),
                                   updatedAt: Date())*/
            ],
            smart: SmartModel.init(uid: NSUUID().uuidString,
                                   specificSubject: "",
                                   specificVerb: "",
                                   timeBound: "",
                                   measurable: "",
                                   owner: CurrentPrunedUser.getToCurrentPrunedUserModel()!,
                                   private: false,
                                   createdAt: Date.CurrentDate(),
                                   updatedAt: Date.CurrentDate()),
            owner: CurrentPrunedUser.getToCurrentPrunedUserModel()!,
            private: false,
            createdAt: Date.CurrentDate(),
            updatedAt: Date.CurrentDate())
        )
    }
    
    func bind() {
        self.viewController?.showLoadingView()
    }
    
    func unbind() {
        self.viewController?.hideLoadingView()
    }
    
    func toEdit() {
        self.wireframe.toEdit()
    }
}

extension ThinkStepPresenterImpl: HomeUseCasePresentationInput {
    func onError() {
        self.viewController?.onErrorIndex()
    }
}
