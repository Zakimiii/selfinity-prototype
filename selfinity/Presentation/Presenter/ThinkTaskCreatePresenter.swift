
//
//  ThinkTaskCreatePresenter.swift
//  selfinity
//
//  Created by Apple on 2018/10/19.
//  Copyright © 2018年 Apple. All rights reserved.
//

import UIKit
import Foundation
import RxSwift
import RxCocoa
import Firebase

protocol ThinkTaskCreatePresenter: class {
    func index(repositories: GoalModel)
    func bind()
    func unbind()
    func create(repositories: GoalModel)
}

protocol ThinkTaskCreatePresenterInput: class {
    func index(didFetchRepository repository: GoalModel)
    func onErrorIndex()
    func showLoadingView()
    func hideLoadingView()
    func create(didCreateRepository repository: GoalModel)
}

final class ThinkTaskCreatePresenterImpl: ThinkTaskCreatePresenter {
    fileprivate let useCase: HomeUseCase
    fileprivate let wireframe: ThinkTaskCreateWireframe
    fileprivate weak var viewController: ThinkTaskCreatePresenterInput?
    
    init(useCase: HomeUseCase, wireframe: ThinkTaskCreateWireframe) {
        self.useCase   = useCase
        self.wireframe = wireframe
    }
    
    func inject(viewController: ThinkTaskCreatePresenterInput) {
        self.viewController = viewController
    }
    
    //    func preIndex() {
    //        self.viewController?.preIndex(didFetchRepository: GoalModel.init(
    //            uid: NSUUID().uuidString,
    //            text: "",
    //            steps: [],
    //            smart: SmartModel.init(uid: NSUUID().uuidString,
    //                                   specificSubject: "",
    //                                   specificVerb: "",
    //                                   timeBound: "",
    //                                   measurable: "",
    //                                   owner: CurrentPrunedUser.getToCurrentPrunedUserModel()!,
    //                                   private: false,
    //                                   createdAt: Date(),
    //                                   updatedAt: Date()),
    //            owner: CurrentPrunedUser.getToCurrentPrunedUserModel()!,
    //            private: false,
    //            createdAt: Date(),
    //            updatedAt: Date())
    //        )
    //    }
    
    func bind() {
        self.viewController?.showLoadingView()
    }
    
    func unbind() {
        self.viewController?.hideLoadingView()
    }
    
    func create(repositories: GoalModel) {
        self.useCase.create(repositories: repositories)
    }
    
    func index( repositories: GoalModel) {
        //TODO: TaskGenerater
        var repositories = repositories
        var tasks: [[TaskModel]] = []
        for step in repositories.steps.enumerated() {
            tasks.append([])
            tasks[step.offset].append(StepToTaskTranslator.translate(step.element))
        }
        for task in tasks.enumerated() {
            repositories.steps[task.offset].tasks = task.element
        }
        self.viewController?.index(didFetchRepository: repositories)
    }
}

extension ThinkTaskCreatePresenterImpl: HomeUseCasePresentationInput {
    func onError() {
        self.viewController?.onErrorIndex()
    }
    
    func useCase(_ useCase: HomeUseCase, didCreateRepositories repositories: GoalModel) {
        self.viewController?.create(didCreateRepository: repositories)
    }
}
