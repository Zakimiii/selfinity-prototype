//
//  MemoFileShowPresenter.swift
//  selfinity
//
//  Created by Apple on 2018/10/16.
//  Copyright © 2018年 Apple. All rights reserved.
//

import Foundation

protocol MemoFileShowPresenter: class {
    func bind()
    func unbind()
    func tapActionView()
    func createFile(title: String, text: String, html: String, folderUid: String, folderTitle: String)
    func updateFile(file: FileModel, folderUid: String, folderTitle: String)
}

protocol MemoFileShowPresenterInput: class {
    func createFile(didCreateRepositories repositories: FileModel)
    func updateFile(didUpdateRepositories repositories: FileModel)
    func onErrorCreate()
    func showLoadingView()
    func hideLoadingView()
}

final class MemoFileShowPresenterImpl: MemoFileShowPresenter {
    
    fileprivate let useCase: MemoUseCase
    fileprivate let wireframe: MemoFileShowWireframe
    fileprivate weak var viewController: MemoFileShowPresenterInput?
    
    init(useCase: MemoUseCase, wireframe: MemoFileShowWireframe) {
        self.useCase   = useCase
        self.wireframe = wireframe
    }
    
    func inject(viewController: MemoFileShowPresenterInput) {
        self.viewController = viewController
    }
    
    func bind() {
        self.viewController?.showLoadingView()
    }
    
    func unbind() {
        self.viewController?.hideLoadingView()
    }
    
    func tapActionView() {
        
    }
    
    func createFile(title: String, text: String, html: String, folderUid: String, folderTitle: String) {
        guard title != "", text != "", html != "", folderUid != "" else {
            self.viewController?.onErrorCreate()
            return
        }
        self.useCase.createFile(title: title, text: text, html: html, folderUid: folderUid, folderTitle: folderTitle)
    }
    
    func updateFile(file: FileModel, folderUid: String, folderTitle: String) {
        guard file.title != "", file.text != "", file.html != "", folderUid != "" else {
            self.viewController?.onErrorCreate()
            return
        }
        self.useCase.updateFile(file: file, folderUid: folderUid, folderTitle: folderTitle)
    }
}

extension MemoFileShowPresenterImpl: MemoUseCasePresentationInput {
    func onError() {
        //self.viewController?.onErrorIndex()
    }
    
    func useCase(_ useCase: MemoUseCase, didUpdateRepositories repositories: FileModel) {
        self.viewController?.updateFile(didUpdateRepositories: repositories)
    }
    
    func useCase(_ useCase: MemoUseCase, didCreateRepositories repositories: FileModel) {
        self.viewController?.createFile(didCreateRepositories: repositories)
    }
}
