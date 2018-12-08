//
//  ThinkTaskCreateViewController.swift
//  selfinity
//
//  Created by Apple on 2018/10/19.
//  Copyright © 2018年 Apple. All rights reserved.
//

import UIKit
import RxSwift
import Toaster

protocol ThinkTaskCreateViewControllerDelegate: class {
    func pop(repositories: GoalModel)
}

@objcMembers
class ThinkTaskCreateViewController: UIViewController {
    var delegate: ThinkTaskCreateViewControllerDelegate!
    @IBOutlet weak var headerView: ThinkHeaderView! {
        didSet {
            headerView.onlyCloseMode()
            headerView.titileLabel.setHelveticaNeueMediumFontSize(42)
            headerView.closeButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.tapClose)))
            headerView.closeButton.button.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.tapClose)))
            headerView.titileLabel.text = R.string.localizable.thinkGenerateTask()
        }
    }
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var nextButton: GradationButton! {
        didSet {
            nextButton.button.addTarget(self, action: #selector(self.tapComplete), for: .touchUpInside)
        }
    }
    var indexPath: IndexPath!
    var repositories: GoalModel!
    fileprivate var presenter: ThinkTaskCreatePresenter?
    fileprivate let dataStore =  HomeDataStoreImpl()
    fileprivate let error = ErrorTracker()
    fileprivate let disposeBag = DisposeBag()
    
    func inject(presenter: ThinkTaskCreatePresenter) {
        self.presenter = presenter
    }
    
    override func viewDidLoad() {
        ThinkTaskCreateViewControllerBuilder.rebuild(self)
        self.presenter?.index(repositories: self.repositories)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? TaskEditViewController, segue.identifier == R.segue.thinkTaskCreateViewController.toCreate.identifier {
            vc.repositories = self.repositories.steps[indexPath.section].tasks[indexPath.row]
            vc.delegate = self
        }
    }
    
    func configTableView() {
        tableView.register(R.nib.taskListTableViewCell(), forCellReuseIdentifier: R.nib.taskListTableViewCell.name)
        tableView.register(R.nib.stepListTableViewHeaderView(), forHeaderFooterViewReuseIdentifier: R.nib.stepListTableViewHeaderView.name)
        tableView.estimatedRowHeight = 84
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 75))
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func tapClose() {
        self.delegate?.pop(repositories: self.repositories)
        self.navigationController?.popViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
    }
    
    func tapComplete() {
        self.presenter?.create(repositories: self.repositories)
    }
}

extension ThinkTaskCreateViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.repositories.steps.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.repositories.steps[section].tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: R.nib.taskListTableViewCell.name) as? TaskListTableViewCell else {
            fatalError("This row is not exist")
        }
        cell.titleLabel.text = self.repositories.steps[indexPath.section].tasks[indexPath.row].smart.createJAText()
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: R.nib.stepListTableViewHeaderView.name) as? StepListTableViewHeaderView else {
            fatalError("This section is not exist")
        }
        view.titleLabel.text = self.repositories.steps[section].smart.createJAText()
        view.detailLabel.text = R.string.localizable.forAchiveTask()
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 174
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (self.tableView.contentOffset.y <= 174 && self.tableView.contentOffset.y >= 0) {
            self.tableView.contentInset = UIEdgeInsets(top: -scrollView.contentOffset.y, left: 0, bottom: 0, right: 0)
        } else if (self.tableView.contentOffset.y >= 174) {
            self.tableView.contentInset = UIEdgeInsets(top: -174, left: 0, bottom: 00, right: 0)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        self.indexPath = indexPath
        performSegue(withIdentifier: R.segue.thinkTaskCreateViewController.toCreate.identifier, sender: nil)
    }
}

extension ThinkTaskCreateViewController: ThinkTaskCreatePresenterInput {
    func index(didFetchRepository repository: GoalModel) {
        self.repositories = repository
        configTableView()
    }
    
    func onErrorIndex() {
    }
    
    func showLoadingView() {
    }
    
    func hideLoadingView() {
    }
    
    func create(didCreateRepository repository: GoalModel) {
        if let vc = self.homeVC {
            vc.cache = self.repositories
        }
        self.delegate?.pop(repositories: repository)
        self.dismiss(animated: true, completion: nil)
    }
}

extension ThinkTaskCreateViewController: TaskEditViewControllerDelegate {
    func pop(repositories: TaskModel) {
        self.repositories.steps[indexPath.section].tasks[indexPath.row] = repositories
        self.tableView.reloadData()
    }
}
