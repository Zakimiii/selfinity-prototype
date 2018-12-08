//
//  HomeRepository.swift
//  selfinity
//
//  Created by Apple on 2018/10/12.
//  Copyright © 2018年 Apple. All rights reserved.
//

import UIKit
import Foundation
import RxSwift
import RxCocoa
import Firebase

protocol HomeRepository: class {
    func dataStore(_ dataStore: HomeRepositoryInput, didFetchEntities Entities: GoalsEntity)
    func dataStore(_ dataStore: HomeRepositoryInput, didCreateEntities Entities: GoalModel)
    func onErrorDataStore(_ dataStore: HomeRepositoryInput)
}

protocol HomeRepositoryInput: class {
    func index() -> Observable<GoalsEntity>
    func create(goalEntity: GoalModel) -> Observable<GoalModel>
    func read()
    func update()
    func delete()
}

final class HomeRepositoryImpl: HomeRepository {
    fileprivate let dataStore: HomeRepositoryInput
    fileprivate weak var useCase: HomeUseCase?
    fileprivate let disposeBag = DisposeBag()
    
    init(dataStore: HomeRepositoryInput) {
        self.dataStore = dataStore
    }
    
    func inject(useCase: HomeUseCase) {
        self.useCase = useCase
    }
    
    func dataStore(_ dataStore: HomeRepositoryInput, didFetchEntities Entities: GoalsEntity) {
        self.useCase?.index(self, didFetchEntities: Entities)
    }
    
    func onErrorDataStore(_ dataStore: HomeRepositoryInput) {
        self.useCase?.onError()
    }
    
    func dataStore(_ dataStore: HomeRepositoryInput, didCreateEntities Entities: GoalModel) {
        self.useCase?.create(self, didCreateEntities: Entities)
    }
}

extension HomeRepositoryImpl: HomeUseCaseDataInput {
    
    func index() {
        self.dataStore.index().subscribe(onNext: { response in
                self.dataStore(self.dataStore, didFetchEntities: response)
        }, onError: { error in
            self.onErrorDataStore(self.dataStore)
        }).disposed(by: self.disposeBag)
    }
    
    func create(repositories: GoalModel) {
        self.dataStore.create(goalEntity: repositories).subscribe(onNext: { response in
            self.dataStore(self.dataStore, didCreateEntities: response)
            var labelsModel = LabelsModel()
            labelsModel.repositories.append(LabelModel.init(uid: NSUUID().uuidString,
                                                            title: response.text,
                                                            tagUid:  response.uid,
                                                            tagkind: Tag.goal.rawValue)
            )
            for step in response.steps.enumerated() {
                labelsModel.repositories.append(LabelModel.init(uid: NSUUID().uuidString,
                                                                title: step.element.text,
                                                                tagUid:  step.element.uid,
                                                                tagkind: Tag.step.rawValue)
                )
                for task in step.element.tasks.enumerated() {
                    labelsModel.repositories.append(LabelModel.init(uid: NSUUID().uuidString,
                                                                    title: task.element.text,
                                                                    tagUid:  task.element.uid,
                                                                    tagkind: Tag.task.rawValue)
                    )
                }
            }
            LabelDataStoreImpl().create(repositories: labelsModel).subscribe(onNext: { response in }, onError: { error in
                self.onErrorDataStore(self.dataStore)
            }).disposed(by: self.disposeBag)
        }, onError: { error in
            self.onErrorDataStore(self.dataStore)
        }).disposed(by: self.disposeBag)
    }
}
