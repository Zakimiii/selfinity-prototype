//
//  ThinkStepEditPresenter.swift
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

protocol ThinkStepEditPresenter: class {
    //func preIndex()
    func bind()
    func unbind()
}

protocol ThinkStepEditPresenterInput: class {
    //func preIndex(didFetchRepository repository: GoalModel)
    func onErrorIndex()
    func showLoadingView()
    func hideLoadingView()
}

final class ThinkStepEditPresenterImpl: ThinkStepEditPresenter {
    fileprivate let useCase: HomeUseCase
    fileprivate let wireframe: ThinkStepEditWireframe
    fileprivate weak var viewController: ThinkStepEditPresenterInput?
    
    init(useCase: HomeUseCase, wireframe: ThinkStepEditWireframe) {
        self.useCase   = useCase
        self.wireframe = wireframe
    }
    
    func inject(viewController: ThinkStepEditPresenterInput) {
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
}

extension ThinkStepEditPresenterImpl: HomeUseCasePresentationInput {
    func onError() {
        self.viewController?.onErrorIndex()
    }
}
