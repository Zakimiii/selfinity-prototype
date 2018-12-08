//
//  ThinkGoalPresenter.swift
//  selfinity
//
//  Created by Apple on 2018/10/15.
//  Copyright © 2018年 Apple. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import Firebase

protocol ThinkGoalPresenter: class {
    func preIndex()
    func bind()
    func unbind()
}

protocol ThinkGoalPresenterInput: class {
    func preIndex(didFetchRepository repository: GoalModel)
    func onErrorIndex()
    func showLoadingView()
    func hideLoadingView()
}

final class ThinkGoalPresenterImpl: ThinkGoalPresenter {
    fileprivate let useCase: HomeUseCase
    fileprivate let wireframe: ThinkGoalWireframe
    fileprivate weak var viewController: ThinkGoalPresenterInput?
    
    init(useCase: HomeUseCase, wireframe: ThinkGoalWireframe) {
        self.useCase   = useCase
        self.wireframe = wireframe
    }
    
    func inject(viewController: ThinkGoalPresenterInput) {
        self.viewController = viewController
    }
    
    func preIndex() {
        self.viewController?.preIndex(didFetchRepository: GoalModel.init(
            uid: NSUUID().uuidString,
            text: "",
            credit: 0,
            steps: [],
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
}

extension ThinkGoalPresenterImpl: HomeUseCasePresentationInput {
    func onError() {
        self.viewController?.onErrorIndex()
    }
}
