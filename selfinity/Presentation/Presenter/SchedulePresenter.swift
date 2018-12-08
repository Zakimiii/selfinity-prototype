//
//  ReminderPresenter.swift
//  selfinity
//
//  Created by Apple on 2018/10/20.
//  Copyright © 2018年 Apple. All rights reserved.
//

import UIKit
import Foundation
import RxSwift
import RxCocoa
import Firebase

protocol SchedulePresenter: class {
    func index()
    func bind()
    func unbind()
    func create(repositories: ReminderModel)
    func createFromGoal(repositories: GoalModel)
    func tapView()
    func tapReminder()
}

protocol SchedulePresenterInput: class {
    func index(didFetchRepository repository: RemindersModel)
    func onErrorIndex()
    func showLoadingView()
    func hideLoadingView()
    func create(didCreateRepository repositories: RemindersModel)
}

final class SchedulePresenterImpl: SchedulePresenter {
    fileprivate let useCase: ReminderUseCase
    fileprivate let wireframe: ScheduleWireframe
    fileprivate weak var viewController: SchedulePresenterInput?
    
    init(useCase: ReminderUseCase, wireframe: ScheduleWireframe) {
        self.useCase   = useCase
        self.wireframe = wireframe
    }
    
    func inject(viewController: SchedulePresenterInput) {
        self.viewController = viewController
    }
    
    func bind() {
        self.viewController?.showLoadingView()
    }
    
    func unbind() {
        self.viewController?.hideLoadingView()
    }
    
    func createFromGoal(repositories: GoalModel) {
        self.useCase.createFromGoal(repositories: repositories)
    }
    
    func create(repositories: ReminderModel) {
        //self.useCase.create(repositories: repositories)
    }
    
    func index() {
        self.useCase.index()
    }
    
    func tapView() {
        self.wireframe.toCreate()
    }
    
    func tapReminder() {
        self.wireframe.toEdit()
    }
}

extension SchedulePresenterImpl: ReminderUseCasePresentationInput {
    func onError() {
        self.viewController?.onErrorIndex()
    }
    
    func useCase(_ useCase: ReminderUseCase, didFetchRepositories repositories: RemindersModel) {
        self.viewController?.index(didFetchRepository: repositories)
    }
    
    func useCase(_ useCase: ReminderUseCase, didCreateRepositories repositories: RemindersModel) {
        self.viewController?.create(didCreateRepository: repositories)
    }
}
