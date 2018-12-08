//
//  ThinkGoalViewController.swift
//  selfinity
//
//  Created by Apple on 2018/10/15.
//  Copyright © 2018年 Apple. All rights reserved.
//

import UIKit
import RxSwift
import Toaster

@objcMembers
class ThinkGoalViewController: UIViewController {

    @IBOutlet weak var headerView: ThinkHeaderView! {
        didSet {
            headerView.onlyCloseMode()
            headerView.titileLabel.setHelveticaNeueMediumFontSize(42)
            headerView.closeButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.tapClose)))
            headerView.closeButton.button.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.tapClose)))
        }
    }
    @IBOutlet weak var nextButton: GradationButton! {
        didSet {
            nextButton.button.addTarget(self, action: #selector(self.tapNext), for: .touchUpInside)
        }
    }
    @IBOutlet weak var tableView: UITableView!
    
    enum ThinkRow: Int {
        case subject
        case verb
        case measurable
        case time
        case count
        
        var string: String {
            switch self {
            case .subject: return R.string.localizable.subject()
            case .verb: return R.string.localizable.verb()
            case .measurable: return R.string.localizable.measurable()
            case .time: return R.string.localizable.timeBound()
            case .count: fatalError("This row is not exist")
            }
        }
        
        func getSmart(smart: SmartModel) -> String {
            switch self {
            case .subject:
                if smart.specificSubject == "" {
                    return self.string
                } else {
                    return smart.specificSubject
                }
            case .verb:
                if smart.specificVerb == "" {
                    return self.string
                } else {
                    return smart.specificVerb
                }
            case .measurable:
                if smart.measurable == "" {
                    return self.string
                } else {
                    return smart.measurable
                }
            case .time:
                if smart.timeBound == "" {
                    return self.string
                } else {
                    return smart.timeBound
                }
            case .count: fatalError("This row is not exist")
            }
        }
        
        func checkSmart(smart: SmartModel) -> Bool {
            switch self {
            case .subject:
                if smart.specificSubject == "" {
                    return false
                } else {
                    return true
                }
            case .verb:
                if smart.specificVerb == "" {
                    return false
                } else {
                    return true
                }
            case .measurable:
                if smart.measurable == "" {
                    return false
                } else {
                    return true
                }
            case .time:
                if smart.timeBound == "" {
                    return false
                } else {
                    return true
                }
            case .count: fatalError("This row is not exist")
            }
        }
    }
    var currentSection: ThinkRow = .count
    var repositories: GoalModel!
    var nextPickerMode = false
    fileprivate var presenter: ThinkGoalPresenter?
    fileprivate let dataStore =  HomeDataStoreImpl()
    fileprivate let error = ErrorTracker()
    fileprivate let disposeBag = DisposeBag()
    
    func inject(presenter: ThinkGoalPresenter) {
        self.presenter = presenter
    }
    
    override func viewDidLoad() {
        ThinkGoalViewControllerBuilder.rebuild(self)
        self.presenter?.preIndex()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? TextFieldViewController, segue.identifier == R.segue.thinkGoalViewController.toTextField.identifier {
            vc.delegate = self
            vc.uiDatePickerMode = .date
            if currentSection.checkSmart(smart: self.repositories.smart) {
                vc.repository = currentSection.getSmart(smart: self.repositories.smart)
            } else {
                vc.placeholder = currentSection.getSmart(smart: self.repositories.smart)
            }
        } else if let vc = segue.destination as? ThinkStepViewController, segue.identifier == R.segue.thinkGoalViewController.toStep.identifier {
            vc.repositories = self.repositories
        }
    }
    
    fileprivate func configTableView() {
        tableView.register(R.nib.thinkTableViewCell(), forCellReuseIdentifier: R.nib.thinkTableViewCell.name)
        tableView.register(R.nib.mainDetailTableHeaderView(), forHeaderFooterViewReuseIdentifier: R.nib.mainDetailTableHeaderView.name)
        tableView.estimatedRowHeight = 84
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 75))
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func tapClose() {
        self.navigationController?.popViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
    }
    
    func tapNext() {
        guard self.repositories.smart.specificSubject != "" &&
              self.repositories.smart.specificVerb != "" &&
              self.repositories.smart.measurable != "" &&
              self.repositories.smart.timeBound != "" else {
                Toast(text: R.string.localizable.validateAllPlaceholder()).show()
                return
        }
        self.performSegue(withIdentifier: R.segue.thinkGoalViewController.toStep.identifier, sender: nil)
    }
}

extension ThinkGoalViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ThinkRow.count.rawValue
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let section = ThinkRow.init(rawValue: indexPath.row) else {
            fatalError("This row is not exist")
        }
        switch section {
        case .count: fatalError("This row is not exist")
        default: return self.tableView(tableView, cellForThinkRowAt: indexPath)
        }
    }
    
    private func tableView(_ tableView: UITableView, cellForThinkRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let section = ThinkRow.init(rawValue: indexPath.row) else {
            fatalError("This row is not exist")
        }
        guard let cell = tableView.dequeueReusableCell(withIdentifier: R.nib.thinkTableViewCell.name) as? ThinkTableViewCell else {
            fatalError("This row is not exist")
        }
        cell.titleLabel.text = section.getSmart(smart: self.repositories.smart)
        section.checkSmart(smart: self.repositories.smart) ? cell.defaultTextMode() : cell.placeholderMode()
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        guard let section = ThinkRow.init(rawValue: indexPath.row) else {
            fatalError("This row is not exist")
        }
        self.currentSection = section
        switch section {
        case .subject: self.performSegue(withIdentifier: R.segue.thinkGoalViewController.toTextField, sender: nil)
        case .verb: self.performSegue(withIdentifier: R.segue.thinkGoalViewController.toTextField, sender: nil)
        case .measurable: self.performSegue(withIdentifier: R.segue.thinkGoalViewController.toTextField, sender: nil)
        case .time:
            self.nextPickerMode = true
            self.performSegue(withIdentifier: R.segue.thinkGoalViewController.toTextField, sender: nil)
        case .count: fatalError("This row is not exist")
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: R.nib.mainDetailTableHeaderView.name) as? MainDetailTableHeaderView else {
            fatalError("This section is not exist")
        }
        view.titleLabel.text = R.string.localizable.thinkGoal()
        view.detailLabel.text = self.repositories.smart.specificSubject != "" ||  self.repositories.smart.specificVerb != "" || self.repositories.smart.measurable != "" || self.repositories.smart.timeBound != "" ? R.string.localizable.yourGoal() + self.repositories.smart.createJAText() : R.string.localizable.thinkGoalDetail()
        self.repositories.smart.specificSubject != "" ||  self.repositories.smart.specificVerb != "" || self.repositories.smart.measurable != "" || self.repositories.smart.timeBound != "" ? view.strongTextMode() : view.defaultTextMode()
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 140
    }
}

extension ThinkGoalViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (self.tableView.contentOffset.y <= 140 && self.tableView.contentOffset.y >= 0) {
            self.tableView.contentInset = UIEdgeInsets(top: -scrollView.contentOffset.y, left: 0, bottom: 0, right: 0)
        } else if (self.tableView.contentOffset.y >= 140) {
            self.tableView.contentInset = UIEdgeInsets(top: -140, left: 0, bottom: 00, right: 0)
        }
    }
}

extension ThinkGoalViewController: ThinkGoalPresenterInput {
    
    func preIndex( didFetchRepository repository: GoalModel) {
        self.repositories = repository
        self.configTableView()
    }
    
    func onErrorIndex() {
        
    }
    
    func showLoadingView() {
        
    }
    
    func hideLoadingView() {
        
    }
}

extension ThinkGoalViewController: TextFieldViewControllerDelegate {
    var currentSmart: SmartProperty {
        get {
            return self.repositories.smart.specificSubject != "" ||  self.repositories.smart.specificVerb != "" || self.repositories.smart.measurable != "" || self.repositories.smart.timeBound != "" ? SmartProperty.init(rawValue: currentSection.rawValue)! : .empty
        }
        set {
        }
    }
    
    var smart: SmartModel? {
        get {
            return self.repositories.smart
        }
        set {
        }
    }
    
    var datePickerMode: Bool {
        get {
            return self.nextPickerMode
        }
        set { }
    }
    
    func pop(_ text: String) {
        switch currentSection {
        case .subject: self.repositories.smart.specificSubject = text
        case .verb: self.repositories.smart.specificVerb = text
        case .measurable: self.repositories.smart.measurable = text
        case .time: self.repositories.smart.timeBound = text
        case .count: break
        }
        self.nextPickerMode = false
        self.tableView.reloadData()
    }
}

extension ThinkGoalViewController: ThinkStepsViewControllerDelegate {
    func pop(repositories: GoalModel) {
        self.repositories = repositories
    }
}
