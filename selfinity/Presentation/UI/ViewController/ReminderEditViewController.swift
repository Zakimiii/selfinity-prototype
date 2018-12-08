//
//  ReminderEditaskNewViewController.swift
//  selfinity
//
//  Created by Apple on 2018/10/19.
//  Copyright © 2018年 Apple. All rights reserved.
//

import UIKit
import RxSwift
import MapKit
import CoreLocation

protocol ReminderEditViewControllerDelegate: class {
    func pop(repositories: ReminderModel)
}

@objcMembers
class ReminderEditViewController: UIViewController {
    var delegate: ReminderEditViewControllerDelegate!
    var parentMode: Bool = false
    var indexPath: IndexPath!
    @IBOutlet weak var nextButton: GradationButton! {
        didSet {
            nextButton.button.addTarget(self, action: #selector(self.tapNext), for: .touchUpInside)
        }
    }
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var headerView: ThinkHeaderView! {
        didSet {
            headerView.onlyCloseMode()
            headerView.titileLabel.setHelveticaNeueMediumFontSize(42)
            headerView.closeButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.tapClose)))
            headerView.closeButton.button.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.tapClose)))
            headerView.titileLabel.text = R.string.localizable.newEvent()
        }
    }
    var repositories: ReminderModel!
    enum Section: Int {
        case title
        case reminder
        case count
        
        var count: Int {
            switch self {
            case .title: return TitleRow.count.rawValue
            case .reminder: return ReminderRow.count.rawValue
            case .count: return 0
            }
        }
        
        var string: String {
            switch self {
            case .title: return R.string.localizable.title()
            case .reminder: return R.string.localizable.reminder()
            case .count: fatalError("This row is not exist")
            }
        }
    }
    
    enum TitleRow: Int {
        case title
        case count
        
        var string: String {
            switch self {
            case .title: return R.string.localizable.subject()
            case .count: fatalError("This row is not exist")
            }
        }
    }
    
    enum ReminderRow: Int {
        case alerm
        case span
        case `repeat`
        case alert
        case `where`
        case tag
        case memo
        case count
        
        var string: String {
            switch self {
            case .alerm: return R.string.localizable.alerm()
            case .span: return R.string.localizable.span()
            case .`repeat`: return R.string.localizable.repeat()
            case .alert: return R.string.localizable.alert()
            case .`where`: return R.string.localizable.where()
            case .tag: return R.string.localizable.tag()
            case .memo: return R.string.localizable.memo()
            case .count: fatalError("This row is not exist")
            }
        }
        
        func value(_ repository: ReminderModel) -> String {
            switch self {
            case .alerm: return "\(repository.time)"
            case .span: return "\(repository.span)"
            case .`repeat`: return "\(repository.repeat)"
            case .alert: return ""
            case .`where`: return repository.address
            case .tag: return repository.tagKind
            case .memo: return repository.text
            case .count: fatalError("This row is not exist")
            }
        }
    }
    
    fileprivate var presenter: ReminderEditPresenter?
    fileprivate let dataStore =  ReminderDataStoreImpl()
    fileprivate let error = ErrorTracker()
    fileprivate let disposeBag = DisposeBag()
    
    func inject(presenter: ReminderEditPresenter) {
        self.presenter = presenter
    }
    
    override func viewDidLoad() {
        ReminderEditViewControllerBuilder.rebuild(self)
        if self.repositories == nil {
            self.repositories = self.presenter?.preCreate()
        }
        self.configTableView()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? TextFieldViewController, segue.identifier == R.segue.reminderEditViewController.toTextField.identifier {
            vc.delegate = self
            switch Section.init(rawValue: self.indexPath.section)! {
            case .title:
                switch TitleRow.init(rawValue: self.indexPath.row)! {
                case .title: vc.repository = self.repositories.title
                default: break
                }
            case .reminder:
                switch ReminderRow.init(rawValue: self.indexPath.row)! {
                case .alerm:
                    //vc.repository = "\(repositories.time)"
                    self.parentMode = true
                case .span: vc.repository = "\(repositories.span)"
                case .repeat: vc.repository = "\(repositories.repeat)"
                case .alert: break
                case .where: break
                case .tag:
                    vc.repository = repositories.tagKind
                case .memo: vc.repository = repositories.text
                case .count: break
                }
            case .count: break
            }
        } else if let vc = segue.destination as? MapViewController, segue.identifier == R.segue.reminderEditViewController.toMap.identifier {
            vc.repositories = self.repositories
        }
    }
    
    func configTableView() {
        //guard self.repositories != nil else { return  }
        tableView.register(R.nib.textFieldTableViewCell(), forCellReuseIdentifier: R.nib.textFieldTableViewCell.name)
        tableView.register(R.nib.switchTableViewCell(), forCellReuseIdentifier: R.nib.switchTableViewCell.name)
        tableView.register(R.nib.reminderMemoTableViewCell(), forCellReuseIdentifier: R.nib.reminderMemoTableViewCell.name)
        tableView.register(R.nib.thinkTableViewCell(), forCellReuseIdentifier: R.nib.thinkTableViewCell.name)
        tableView.register(R.nib.mainTableViewHeaderView(), forHeaderFooterViewReuseIdentifier: R.nib.mainTableViewHeaderView.name)
        tableView.estimatedRowHeight = 84
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 75))
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func tapClose() {
        //self.delegate?.pop(repositories: self.repositories)
        self.navigationController?.popViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
    }
    
    func tapNext() {
        self.presenter?.create(repositories: self.repositories)
    }
}

extension ReminderEditViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return Section.count.rawValue
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let section = Section.init(rawValue: section) else { fatalError("This row is not exist")}
        return section.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let section = Section.init(rawValue: indexPath.section) else { fatalError("This row is not exist")}
        switch section {
        case .title: return self.tableView(tableView,cellForTaskRowAt: indexPath)
        case .reminder: return self.tableView(tableView,cellForReminderRowAt: indexPath)
        case .count: fatalError("This row is not exist")
        }
    }
    
    private func tableView(_ tableView: UITableView, cellForTaskRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let row = TitleRow.init(rawValue: indexPath.section) else { fatalError("This row is not exist")}
        guard let cell = tableView.dequeueReusableCell(withIdentifier: R.nib.thinkTableViewCell.name) as? ThinkTableViewCell else {
            fatalError("This row is not exist")
        }
        cell.titleLabel.text = row.string
        cell.placeholderMode()
        cell.titleLabel.text = self.repositories.title != "" ? self.repositories.title : R.string.localizable.title()
        self.repositories.title != "" ? cell.defaultTextMode() : cell.placeholderMode()
        return cell
    }
    
    private func tableView(_ tableView: UITableView, cellForReminderRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let row = ReminderRow.init(rawValue: indexPath.row) else { fatalError("This row is not exist")}
        switch row {
        case .alert: return self.tableView(tableView,cellForSwitchRowAt: indexPath)
        case .memo: return self.tableView(tableView,cellForMemoRowAt: indexPath)
        default: break
        }
        guard let cell = tableView.dequeueReusableCell(withIdentifier: R.nib.textFieldTableViewCell.name) as? TextFieldTableViewCell else {
            fatalError("This row is not exist")
        }
        cell.titleLabel.text = row.string
        cell.detailLabel.text = row.value(self.repositories) != "" && row.value(self.repositories) != row.string ? row.value(self.repositories) : row.string
        row.value(self.repositories) != "" && row.value(self.repositories) != row.string ? cell.defaultTextMode() : cell.placeholderMode()
        return cell
    }
    
    private func tableView(_ tableView: UITableView, cellForSwitchRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let row = ReminderRow.init(rawValue: indexPath.row) else { fatalError("This row is not exist")}
        guard let cell = tableView.dequeueReusableCell(withIdentifier: R.nib.switchTableViewCell.name) as? SwitchTableViewCell else {
            fatalError("This row is not exist")
        }
        cell.switch.isOn = self.repositories.notification
        cell.switch.addTarget(self, action: #selector(self.switchClick(sender:)), for: UIControlEvents.valueChanged)
        cell.titleLabel.text = row.string
        return cell
    }
    
    func switchClick(sender: UISwitch){
        self.repositories.notification = sender.isOn
    }
    
    private func tableView(_ tableView: UITableView, cellForMemoRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let row = ReminderRow.init(rawValue: indexPath.row) else { fatalError("This row is not exist")}
        guard let cell = tableView.dequeueReusableCell(withIdentifier: R.nib.reminderMemoTableViewCell.name) as? ReminderMemoTableViewCell else {
            fatalError("This row is not exist")
        }
        cell.titleLabel.text = row.string
        cell.detailLabel.text = self.repositories.text != "" ? self.repositories.text : R.string.localizable.newFilePlaceholder()
        cell.detailLabel.textColor = self.repositories.text != "" ? Constant.baseStringColor : Constant.basePlaceHolderColor
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let section = Section.init(rawValue: section) else { fatalError("This row is not exist")}
        guard let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: R.nib.mainTableViewHeaderView.name) as? MainTableViewHeaderView else {
            fatalError("This section is not exist")
        }
        view.titleLabel.setHelveticaNeueMediumFontSize(20)
        view.titleLabel.text = section.string
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        self.indexPath = indexPath
        if indexPath.section == Section.reminder.rawValue, indexPath.row ==  ReminderRow.where.rawValue {
            self.performSegue(withIdentifier: R.segue.reminderEditViewController.toMap.identifier, sender: nil)
        }
        self.performSegue(withIdentifier: R.segue.reminderEditViewController.toTextField.identifier, sender: nil)
    }
}

extension ReminderEditViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (self.tableView.contentOffset.y <= 44 && self.tableView.contentOffset.y >= 0) {
            self.tableView.contentInset = UIEdgeInsets(top: -scrollView.contentOffset.y, left: 0, bottom: 0, right: 0)
        } else if (self.tableView.contentOffset.y >= 44) {
            self.tableView.contentInset = UIEdgeInsets(top: -44, left: 0, bottom: 00, right: 0)
        }
    }
}

extension ReminderEditViewController: ReminderEditPresenterInput {
    func onError() {
        
    }
    
    func showLoadingView() {
        
    }
    
    func hideLoadingView() {
        
    }
    
    func create(didCreateRepository repositories: ReminderModel) {
        self.delegate?.pop(repositories: self.repositories)
        self.navigationController?.popViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
    }
}

extension ReminderEditViewController: TextFieldViewControllerDelegate {
    var currentSmart: SmartProperty {
        get {
            return SmartProperty.empty
        }
        set {
        }
    }
    
    var smart: SmartModel? {
        get {
            return nil
        }
        set {
        }
    }
    
    func pop(_ text: String) {
        self.parentMode = false
        switch Section.init(rawValue: self.indexPath.section)! {
        case .title:
            switch TitleRow.init(rawValue: self.indexPath.row)! {
            case .title: self.repositories.title = text
            default: break
            }
        case .reminder:
            switch ReminderRow.init(rawValue: self.indexPath.row)! {
            case .alerm: repositories.time = text.getUTCDateyyyyMMddHHmm() ?? Date.CurrentDate()
            case .span: repositories.span = Int(text)!
            case .repeat: repositories.repeat = Int(text)!
            case .alert: break
            case .where: break
            case .tag:
                //TODO:
                //guard let tag = Tag.init(rawValue: text) else { repositories.tagKind = text; return }
                repositories.tagKind = text
                repositories.tagUid = NSUUID().uuidString
            case .memo: repositories.text = text
            case .count: break
            }
        case .count: break
        }
        self.tableView.reloadData()
    }
    
    var datePickerMode: Bool {
        get {
            return self.parentMode
        }
        set { }
    }
}
