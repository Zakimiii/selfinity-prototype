//
//  ReminderRepository.swift
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

protocol ReminderRepository: class {
    func dataStore(_ dataStore: ReminderRepositoryInput, didFetchEntities Entities: RemindersEntity)
    func dataStore(_ dataStore: ReminderRepositoryInput, didCreateEntity entities: RemindersModel)
    func dataStore(_ dataStore: ReminderRepositoryInput, didCreateEntity entities: ReminderModel)
    func onErrorDataStore(_ dataStore: ReminderRepositoryInput)
}

protocol ReminderRepositoryInput: class {
    func index() -> Observable<RemindersEntity>
    func create(repositories: RemindersModel) -> Observable<RemindersModel>
    func create(repository: ReminderModel) -> Observable<ReminderModel>
    func read()
    func update()
    func delete()
}

final class ReminderRepositoryImpl: ReminderRepository {
    fileprivate let dataStore: ReminderRepositoryInput
    fileprivate weak var useCase: ReminderUseCase?
    fileprivate let disposeBag = DisposeBag()
    
    init(dataStore: ReminderRepositoryInput) {
        self.dataStore = dataStore
    }
    
    func inject(useCase: ReminderUseCase) {
        self.useCase = useCase
    }
    
    func dataStore(_ dataStore: ReminderRepositoryInput, didCreateEntity entities: RemindersModel) {
        self.useCase?.create(self, didCreateEntities: entities)
    }
    
    func dataStore(_ dataStore: ReminderRepositoryInput, didCreateEntity entities: ReminderModel) {
        self.useCase?.create(self, didCreateEntities: entities)
    }
    
    func dataStore(_ dataStore: ReminderRepositoryInput, didFetchEntities Entities: RemindersEntity) {
        self.useCase?.index(self, didFetchEntities: Entities)
    }
    
    func onErrorDataStore(_ dataStore: ReminderRepositoryInput) {
        self.useCase?.onError()
    }
}

extension ReminderRepositoryImpl: ReminderUseCaseDataInput {
    func create(model: ReminderModel) {
        self.dataStore.create(repository: model).subscribe(onNext: { response in
            self.dataStore(self.dataStore, didCreateEntity: response)
            LabelDataStoreImpl().create(repository: LabelModel.init(uid: NSUUID().uuidString,
                                                                    title: response.title,
                                                                    tagUid:  response.uid,
                                                                    tagkind: Tag.reminder.rawValue)
                ).subscribe(onNext: { response in }, onError: { error in
                    self.onErrorDataStore(self.dataStore)
            }).disposed(by: self.disposeBag)
        }, onError: { error in
            self.onErrorDataStore(self.dataStore)
        }).disposed(by: self.disposeBag)
    }
    
    func index() {
        self.dataStore.index().subscribe(onNext: { response in
            self.dataStore(self.dataStore, didFetchEntities: response)
        }, onError: { error in
            self.onErrorDataStore(self.dataStore)
        }).disposed(by: self.disposeBag)
    }
    
    func create(model: RemindersModel) {
        self.dataStore.create(repositories: model).subscribe(onNext: { response in
            self.dataStore(self.dataStore, didCreateEntity: response)
            
            var labelsModel = LabelsModel()
            for repository in response.repositories.enumerated() {
                labelsModel.repositories.append(LabelModel.init(uid: NSUUID().uuidString,
                                                                title: repository.element.text,
                                                                tagUid:  repository.element.uid,
                                                                tagkind: Tag.reminder.rawValue)
                )
            }
            LabelDataStoreImpl().create(repositories: labelsModel).subscribe(onNext: { response in }, onError: { error in
                self.onErrorDataStore(self.dataStore)
            }).disposed(by: self.disposeBag)
        }, onError: { error in
            self.onErrorDataStore(self.dataStore)
        }).disposed(by: self.disposeBag)
    }
}
