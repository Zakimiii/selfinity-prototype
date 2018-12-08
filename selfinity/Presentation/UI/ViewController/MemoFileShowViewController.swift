//
//  MemoFileShowViewController.swift
//  selfinity
//
//  Created by Apple on 2018/10/11.
//  Copyright © 2018年 Apple. All rights reserved.
//

import UIKit
import RichEditorView
import RxSwift

protocol MemoFileShowDelegate: class {
    func pop(newElement: FileModel, type: CRUD)
}

@objcMembers
class MemoFileShowViewController: UIViewController {
    var editorView = RichEditorView() {
        willSet{
            showLoadingView()
        }
    }
    
    lazy var toolbar: RichEditorToolbar = {
        let toolbar = RichEditorToolbar(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 44))
        toolbar.options = RichEditorDefaultOption.all
        return toolbar
    }()
    @IBOutlet weak var containerView: UIView! {
        didSet {
            DispatchQueue.main.async {
                self.editorView = RichEditorView(frame: self.containerView.bounds)
                self.toolbar.delegate = self
                self.toolbar.editor = self.editorView
                self.editorView.placeholder = R.string.localizable.newFilePlaceholder()
                self.editorView.delegate = self
                self.containerView.addSubview(self.editorView)
                self.containerView.clipsToBounds = true
                self.richEditorDidLoad(self.toolbar.editor!)
            }
        }
    }
    @IBOutlet weak var actionView: ActionView! {
        didSet {
            actionView.layer.shadowColor = Constant.baseStringColor.cgColor
            actionView.layer.shadowColor = Constant.baseStringColor.cgColor
            actionView.layer.shadowOpacity = 0.2
            actionView.layer.shadowOffset = CGSize.zero
            actionView.layer.shadowRadius = actionView.bounds.width / 2
            actionView.delegate = self
        }
    }
    @IBOutlet weak var actionViewBottom: NSLayoutConstraint!
    @IBOutlet weak var headerView: ThinkHeaderView! {
        didSet {
            self.headerView.onlyCloseMode()
            headerView.titileLabel.text = ""
            headerView.closeButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.tapClose)))
            headerView.closeButton.button.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.tapClose)))
        }
    }
    var animated: Bool = false
    
    var repositories: FileModel!
    var folderUid: String!
    var folderTitle: String!
    fileprivate var presenter: MemoFileShowPresenter?
    fileprivate let dataStore =  MemoDataStoreImpl()
    fileprivate let error = ErrorTracker()
    fileprivate let disposeBag = DisposeBag()
    var delegate: MemoFileShowDelegate!
    
    func inject(presenter: MemoFileShowPresenter) {
        self.presenter = presenter
    }
    
    fileprivate func configText() {
        self.headerView.titileLabel.text = self.repositories.title
        self.toolbar.editor?.html = self.repositories.html
    }
    
    override func viewDidLoad() {
        MemoFileShowViewControllerBuilder.rebuild(self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShown(notification:)),
                                               name: NSNotification.Name.UIKeyboardWillShow,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHidden(notification:)),
                                               name: NSNotification.Name.UIKeyboardWillHide,
                                               object: nil)
    }
    
    func keyboardWillShown(notification: NSNotification) {
        self.editorView.inputAccessoryView = self.toolbar
        if let userInfo = notification.userInfo {
            if let /*keyboardRect*/ _ = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue, !self.animated {
                self.animated = true
                self.editorView.inputAccessoryView = self.toolbar
                self.actionView.layer.removeAllAnimations()
                UIView.animate(withDuration: 0.3, animations: {
                    self.toolbar.isHidden = !self.animated
//                    self.actionView.button.transform = CGAffineTransform(rotationAngle: CGFloat(45 * CGFloat.pi / 180))
//                    self.actionViewBottom.constant = keyboardRect.height
//                    self.actionView.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
                })
            }
        }
    }
    
    func keyboardWillHidden(notification: NSNotification) {
        self.editorView.inputAccessoryView = nil
        if self.animated {
            self.animated = false
            UIView.animate(withDuration: 0.3, animations: {
                self.editorView.inputAccessoryView = nil
                self.toolbar.isHidden = !self.animated
//                self.actionViewBottom.constant = 20
//                self.actionView.button.transform = CGAffineTransform(rotationAngle: CGFloat(90 * CGFloat.pi / 180))
//                self.actionView.transform = CGAffineTransform(scaleX: 1, y: 1)
            })
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
         self.view.endEditing(true)
        _ = self.editorView.resignFirstResponder()
    }
    
    func tapEditorView() {
        self.view.endEditing(true)
        _ = self.editorView.resignFirstResponder()
    }
    
    func tapClose() {
        _ = self.editorView.resignFirstResponder()
        self.repositories.text = self.editorView.text
        self.repositories.html = self.editorView.html
        print(self.repositories.html,self.editorView.html)
        self.editorView.text.enumerateLines{ line, stop in
            self.repositories.title = line
            self.headerView.titileLabel.text = line
            stop = line != "" && line != "\n"
        }
        if repositories.uid.contains(Constant.filePrefix) {
            self.presenter?.createFile(title: self.headerView.titileLabel.text!, text: self.editorView.text, html: self.repositories.html, folderUid: self.folderUid, folderTitle: self.folderTitle)
        } else {
            self.presenter?.updateFile(file: self.repositories, folderUid: self.repositories.folderUid, folderTitle: self.repositories.folderTitle)
        }
    }
}

extension MemoFileShowViewController: RichEditorDelegate {
    func richEditorTookFocus(_ editor: RichEditorView) {
        self.configText()
    }
    
    func richEditorLostFocus(_ editor: RichEditorView) {
    }
    
    func richEditor(_ editor: RichEditorView, contentDidChange content: String) {
        if animated {
            self.repositories.text = editor.text
            self.repositories.html = editor.html
            editor.text.enumerateLines{ line, stop in
                self.repositories.title = line
                self.headerView.titileLabel.text = line
                stop = line != "" && line != "\n"
            }
        }
    }
    
    func richEditorDidLoad(_ editor: RichEditorView) {
        DispatchQueue.main.async {
            self.hideLoadingView()
            self.configText()
            //MARK: Because of oddfull the moving
//            self.editorView.focus()
        }
    }
}

extension MemoFileShowViewController: RichEditorToolbarDelegate {
    func richEditorToolbarChangeTextColor(_ toolbar: RichEditorToolbar){
        
    }
    
    func richEditorToolbarChangeBackgroundColor(_ toolbar: RichEditorToolbar){
        
    }
    
    func richEditorToolbarInsertImage(_ toolbar: RichEditorToolbar){
        
    }
    
    func richEditorToolbarInsertLink(_ toolbar: RichEditorToolbar){
        
    }
}

extension MemoFileShowViewController: MemoFileShowPresenterInput {
    
    func updateFile(didUpdateRepositories repositories: FileModel) {
        self.delegate?.pop(newElement: repositories, type: .update)
        self.navigationController?.popViewController(animated: true)
    }
    
    func showLoadingView() {
        self.showIndicator()
    }

    func hideLoadingView() {
        self.hideIndicator()
    }

    func createFile(didCreateRepositories repositories: FileModel) {
//        self.repositories = repositories
        self.delegate?.pop(newElement: repositories, type: .create)
        self.navigationController?.popViewController(animated: true)
    }
    
    func onErrorCreate() {
        self.navigationController?.popViewController(animated: true)
    }
}

extension MemoFileShowViewController: ActionViewDelegate {
    func tapView() {
        if !self.animated {
            self.editorView.focus()
        } else {
            _ = self.editorView.resignFirstResponder()
        }
    }
}
