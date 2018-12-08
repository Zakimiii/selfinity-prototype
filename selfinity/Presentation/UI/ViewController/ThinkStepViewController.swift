//
//  ThinkStepViewController.swift
//  selfinity
//
//  Created by Apple on 2018/10/15.
//  Copyright © 2018年 Apple. All rights reserved.
//

import UIKit
import RxSwift
import Toaster

protocol ThinkStepsViewControllerDelegate {
    func pop(repositories: GoalModel)
}

@objcMembers
class ThinkStepViewController: UIViewController {
    @IBOutlet weak var nextButton: GradationButton! {
        didSet {
            nextButton.button.addTarget(self, action: #selector(self.tapNext), for: .touchUpInside)
        }
    }
    @IBOutlet weak var headerView: ThinkHeaderView! {
        didSet {
            headerView.onlyCloseMode()
            headerView.titileLabel.setHelveticaNeueMediumFontSize(42)
            headerView.closeButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.tapClose)))
            headerView.closeButton.button.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.tapClose)))
        }
    }
    @IBOutlet weak var tableView: UITableView!
    
    enum ThinkRow: Int {
        case goal
        case count
        
        var string: String {
            switch self {
            case .goal: return R.string.localizable.thinkStepPlaceholder()
            case .count: fatalError("This row is not exist")
            }
        }
    }
    var delegate: ThinkStepsViewControllerDelegate!
    var repositories: GoalModel!
    fileprivate var presenter: ThinkStepPresenter?
    fileprivate let dataStore =  HomeDataStoreImpl()
    fileprivate let error = ErrorTracker()
    fileprivate let disposeBag = DisposeBag()
    var index: Int!
    
    func inject(presenter: ThinkStepPresenter) {
        self.presenter = presenter
    }
    
    func configTableView() {
        tableView.register(R.nib.thinkTableViewCell(), forCellReuseIdentifier: R.nib.thinkTableViewCell.name)
        tableView.register(R.nib.mainTableViewHeaderView(), forHeaderFooterViewReuseIdentifier: R.nib.mainTableViewHeaderView.name)
        tableView.estimatedRowHeight = 84
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 75))
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewDidLoad() {
        ThinkStepViewControllerBuilder.rebuild(self)
        guard self.repositories != nil else { self.presenter?.preIndex(); return }
        self.configTableView()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? ThinkStepEditViewController, segue.identifier == R.segue.thinkStepViewController.toEdit.identifier {
            vc.delegate = self
            guard let step = self.repositories.steps[safe: index] else {
                vc.repositories = StepModel.init(uid: NSUUID().uuidString,
                                                 text: "",
                                                 credit: 0,
                                                 smart: SmartModel.init(uid: NSUUID().uuidString,
                                                                        specificSubject: "",
                                                                        specificVerb: "",
                                                                        timeBound: "",
                                                                        measurable: "",
                                                                        owner: CurrentPrunedUser.getToCurrentPrunedUserModel()!,
                                                                        private: false,
                                                                        createdAt: Date.CurrentDate(),
                                                                        updatedAt: Date.CurrentDate()),
                                                 tasks: [],
                                                 owner: CurrentPrunedUser.getToCurrentPrunedUserModel()!,
                                                 private: false,
                                                 createdAt: Date.CurrentDate(),
                                                 updatedAt: Date.CurrentDate())
                return
            }
            vc.repositories = step
        } else if let vc = segue.destination as? ThinkStepIndexViewController, segue.identifier == R.segue.thinkStepViewController.toIndex.identifier {
            DispatchQueue.main.async {
                vc.repositories = self.repositories
                vc.delegate = self
            }
        }
    }
    
    func tapClose() {
        self.delegate?.pop(repositories: self.repositories)
        self.navigationController?.popViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
    }
    
    func tapNext() {
        //TODO: Validation
        self.performSegue(withIdentifier: R.segue.thinkStepViewController.toIndex, sender: nil)
    }
}

extension ThinkStepViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.repositories.steps.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row < self.repositories.steps.count {
        case true: return self.tableView(tableView, cellForThinkRowAt: indexPath)
        case false: return self.tableView(tableView, cellForCountRowAt: indexPath)
        }
    }
    
    private func tableView(_ tableView: UITableView, cellForThinkRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: R.nib.thinkTableViewCell.name) as? ThinkTableViewCell else {
            fatalError("This row is not exist")
        }
        cell.titleLabel.text = self.repositories.steps[indexPath.row].smart.createJAText()
        cell.defaultTextMode()
        return cell
    }
    
    private func tableView(_ tableView: UITableView, cellForCountRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: R.nib.thinkTableViewCell.name) as? ThinkTableViewCell else {
            fatalError("This row is not exist")
        }
        cell.titleLabel.text = ThinkRow.goal.string
        cell.placeholderMode()
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        self.index = indexPath.row
        self.presenter?.toEdit()
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: R.nib.mainTableViewHeaderView.name) as? MainTableViewHeaderView else {
            fatalError("This section is not exist")
        }
        view.titleLabel.text = R.string.localizable.thinkStep()
        view.setFontSize(30)
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 84
    }
}

extension ThinkStepViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (self.tableView.contentOffset.y <= 84 && self.tableView.contentOffset.y >= 0) {
            self.tableView.contentInset = UIEdgeInsets(top: -scrollView.contentOffset.y, left: 0, bottom: 0, right: 0)
        } else if (self.tableView.contentOffset.y >= 84) {
            self.tableView.contentInset = UIEdgeInsets(top: -84, left: 0, bottom: 00, right: 0)
        }
    }
}

extension ThinkStepViewController: ThinkStepPresenterInput {
    func preIndex(didFetchRepository repository: GoalModel) {
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

extension ThinkStepViewController: ThinkStepEditViewControllerDelegate {
    func pop(repositories: StepModel) {
        guard let unwrappedIndex = self.repositories.steps.index(of: repositories),let step = self.repositories.steps[safe: unwrappedIndex] else {
            self.repositories.steps.insert(repositories, at: 0)
            self.tableView.reloadData()
            return
        }
        self.repositories.steps[unwrappedIndex] = step
        self.tableView.reloadData()
    }
}

extension ThinkStepViewController: ThinkStepIndexViewControllerDelegate {
    func pop(repositories: GoalModel) {
        self.repositories = repositories
        self.tableView.reloadData()
    }
}
