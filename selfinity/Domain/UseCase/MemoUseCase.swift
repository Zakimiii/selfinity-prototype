//
//  MemoUseCase.swift
//  selfinity
//
//  Created by Apple on 2018/10/16.
//  Copyright © 2018年 Apple. All rights reserved.
//

import Foundation
import RxSwift

protocol MemoUseCase: class {
    func onError()
    func createFolder(text: String)
    func createFolder(_ repository: MemoUseCaseDataInput, didCreateEntities entity: FolderEntity)
    func createFile(title: String, text: String, html: String, folderUid: String, folderTitle: String)
    func updateFile(file: FileModel, folderUid: String, folderTitle: String)
    func updateFile(_ repository: MemoUseCaseDataInput, didUpdateEntities entity: FileEntity)
    func createFile(_ repository: MemoUseCaseDataInput, didCreateEntities entity: FileEntity)
    func index()
    func index(_ repository: MemoUseCaseDataInput, didFetchEntities entities: FoldersEntity)
}

protocol MemoUseCasePresentationInput: class {
    func useCase(_ useCase: MemoUseCase, didFetchRepositories repositories: MemoModel)
    func useCase(_ useCase: MemoUseCase, didCreateRepositories repositories: FolderModel)
    func useCase(_ useCase: MemoUseCase, didCreateRepositories repositories: FileModel)
    func useCase(_ useCase: MemoUseCase, didUpdateRepositories repositories: FileModel)
    func onError()
}

extension MemoUseCasePresentationInput {
    func useCase(_ useCase: MemoUseCase, didFetchRepositories repositories: MemoModel) {}
    func useCase(_ useCase: MemoUseCase, didCreateRepositories repositories: FolderModel) {}
    func useCase(_ useCase: MemoUseCase, didCreateRepositories repositories: FileModel) {}
    func useCase(_ useCase: MemoUseCase, didUpdateRepositories repositories: FileModel) {}
}

protocol MemoUseCaseDataInput: class {
    func index()
    func createFolder(text: String)
    func createFile(title: String, text: String, html: String, folderUid: String, folderTitle: String)
    func updateFile(file: FileModel, folderUid: String, folderTitle: String)
}

final class MemoUseCaseImpl: MemoUseCase {
    
    fileprivate let repository: MemoUseCaseDataInput
    fileprivate weak var presenter: MemoUseCasePresentationInput?
    
    init(repository: MemoUseCaseDataInput) {
        self.repository = repository
    }
    
    func inject(presenter: MemoUseCasePresentationInput) {
        self.presenter = presenter
    }
    
    func index() {
        self.repository.index()
    }
    
    func index(_ repository: MemoUseCaseDataInput, didFetchEntities entities: FoldersEntity) {
        let repositoriesModel = MemoTranslator.translate(entities)
        self.presenter?.useCase(self, didFetchRepositories: repositoriesModel)
    }
    
    func onError() {
        self.presenter?.onError()
    }
    
    func createFolder(text: String) {
        self.repository.createFolder(text: text)
    }
    
    func createFolder(_ repository: MemoUseCaseDataInput, didCreateEntities entity: FolderEntity) {
        let repositoriesModel = FolderTranslator.translate(entity)
        self.presenter?.useCase(self, didCreateRepositories: repositoriesModel)
    }
    
    func createFile(title: String, text: String, html: String, folderUid: String, folderTitle: String) {
        self.repository.createFile(title: title, text: text, html: html, folderUid: folderUid, folderTitle: folderTitle)
    }
    
    func createFile(_ repository: MemoUseCaseDataInput, didCreateEntities entity: FileEntity) {
        let repositoriesModel = FileTranslator.translate(entity)
        self.presenter?.useCase(self, didCreateRepositories: repositoriesModel)
    }
    
    func updateFile(file: FileModel, folderUid: String, folderTitle: String) {
        self.repository.updateFile(file: file, folderUid: folderUid, folderTitle: folderTitle)
    }
    
    func updateFile(_ repository: MemoUseCaseDataInput, didUpdateEntities entity: FileEntity) {
        let repositoriesModel = FileTranslator.translate(entity)
        self.presenter?.useCase(self, didUpdateRepositories: repositoriesModel)
    }
}
