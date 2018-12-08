//
//  ReminderUseCase.swift
//  selfinity
//
//  Created by Apple on 2018/10/20.
//  Copyright © 2018年 Apple. All rights reserved.
//

import Foundation
import RxSwift

protocol ReminderUseCase: class {
    func onError()
    func createFromGoal(repositories: GoalModel)
    func create(repositories: ReminderModel)
    func create(_ repository: ReminderUseCaseDataInput, didCreateEntities entities: RemindersModel)
    func create(_ repository: ReminderUseCaseDataInput, didCreateEntities entities: ReminderModel)
    func index()
    func index(_ repository: ReminderUseCaseDataInput, didFetchEntities entities: RemindersEntity)
}

protocol ReminderUseCasePresentationInput: class {
    func useCase(_ useCase: ReminderUseCase, didFetchRepositories repositories: RemindersModel)
    func useCase(_ useCase: ReminderUseCase, didCreateRepositories repositories: RemindersModel)
    func useCase(_ useCase: ReminderUseCase, didCreateRepository repository: ReminderModel)
    func onError()
}

extension ReminderUseCasePresentationInput {
    func useCase(_ useCase: ReminderUseCase, didFetchRepositories repositories: RemindersModel) {}
    func useCase(_ useCase: ReminderUseCase, didCreateRepositories repositories: RemindersModel) {}
    func useCase(_ useCase: ReminderUseCase, didCreateRepository repository: ReminderModel) {}
}

protocol ReminderUseCaseDataInput: class {
    func index()
    func create(model: RemindersModel)
    func create(model: ReminderModel)
}

final class ReminderUseCaseImpl: ReminderUseCase {
    
    fileprivate let repository: ReminderUseCaseDataInput
    fileprivate weak var presenter: ReminderUseCasePresentationInput?
    
    init(repository: ReminderUseCaseDataInput) {
        self.repository = repository
    }
    
    func inject(presenter: ReminderUseCasePresentationInput) {
        self.presenter = presenter
    }
    
    func index() {
        self.repository.index()
    }
    
    func index(_ repository: ReminderUseCaseDataInput, didFetchEntities entities: RemindersEntity) {
        let repositoriesModel = RemindersTranslator.translate(entities)
        self.presenter?.useCase(self, didFetchRepositories: repositoriesModel)
    }
    
    func onError() {
        self.presenter?.onError()
    }
    
    func createFromGoal(repositories: GoalModel) {
        let repositoriesModel = ReminderTranslator.translateFromGoal(repositories)
        self.repository.create(model: repositoriesModel)
    }
    
    func create(_ repository: ReminderUseCaseDataInput, didCreateEntities entities: RemindersModel) {
        self.presenter?.useCase(self, didCreateRepositories: entities)
    }
    
    func create(repositories: ReminderModel) {
        self.repository.create(model: repositories)
    }
    
    func create(_ repository: ReminderUseCaseDataInput, didCreateEntities entities: ReminderModel) {
        self.presenter?.useCase(self, didCreateRepository: entities)
    }
}
