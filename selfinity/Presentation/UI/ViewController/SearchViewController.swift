//
//  SearchViewController.swift
//  selfinity
//
//  Created by Apple on 2018/10/15.
//  Copyright © 2018年 Apple. All rights reserved.
//

import UIKit

@objcMembers
class SearchViewController: UIViewController {
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var backButton: UIButton! {
        didSet {
            backButton.addTarget(self, action: #selector(self.tapBack), for: .touchUpInside)
        }
    }
    lazy var inputAIView: AIAccessoryView = {
        let inputAIView = AIAccessoryView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 120))
        inputAIView.backgroundColor = UIColor.clear
        return inputAIView
    }()
    @IBOutlet weak var textField: UITextField! {
        didSet {
            textField.delegate = self
            textField.inputAccessoryView = self.inputAIView
        }
    }
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.register(R.nib.searchTableViewCell(), forCellReuseIdentifier: R.nib.searchTableViewCell.name)
            tableView.register(R.nib.customizeHeaderTableView(), forHeaderFooterViewReuseIdentifier: R.nib.customizeHeaderTableView.name)
            tableView.register(R.nib.mainTableViewHeaderView(), forHeaderFooterViewReuseIdentifier: R.nib.mainTableViewHeaderView.name)
            tableView.estimatedRowHeight = 84
            tableView.rowHeight = UITableViewAutomaticDimension
            //tableView.tableFooterView = UIView()
            tableView.delegate = self
            tableView.dataSource = self
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
        self.textField.resignFirstResponder()
    }
    
    override func viewDidLoad() {
        
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
    
    func keyboardWillShown(notification: NSNotification) {        if let userInfo = notification.userInfo {
            if let keyboardRect = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
                self.tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardRect.height + 120, right: 0)//きかない....
                }
        }
    }
    
    func keyboardWillHidden(notification: NSNotification) {
        self.tableView.contentInset = UIEdgeInsets.zero
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.textField.becomeFirstResponder()
    }
    
    func tapBack() {
        self.navigationController?.popViewController(animated: true)
    }
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: R.nib.searchTableViewCell.name) as? SearchTableViewCell else {
            fatalError("This row is not exist")
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        guard let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: R.nib.customizeHeaderTableView.name) as? CustomizeHeaderTableView else {
//            fatalError("This section is not exist")
//        }
        guard let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: R.nib.mainTableViewHeaderView.name) as? MainTableViewHeaderView else {
            fatalError("This section is not exist")
        }
        view.titleLabel.text = R.string.localizable.prediction()
        view.setFontSize(30)
        view.backgroundColor = Constant.baseColor
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 45
    }
}

extension SearchViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (self.tableView.contentOffset.y <= 45 && self.tableView.contentOffset.y >= 0) {
            self.tableView.contentInset = UIEdgeInsets(top: -scrollView.contentOffset.y, left: 0, bottom: 0, right: 0)
        } else if (self.tableView.contentOffset.y >= 45) {
            self.tableView.contentInset = UIEdgeInsets(top: -45, left: 0, bottom: 00, right: 0)
        }
    }
}

extension SearchViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //TODO:Go search
        textField.resignFirstResponder()
        return true
    }
}
