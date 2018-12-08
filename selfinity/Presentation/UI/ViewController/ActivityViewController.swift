//
//  ActivityViewController.swift
//  selfinity
//
//  Created by Apple on 2018/10/07.
//  Copyright © 2018年 Apple. All rights reserved.
//

import UIKit

class ActivityViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.register(R.nib.homeTableViewCell(), forCellReuseIdentifier: R.nib.homeTableViewCell.name)
            tableView.register(R.nib.mainTableViewHeaderView(), forHeaderFooterViewReuseIdentifier: R.nib.mainTableViewHeaderView.name)
            tableView.estimatedRowHeight = 84
            tableView.rowHeight = UITableViewAutomaticDimension
            tableView.tableFooterView = UIView()
            tableView.delegate = self
            tableView.dataSource = self
        }
    }
}

extension ActivityViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: R.nib.homeTableViewCell.name) as? HomeTableViewCell else {
            fatalError("This row is not exist")
        }
        cell.valueLabel?.font = UIFont(name: Constant.fontMedium, size: 44)
        cell.valueLabel?.textColor = Constant.subColor
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        //        guard let section = Section(rawValue: section), !section.string.isEmpty else {
        //            fatalError("This section is not exist")
        //        }
        guard let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: R.nib.mainTableViewHeaderView.name) as? MainTableViewHeaderView else {
            return nil
        }
        view.titleLabel.text = R.string.localizable.mainTabText4()
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        //        guard let section = Section(rawValue: section), !section.string.isEmpty else {
        //            fatalError("This section is not exist")
        //        }
        return 84
    }
}

extension ActivityViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (self.tableView.contentOffset.y <= 84 && self.tableView.contentOffset.y >= 0) {
            self.tableView.contentInset = UIEdgeInsets(top: -scrollView.contentOffset.y, left: 0, bottom: 0, right: 0)
        } else if (self.tableView.contentOffset.y >= 84) {
            self.tableView.contentInset = UIEdgeInsets(top: -84, left: 0, bottom: 00, right: 0)
        }
    }
}
