//
//  ThinkStepIndexViewController.swift
//  selfinity
//
//  Created by Apple on 2018/10/19.
//  Copyright © 2018年 Apple. All rights reserved.
//

import UIKit
import RxSwift

protocol ThinkStepIndexViewControllerDelegate: class {
    func pop(repositories: GoalModel)
}


@objcMembers
class ThinkStepIndexViewController: UIViewController {
    
    @IBOutlet weak var editButton: GradationButton! {
        didSet {
            editButton.button.addTarget(self, action: #selector(self.tapEdit), for: .touchUpInside)
        }
    }
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
            headerView.titileLabel.text = R.string.localizable.thinkGenerateTask()
        }
    }
    @IBOutlet weak var goalLabel: UILabel!
    @IBOutlet weak var forGoalLabel: UILabel! {
        didSet {
            forGoalLabel.text = R.string.localizable.forAchiveGoal()
        }
    }
    var delegate: ThinkStepIndexViewControllerDelegate!
    var repositories: GoalModel!
    fileprivate var presenter: ThinkStepIndexPresenter?
    fileprivate let dataStore =  HomeDataStoreImpl()
    fileprivate let error = ErrorTracker()
    fileprivate let disposeBag = DisposeBag()
    
    func inject(presenter: ThinkStepIndexPresenter) {
        self.presenter = presenter
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ThinkStepIndexViewControllerBuilder.rebuild(self)
        configTableView()
    }
    
    func configTableView() {
        guard self.repositories != nil else { return  }
        self.goalLabel.text = self.repositories.smart.createJAText()
        
        tableView.register(R.nib.stepListTableViewCell(), forCellReuseIdentifier: R.nib.stepListTableViewCell.name)
        tableView.estimatedRowHeight = 44
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.tableFooterView = UIView()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func tapClose() {
        self.delegate?.pop(repositories: self.repositories)
        self.navigationController?.popViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
    }
    
    func tapNext() {
        self.performSegue(withIdentifier: R.segue.thinkStepIndexViewController.toTask, sender: nil)
    }
    
    func tapEdit() {
        self.tableView.setEditing(true, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? ThinkTaskCreateViewController, segue.identifier == R.segue.thinkStepIndexViewController.toTask.identifier {
            vc.delegate = self
            vc.repositories = self.repositories
        }
    }
}

extension ThinkStepIndexViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.repositories.steps.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: R.nib.stepListTableViewCell.name) as? StepListTableViewCell else {
            fatalError("This row is not exist")
        }
        cell.titleLabel.text = self.repositories.steps[indexPath.row].smart.createJAText()
        return cell
    }
}

extension ThinkStepIndexViewController: ThinkTaskCreateViewControllerDelegate {
    func pop(repositories: GoalModel) {
        self.repositories = repositories
        self.tableView.reloadData()
    }
}

extension ThinkStepIndexViewController: ThinkStepIndexPresenterInput {
    func onErrorIndex() {
    }
    
    func showLoadingView() {
    }
    
    func hideLoadingView() {
    }
}
