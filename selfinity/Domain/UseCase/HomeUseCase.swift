//
//  HomeUseCase.swift
//  selfinity
//
//  Created by Apple on 2018/10/12.
//  Copyright © 2018年 Apple. All rights reserved.
//

import Foundation
import RxSwift

protocol HomeUseCase: class {
    func onError()
    func index()
    func index(_ repository: HomeUseCaseDataInput, didFetchEntities entities: GoalsEntity)
    func create(_ repository: HomeUseCaseDataInput, didCreateEntities entities: GoalModel)
    func create(repositories: GoalModel)
}

protocol HomeUseCasePresentationInput: class {
    func useCase(_ useCase: HomeUseCase, didFetchRepositories repositories: HomeIndexesModel)
    func useCase(_ useCase: HomeUseCase, didCreateRepositories repositories: GoalModel)
    func onError()
}

extension HomeUseCasePresentationInput {
    func useCase(_ useCase: HomeUseCase, didFetchRepositories repositories: HomeIndexesModel) {}
    func useCase(_ useCase: HomeUseCase, didCreateRepositories repositories: GoalModel) {}
}

protocol HomeUseCaseDataInput: class {
    func index()
    func create(repositories: GoalModel)
}

final class HomeUseCaseImpl: HomeUseCase {

    fileprivate let repository: HomeUseCaseDataInput
    fileprivate weak var presenter: HomeUseCasePresentationInput?
    
    init(repository: HomeUseCaseDataInput) {
        self.repository = repository
    }
    
    func inject(presenter: HomeUseCasePresentationInput) {
        self.presenter = presenter
    }
    
    func index() {
        self.repository.index()
    }
    
    func index(_ repository: HomeUseCaseDataInput, didFetchEntities entities: GoalsEntity) {
        let repositoriesModel = HomeIndexesTranslator.translate(entities)
        self.presenter?.useCase(self, didFetchRepositories: repositoriesModel)
    }
    
    func onError() {
        self.presenter?.onError()
    }
    
    func create(repositories: GoalModel) {
        self.repository.create(repositories: repositories)
    }
    
    func create(_ repository: HomeUseCaseDataInput, didCreateEntities entities: GoalModel) {
        self.presenter?.useCase(self, didCreateRepositories: entities)
    }
}
