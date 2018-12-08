//
//  TextFieldViewController.swift
//  selfinity
//
//  Created by Apple on 2018/10/18.
//  Copyright © 2018年 Apple. All rights reserved.
//

import UIKit
import RxSwift

protocol TextFieldViewControllerDelegate:class {
    func pop(_ text: String)
    var datePickerMode: Bool { get set}
    var smart: SmartModel? { get set }
    var currentSmart: SmartProperty { get set}
}

enum SmartProperty: Int {
    case subject
    case verb
    case measurable
    case time
    case empty
}


@objcMembers
class TextFieldViewController: UIViewController {
    var delegate: TextFieldViewControllerDelegate!
    @IBOutlet weak var bodyView: UIView! {
        didSet {
            bodyView.clipsToBounds = true
        }
    }
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var backButton: GradationButton! {
        didSet {
            backButton.button.addTarget(self, action: #selector(self.tapBack), for: .touchUpInside)
        }
    }
    @IBOutlet weak var textField: UITextField! {
        didSet {
            textField.delegate = self
            textField.addTarget(self, action: #selector(textFieldEditingChanged), for: .editingChanged)
            guard self.repository == nil else { textField.text = self.repository; return }
            guard self.placeholder == nil else { textField.placeholder = self.placeholder; return }
        }
    }
    @IBOutlet weak var editButton: OptionButton! {
        didSet {
            editButton.layer.shadowColor = Constant.baseStringColor.cgColor
            editButton.layer.shadowOpacity = 0.2
            editButton.layer.shadowOffset = CGSize.zero
            editButton.layer.shadowRadius = 15
        }
    }
    @IBOutlet weak var chatButton: OptionButton! {
        didSet {
            chatButton.layer.shadowColor = Constant.baseStringColor.cgColor
            chatButton.layer.shadowOpacity = 0.2
            chatButton.layer.shadowOffset = CGSize.zero
            chatButton.layer.shadowRadius = 15
            chatButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.tapChat)))
            chatButton.button.addTarget(self, action: #selector(self.tapChat), for: .touchUpInside)
        }
    }
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.register(R.nib.aiChatTableViewCell(), forCellReuseIdentifier: R.nib.aiChatTableViewCell.name)
            tableView.register(R.nib.yourChatTableViewCell(), forCellReuseIdentifier: R.nib.yourChatTableViewCell.name)
            tableView.register(R.nib.customizeHeaderTableView(), forHeaderFooterViewReuseIdentifier: R.nib.customizeHeaderTableView.name)
            tableView.register(R.nib.mainTableViewHeaderView(), forHeaderFooterViewReuseIdentifier: R.nib.mainTableViewHeaderView.name)
            tableView.estimatedRowHeight = 84
            tableView.rowHeight = UITableViewAutomaticDimension
            //tableView.tableFooterView = UIView()
            tableView.delegate = self
            tableView.dataSource = self
            tableView.backgroundColor = UIColor.clear
        }
    }
    var datePicker: UIDatePicker!
    var uiDatePickerMode: UIDatePickerMode = .dateAndTime
    //var timeFormat: String = "MM/dd HH:mm"
    var repository: String!
    var placeholder: String!
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var headerLabelHeight: NSLayoutConstraint! {
        didSet {
            headerLabelHeight.constant = 0
        }
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
        self.textField.resignFirstResponder()
    }
    
    override func viewDidLoad() {
        if self.delegate?.datePickerMode ?? false { setDatePicker() }
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
    
    override func viewWillLayoutSubviews() {
        if let _ = self.delegate.smart, self.delegate.currentSmart != .empty {
            self.headerLabelHeight.constant = 50
            self.headerLabel.text = self.string(section: self.delegate?.currentSmart ?? .empty)
        }
    }
    
    func keyboardWillShown(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            if let keyboardRect = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
                self.tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardRect.height + 120, right: 0)
            }
        }
    }
    
    fileprivate func string(section: SmartProperty) -> String {
        guard var smart = self.delegate?.smart else { return "" }
        switch section {
        case .subject:
            smart.specificSubject = self.textField.text ?? ""
        case .verb:
            smart.specificVerb = self.textField.text ?? ""
            print(self.textField.text ?? "")
        case .measurable:
            smart.measurable = self.textField.text ?? ""
        case .time:
            smart.timeBound = self.textField.text ?? ""
        case .empty: return ""
        }
        return smart.createJAText()
    }
    
    fileprivate func setDatePicker() {
        self.datePicker = UIDatePicker()
        datePicker.datePickerMode = self.uiDatePickerMode
        datePicker.timeZone = NSTimeZone.local
        datePicker.locale = Locale.current
        textField.inputView = datePicker
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 35))
        let spacelItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let doneItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(tapBack))
        doneItem.tintColor = Constant.mainColor
        toolbar.setItems([spacelItem, doneItem], animated: true)
        textField.inputView = datePicker
        textField.inputAccessoryView = toolbar
        
        datePicker.date = Date.CurrentDate()
    }
    
    func keyboardWillHidden(notification: NSNotification) {
        self.tableView.contentInset = UIEdgeInsets.zero
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.bodyView.waveColorCenter(color: Constant.chatWaveColor, point: CGPoint(x: 60, y: 60))
        self.textField.becomeFirstResponder()
    }
    
    func tapBack() {
        self.textField.resignFirstResponder()
        self.delegate?.pop(self.textField.text ?? "")
        self.dismiss(animated: true, completion: nil)
    }
    
    func tapChat() {
        self.performSegue(withIdentifier: R.segue.textFieldViewController.toChat.identifier, sender: nil)
    }
}

extension TextFieldViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: R.nib.aiChatTableViewCell.name) as? AIChatTableViewCell else {
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
        return 0
    }
}

extension TextFieldViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (self.tableView.contentOffset.y <= 45 && self.tableView.contentOffset.y >= 0) {
            self.tableView.contentInset = UIEdgeInsets(top: -scrollView.contentOffset.y, left: 0, bottom: 0, right: 0)
        } else if (self.tableView.contentOffset.y >= 45) {
            self.tableView.contentInset = UIEdgeInsets(top: -45, left: 0, bottom: 00, right: 0)
        }
    }
}

extension TextFieldViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        self.tapBack()
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        guard self.datePicker != nil else { return true }
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm"
        self.textField.text = "\(formatter.string(from: self.datePicker.date))"
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if self.datePicker != nil {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy/MM/dd HH:mm"
            self.textField.text = "\(formatter.string(from: self.datePicker.date))"
        }
        return true
    }
}

extension TextFieldViewController {
    func textFieldEditingChanged(sender: UITextField) {
        if self.datePicker != nil {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm"
        self.textField.text = "\(formatter.string(from: self.datePicker.date))"
        }
        
        if let _ = self.delegate.smart, self.delegate.currentSmart != .empty {
            self.headerLabelHeight.constant = 50
            self.headerLabel.text = self.string(section: self.delegate?.currentSmart ?? .empty)
        }
    }
}

