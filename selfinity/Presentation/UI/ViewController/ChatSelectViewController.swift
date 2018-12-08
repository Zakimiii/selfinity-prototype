//
//  ChatSelectViewController.swift
//  selfinity
//
//  Created by Apple on 2018/10/18.
//  Copyright © 2018年 Apple. All rights reserved.
//

import UIKit

@objcMembers
class ChatSelectViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.register(R.nib.thinkTableViewCell(), forCellReuseIdentifier: R.nib.thinkTableViewCell.name)
            tableView.estimatedRowHeight = 84
            tableView.rowHeight = UITableViewAutomaticDimension
            tableView.tableFooterView = UIView()
            tableView.delegate = self
            tableView.dataSource = self
            tableView.backgroundColor = UIColor.clear
        }
    }
    @IBOutlet weak var titleLabel: UILabel! {
        didSet {
            titleLabel.text = R.string.localizable.selectChat()
        }
    }
    @IBOutlet weak var closeButton: SimpleButton! {
        didSet {
            closeButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.tapClose)))
            closeButton.button.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.tapClose)))
        }
    }
    
    func tapClose() {
        self.dismiss(animated: true, completion: nil)
    }
}

extension ChatSelectViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 12
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: R.nib.thinkTableViewCell.name) as? ThinkTableViewCell else {
            fatalError("This row is not exist")
        }
        cell.titleLabel.setHelveticaNeueMediumFontSize(24)
        cell.titleLabel.textColor = Constant.baseColor
        cell.backgroundColor = UIColor.clear
        cell.baseView.backgroundColor = Constant.mainColor
        cell.backButton.tintColor = Constant.baseColor
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
}
