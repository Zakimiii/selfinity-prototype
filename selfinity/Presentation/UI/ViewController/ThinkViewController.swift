//
//  ThinkViewController.swift
//  selfinity
//
//  Created by Apple on 2018/10/07.
//  Copyright © 2018年 Apple. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import SCLAlertView
import Toaster

@objcMembers
class ThinkViewController: UIViewController {
    @IBOutlet weak var headerView: ThinkHeaderView! {
        didSet {
            headerView.buttonHideMode()
        }
    }
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.isScrollEnabled = false
            tableView.register(R.nib.thinkTableViewCell(), forCellReuseIdentifier: R.nib.thinkTableViewCell.name)
            tableView.register(R.nib.searchBarTableViewCell(), forCellReuseIdentifier: R.nib.searchBarTableViewCell.name)
            tableView.register(R.nib.mainTableViewHeaderView(), forHeaderFooterViewReuseIdentifier: R.nib.mainTableViewHeaderView.name)
            tableView.estimatedRowHeight = 84
            tableView.rowHeight = UITableViewAutomaticDimension
            tableView.tableFooterView = UIView()
            tableView.delegate = self
            tableView.dataSource = self
        }
    }
    fileprivate var presenter: ThinkPresenter?
    fileprivate let dataStore =  HomeDataStoreImpl()
    fileprivate let error = ErrorTracker()
    fileprivate let disposeBag = DisposeBag()
    
    func inject(presenter: ThinkPresenter) {
        self.presenter = presenter
    }
    
    enum ThinkRow: Int {
        case search
        case new
        case goal
        case step
        case improve
        case count
        
        var string: String {
            switch self {
            case .search: return ""
            case .new: return R.string.localizable.thinkNew()
            case .goal: return R.string.localizable.thinkFromGoal()
            case .step: return R.string.localizable.thinkFromStep()
            case .improve: return R.string.localizable.thinkYourPlan()
            case .count: fatalError("This row is not exist")
            }
        }
    }
    
    override func viewDidLoad() {
        ThinkViewControllerBuilder.rebuild(self)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if let vc = self.homeVC, vc.cache != nil  {
            self.tabBarController?.selectedViewController = self.tabBarController?.viewControllers?[0]
        }
    }
    
    func tapSearch() {
        self.presenter?.didTapSearchThinkCell()
    }
    
}

extension  ThinkViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ThinkRow.count.rawValue
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let section = ThinkRow.init(rawValue: indexPath.row) else {
            fatalError("This row is not exist")
        }
        switch section {
        case .search: return self.tableView(tableView, cellForSearchRowAt: indexPath)
        case .new: return self.tableView(tableView, cellForThinkRowAt: indexPath)
        case .goal: return self.tableView(tableView, cellForThinkRowAt: indexPath)
        case .step: return self.tableView(tableView, cellForThinkRowAt: indexPath)
        case .improve: return self.tableView(tableView, cellForThinkRowAt: indexPath)
        case .count: fatalError("This row is not exist")
        }
    }
    
    private func tableView(_ tableView: UITableView, cellForSearchRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: R.nib.searchBarTableViewCell.name) as? SearchBarTableViewCell else {
            fatalError("This row is not exist")
        }
        cell.searchBar.searchField.isEnabled = false
        cell.searchBar.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.tapSearch)))
        return cell
    }
    
    private func tableView(_ tableView: UITableView, cellForThinkRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let section = ThinkRow.init(rawValue: indexPath.row) else {
            fatalError("This row is not exist")
        }
        guard let cell = tableView.dequeueReusableCell(withIdentifier: R.nib.thinkTableViewCell.name) as? ThinkTableViewCell else {
            fatalError("This row is not exist")
        }
        cell.titleLabel.text = section.string
        cell.titleLabel.textColor = Constant.subColor
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        guard let section = ThinkRow.init(rawValue: indexPath.row) else {
            fatalError("This row is not exist")
        }
        switch section {
        case .search: self.presenter?.didTapSearchThinkCell()
        case .new: self.presenter?.didTapNewThinkCell()
        case .goal: self.presenter?.didTapGoalThinkCell()
        case .step: self.presenter?.didTapStepThinkCell()
        case .improve: break
        case .count: fatalError("This row is not exist")
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: R.nib.mainTableViewHeaderView.name) as? MainTableViewHeaderView else {
            fatalError("This section is not exist")
        }
        view.titleLabel.text = R.string.localizable.thinkStart()
        view.setFontSize(24)
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
}

extension ThinkViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (self.tableView.contentOffset.y <= 84 && self.tableView.contentOffset.y >= 0) {
            self.tableView.contentInset = UIEdgeInsets(top: -scrollView.contentOffset.y, left: 0, bottom: 0, right: 0)
        } else if (self.tableView.contentOffset.y >= 84) {
            self.tableView.contentInset = UIEdgeInsets(top: -84, left: 0, bottom: 00, right: 0)
        }
    }
}

extension ThinkViewController: ThinkPresenterInput {
    
}
