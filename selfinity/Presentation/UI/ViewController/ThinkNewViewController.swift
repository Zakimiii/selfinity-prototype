//
//  ThinkNewViewController.swift
//  selfinity
//
//  Created by Apple on 2018/10/15.
//  Copyright © 2018年 Apple. All rights reserved.
//

import UIKit
import RxSwift

@objcMembers
class ThinkNewViewController: UIViewController {
    @IBOutlet weak var headerView: ThinkHeaderView! {
        didSet {
            headerView.onlyCloseMode()
            headerView.titileLabel.setHelveticaNeueMediumFontSize(42)
            headerView.closeButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.tapClose)))
            headerView.closeButton.button.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.tapClose)))
        }
    }
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.register(R.nib.searchResultTableViewCell(), forCellReuseIdentifier: R.nib.searchResultTableViewCell.name)
            tableView.register(R.nib.searchBarTableViewCell(), forCellReuseIdentifier: R.nib.searchBarTableViewCell.name)
            tableView.register(R.nib.pagenationTableViewCell(), forCellReuseIdentifier: R.nib.pagenationTableViewCell.name)
            tableView.register(R.nib.mainTableViewHeaderView(), forHeaderFooterViewReuseIdentifier: R.nib.mainTableViewHeaderView.name)
            tableView.estimatedRowHeight = 84
            tableView.rowHeight = UITableViewAutomaticDimension
            tableView.tableFooterView = UIView()
            tableView.delegate = self
            tableView.dataSource = self
        }
    }
    
    fileprivate var presenter: ThinkNewPresenter?
    fileprivate let dataStore =  HomeDataStoreImpl()
    fileprivate let error = ErrorTracker()
    fileprivate let disposeBag = DisposeBag()
    
    func inject(presenter: ThinkNewPresenter) {
        self.presenter = presenter
    }
    
    enum Section: Int {
        case search
        case result
        case page
        case count
        
        var string: String {
            switch self {
            case .search: return R.string.localizable.interest()
            case .result: return R.string.localizable.result()
            case .page: return ""
            case .count: fatalError("This row is not exist")
            }
        }
        
        var count: Int {
            switch self {
            case .search: return SearchRow.count.rawValue
            case .result: return ResultRow.count.rawValue
            case .page: return PageRow.count.rawValue
            case .count: fatalError("This row is not exist")
            }
        }
    }
    
    private enum SearchRow: Int {
        case search
        case count
    }
    
    private enum ResultRow: Int {
        case result0
        case result1
        case result2
        case result3
        case result4
        case result5
        case result6
        case result7
        case result8
        case result9
        case count
    }
    
    private enum PageRow: Int {
        case page
        case count
    }
    
    override func viewDidLoad() {
        ThinkNewViewControllerBuilder.rebuild(self)
    }
    
    func tapClose() {
        self.navigationController?.popViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
    }
}

extension  ThinkNewViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return Section.count.rawValue
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Section.init(rawValue: section)!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let section = Section.init(rawValue: indexPath.section) else {
            fatalError("This row is not exist")
        }
        switch section {
        case .search: return self.tableView(tableView, cellForSearchRowAt: indexPath)
        case .result: return self.tableView(tableView, cellForResultRowAt: indexPath)
        case .page: return self.tableView(tableView, cellForPageRowAt: indexPath)
        case .count: fatalError("This row is not exist")
        }
    }
    
    private func tableView(_ tableView: UITableView, cellForSearchRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: R.nib.searchBarTableViewCell.name) as? SearchBarTableViewCell else {
            fatalError("This row is not exist")
        }
        return cell
    }
    
    private func tableView(_ tableView: UITableView, cellForResultRowAt indexPath: IndexPath) -> UITableViewCell {
        guard ResultRow.init(rawValue: indexPath.row) != nil else {
            fatalError("This row is not exist")
        }
        guard let cell = tableView.dequeueReusableCell(withIdentifier: R.nib.searchResultTableViewCell.name) as? SearchResultTableViewCell else {
            fatalError("This row is not exist")
        }
        return cell
    }
    
    private func tableView(_ tableView: UITableView, cellForPageRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: R.nib.pagenationTableViewCell.name) as? PagenationTableViewCell else {
            fatalError("This row is not exist")
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        guard let section = Section.init(rawValue: indexPath.section) else {
            fatalError("This row is not exist")
        }
        switch section {
        case .search: break
        case .result: break
        case .page: break
        case .count: fatalError("This row is not exist")
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let section = Section.init(rawValue: section) else {
            fatalError("This row is not exist")
        }
        guard let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: R.nib.mainTableViewHeaderView.name) as? MainTableViewHeaderView else {
            fatalError("This section is not exist")
        }
        switch section {
        case .search:
            view.titleLabel.text = section.string
            view.setFontSize(30)
            return view
        case .result:
            view.titleLabel.text = section.string
            view.setFontSize(30)
            view.titleLabel.textColor = Constant.mainColor
            return view
        case .page:
            return UIView()
        case .count: fatalError("This row is not exist")
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        guard let section = Section.init(rawValue: section) else {
            fatalError("This row is not exist")
        }
        switch section {
        case .search: return 84
        case .result: return 84
        case .page: return 0
        case .count: fatalError("This row is not exist")
        }
    }
}

extension ThinkNewViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (self.tableView.contentOffset.y <= 84 && self.tableView.contentOffset.y >= 0) {
            self.tableView.contentInset = UIEdgeInsets(top: -scrollView.contentOffset.y, left: 0, bottom: 0, right: 0)
        } else if (self.tableView.contentOffset.y >= 84) {
            self.tableView.contentInset = UIEdgeInsets(top: -84, left: 0, bottom: 00, right: 0)
        }
    }
}

extension ThinkNewViewController: ThinkNewPresenterInput {
    
}
