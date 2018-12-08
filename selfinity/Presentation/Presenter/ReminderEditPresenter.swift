
//
//  ReminderEditPresenter.swift
//  selfinity
//
//  Created by Apple on 2018/10/21.
//  Copyright © 2018年 Apple. All rights reserved.
//

import UIKit
import Foundation
import RxSwift
import RxCocoa
import Firebase

protocol ReminderEditPresenter: class {
    func bind()
    func unbind()
    func create(repositories: ReminderModel)
    func preCreate() -> ReminderModel
}

protocol ReminderEditPresenterInput: class {
    func onError()
    func showLoadingView()
    func hideLoadingView()
    func create(didCreateRepository repositories: ReminderModel)
}

final class ReminderEditPresenterImpl: ReminderEditPresenter {
    fileprivate let useCase: ReminderUseCase
    fileprivate let wireframe: ReminderEditWireframe
    fileprivate weak var viewController: ReminderEditPresenterInput?
    
    init(useCase: ReminderUseCase, wireframe: ReminderEditWireframe) {
        self.useCase   = useCase
        self.wireframe = wireframe
    }
    
    func inject(viewController: ReminderEditPresenterInput) {
        self.viewController = viewController
    }
    
    func bind() {
        self.viewController?.showLoadingView()
    }
    
    func unbind() {
        self.viewController?.hideLoadingView()
    }
    
    func create(repositories: ReminderModel) {
        self.useCase.create(repositories: repositories)
    }
    
    func preCreate() -> ReminderModel {
        return ReminderModel.init(uid: NSUUID().uuidString,
                                  title: "",
                                  text: "",
                                  time: Date.CurrentDate(),
                                  span: 60,
                                  repeat: 0,
                                  notification: false,
                                  longitude: 0,
                                  latitude: 0,
                                  address: "",
                                  tagUid: "",
                                  tagKind: Tag.empty.rawValue,
                                  place: Place.empty,
                                  owner: CurrentPrunedUser.getToCurrentPrunedUserModel()!,
                                  private: false,
                                  createdAt: Date.CurrentDate(),
                                  updatedAt: Date.CurrentDate()
        )
    }
}

extension ReminderEditPresenterImpl: ReminderUseCasePresentationInput {
    func onError() {
        self.viewController?.onError()
    }
    
    func useCase(_ useCase: ReminderUseCase, didCreateRepository repository: ReminderModel) {
        self.viewController?.create(didCreateRepository: repository)
    }
}
