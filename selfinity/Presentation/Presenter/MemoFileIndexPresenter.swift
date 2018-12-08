//
//  MemoFileIndexPresenter.swift
//  selfinity
//
//  Created by Apple on 2018/10/16.
//  Copyright © 2018年 Apple. All rights reserved.
//

import Foundation

protocol MemoFileIndexPresenter: class {
    func bind()
    func unbind()
    func tapActionView()
    func createPreFile(repository: FolderModel) -> FileModel
    func tapFileCell(row: Int)
}

protocol MemoFileIndexPresenterInput: class {
    //func createPreFile(didCreateRepositories repositories: FileModel)
    func onErrorIndex()
    func showLoadingView()
    func hideLoadingView()
}

final class MemoFileIndexPresenterImpl: MemoFileIndexPresenter {
    
    fileprivate let useCase: MemoUseCase
    fileprivate let wireframe: MemoFileIndexWireframe
    fileprivate weak var viewController: MemoFileIndexPresenterInput?
    
    init(useCase: MemoUseCase, wireframe: MemoFileIndexWireframe) {
        self.useCase   = useCase
        self.wireframe = wireframe
    }
    
    func inject(viewController: MemoFileIndexPresenterInput) {
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
    
    func tapFileCell(row: Int) {
        self.wireframe.toShow(row: row)
    }
    
    func createPreFile(repository: FolderModel) -> FileModel {
        return FileModel.init(uid: Constant.filePrefix, folderUid: repository.uid, folderTitle: repository.title, text: "", title: R.string.localizable.newFile(), html: "", owner: CurrentPrunedUser.getToCurrentPrunedUserModel()!, private: false, createdAt: Date.CurrentDate(), updatedAt: Date.CurrentDate())
    }
}

extension MemoFileIndexPresenterImpl: MemoUseCasePresentationInput {
    func onError() {
    }
}
