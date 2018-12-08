//
//  HomeRowTableViewCell.swift
//  selfinity
//
//  Created by Apple on 2018/10/09.
//  Copyright © 2018年 Apple. All rights reserved.
//

import UIKit

class HomeRowTableViewCell: UITableViewCell {

    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.register(R.nib.homeRowTableViewCell(), forCellReuseIdentifier: R.nib.homeRowTableViewCell.name)
            tableView.estimatedRowHeight = 64
            tableView.rowHeight = UITableViewAutomaticDimension
            tableView.tableFooterView = UIView()
            tableView.delegate = self
            tableView.dataSource = self
        }
    }
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint! {
        didSet {
            tableViewHeight.constant = HomeRowTableViewCell.getSize(self.items.count).height
        }
    }
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    var items: [Int] = [1, 2, 3]
    
    class func getSize(_ count: Int) -> CGSize {
        let width = UIScreen.main.bounds.width - (20 * 2)
        let height = CGFloat(80 + 64 * count)
        return CGSize(width: width, height: height)
    }
}

extension HomeRowTableViewCell: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: R.nib.homeRowTableViewCell.name) else {
            fatalError("This row is not exist")
        }
        return cell
    }
}
