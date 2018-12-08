//
//  MemoPresenter.swift
//  selfinity
//
//  Created by Apple on 2018/10/16.
//  Copyright © 2018年 Apple. All rights reserved.
//

import Foundation

protocol MemoPresenter: class {
    func index()
    func bind()
    func unbind()
    func tapActionView()
    func createFolder(title: String)
    func tapFolderCell(row: Int)
}

protocol MemoPresenterInput: class {
    func index(didFetchRepositories repositories: MemoModel)
    func createFolder(didCreateRepositories repositories: FolderModel)
    func onErrorIndex()
    func showLoadingView()
    func hideLoadingView()
}

final class MemoPresenterImpl: MemoPresenter {
    fileprivate let useCase: MemoUseCase
    fileprivate let wireframe: MemoWireframe
    fileprivate weak var viewController: MemoPresenterInput?
    
    init(useCase: MemoUseCase, wireframe: MemoWireframe) {
        self.useCase   = useCase
        self.wireframe = wireframe
    }
    
    func inject(viewController: MemoPresenterInput) {
        self.viewController = viewController
    }
    
    func index() {
        self.useCase.index()
    }
    
    func bind() {
        self.viewController?.showLoadingView()
    }
    
    func unbind() {
        self.viewController?.hideLoadingView()
    }
    
    func tapActionView() {
        
    }
    
    func createFolder(title: String) {
        self.useCase.createFolder(text: title)
    }
    
    func tapFolderCell(row: Int) {
        self.wireframe.toFile(row: row)
    }
}

extension MemoPresenterImpl: MemoUseCasePresentationInput {
    func useCase(_ useCase: MemoUseCase, didCreateRepositories repositories: FolderModel) {
        self.viewController?.createFolder(didCreateRepositories: repositories)
    }
    
    func onError() {
        self.viewController?.onErrorIndex()
    }
    
    func useCase(_ useCase: MemoUseCase, didFetchRepositories repositories: MemoModel) {
        self.viewController?.index(didFetchRepositories: repositories)
    }
}
