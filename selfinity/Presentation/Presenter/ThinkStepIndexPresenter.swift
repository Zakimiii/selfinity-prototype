

//
//  ThinkStepIndexPresenter.swift
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

protocol ThinkStepIndexPresenter: class {
    //func preIndex()
    func bind()
    func unbind()
}

protocol ThinkStepIndexPresenterInput: class {
    //func preIndex(didFetchRepository repository: GoalModel)
    func onErrorIndex()
    func showLoadingView()
    func hideLoadingView()
}

final class ThinkStepIndexPresenterImpl: ThinkStepIndexPresenter {
    fileprivate let useCase: HomeUseCase
    fileprivate let wireframe: ThinkStepIndexWireframe
    fileprivate weak var viewController: ThinkStepIndexPresenterInput?
    
    init(useCase: HomeUseCase, wireframe: ThinkStepIndexWireframe) {
        self.useCase   = useCase
        self.wireframe = wireframe
    }
    
    func inject(viewController: ThinkStepIndexPresenterInput) {
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

extension ThinkStepIndexPresenterImpl: HomeUseCasePresentationInput {
    func onError() {
        self.viewController?.onErrorIndex()
    }
}
