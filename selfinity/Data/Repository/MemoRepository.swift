//
//  MemoRepository.swift
//  selfinity
//
//  Created by Apple on 2018/10/16.
//  Copyright © 2018年 Apple. All rights reserved.
//
import UIKit
import Foundation
import RxSwift
import RxCocoa
import Firebase

protocol MemoRepository: class {
    func dataStore(_ dataStore: MemoRepositoryInput, didFetchEntities Entities: FoldersEntity)
    func dataStore(_ dataStore: MemoRepositoryInput, didCreateEntity entity: FolderEntity)
    func dataStore(_ dataStore: MemoRepositoryInput, didCreateEntity entity: FileEntity)
    func dataStore(_ dataStore: MemoRepositoryInput, didUpdateEntity entity: FileEntity)
    func onErrorDataStore(_ dataStore: MemoRepositoryInput)
}

protocol MemoRepositoryInput: class {
    func index() -> Observable<FoldersEntity>
    func createFolder(title: String) -> Observable<FolderEntity> 
    func createMemo(title: String, text: String, html: String, folderUid: String, folderTitle: String) -> Observable<FileEntity>
    func updateFile(fileModel: FileModel, folderUid: String, folderTitle: String) -> Observable<FileEntity>
    func read()
    func update()
    func delete()
}

final class MemoRepositoryImpl: MemoRepository {
    fileprivate let dataStore: MemoRepositoryInput
    fileprivate weak var useCase: MemoUseCase?
    fileprivate let disposeBag = DisposeBag()
    
    init(dataStore: MemoRepositoryInput) {
        self.dataStore = dataStore
    }
    
    func inject(useCase: MemoUseCase) {
        self.useCase = useCase
    }
    
    func dataStore(_ dataStore: MemoRepositoryInput, didCreateEntity entity: FolderEntity) {
        self.useCase?.createFolder(self, didCreateEntities: entity)
    }
    
    func dataStore(_ dataStore: MemoRepositoryInput, didFetchEntities Entities: FoldersEntity) {
        self.useCase?.index(self, didFetchEntities: Entities)
    }
    
    func dataStore(_ dataStore: MemoRepositoryInput, didCreateEntity entity: FileEntity) {
        self.useCase?.createFile(self, didCreateEntities: entity)
    }
    
    func dataStore(_ dataStore: MemoRepositoryInput, didUpdateEntity entity: FileEntity) {
        self.useCase?.updateFile(self, didUpdateEntities: entity)
    }
    
    func onErrorDataStore(_ dataStore: MemoRepositoryInput) {
        self.useCase?.onError()
    }
}

extension MemoRepositoryImpl: MemoUseCaseDataInput {
    func updateFile(file: FileModel, folderUid: String, folderTitle: String) {
        self.dataStore.updateFile(fileModel: file, folderUid: folderUid, folderTitle: folderTitle).subscribe(onNext: { response in
            self.dataStore(self.dataStore, didUpdateEntity: response)
            
            LabelDataStoreImpl().create(repository: LabelModel.init(uid: NSUUID().uuidString,
                                                                    title: response.title,
                                                                    tagUid:  response.uid,
                                                                    tagkind: Tag.file.rawValue)
                ).subscribe(onNext: { response in }, onError: { error in
                    self.onErrorDataStore(self.dataStore)
                }).disposed(by: self.disposeBag)
        }, onError: { error in
            self.onErrorDataStore(self.dataStore)
        }).disposed(by: self.disposeBag)
    }
    
    func createFile(title: String, text: String, html: String, folderUid: String, folderTitle: String) {
        self.dataStore.createMemo(title: title, text: text, html: html, folderUid: folderUid, folderTitle: folderTitle).subscribe(onNext: { response in
            self.dataStore(self.dataStore, didCreateEntity: response)
            
            LabelDataStoreImpl().create(repository: LabelModel.init(uid: NSUUID().uuidString,
                                                                    title: response.title,
                                                                    tagUid:  response.uid,
                                                                    tagkind: Tag.file.rawValue)
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
    
    func createFolder(text: String) {
        self.dataStore.createFolder(title: text).subscribe(onNext: { response in
            self.dataStore(self.dataStore, didCreateEntity: response)
            LabelDataStoreImpl().create(repository: LabelModel.init(uid: NSUUID().uuidString,
                                                                    title: response.title,
                                                                    tagUid:  response.uid,
                                                                    tagkind: Tag.folder.rawValue)
                ).subscribe(onNext: { response in }, onError: { error in
                self.onErrorDataStore(self.dataStore)
            }).disposed(by: self.disposeBag)
        }, onError: { error in
            self.onErrorDataStore(self.dataStore)
        }).disposed(by: self.disposeBag)
    }
}
