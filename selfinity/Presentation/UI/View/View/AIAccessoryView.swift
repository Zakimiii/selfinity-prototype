//
//  AIAccessoryview.swift
//  selfinity
//
//  Created by Apple on 2018/10/17.
//  Copyright © 2018年 Apple. All rights reserved.
//

import UIKit

class AIAccessoryView: UIView {
    @IBOutlet weak var titleImage: UIImageView!
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.backgroundColor = UIColor.clear
            tableView.dataSource = self
            tableView.delegate = self
            tableView.estimatedRowHeight = 30
            tableView.rowHeight = UITableViewAutomaticDimension
            tableView.register(R.nib.textLabelTableViewCell(),  forCellReuseIdentifier: R.nib.textLabelTableViewCell.name)
            tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: tableView.frame.height / 2))
            tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: tableView.frame.height / 2))
            UIView.transition(with: tableView,
                              duration: 0.35,
                              options: .transitionCrossDissolve,
                              animations: { self.tableView.reloadData() })
            //tableView.scrollToRow(at: IndexPath(row: 2, section: 0) , at: .bottom, animated: true) // TODO::
        }
    }
    @IBOutlet weak var optionButton: OptionButton! {
        didSet {
            optionButton.layer.shadowColor = Constant.basePlaceHolderColor.cgColor
            optionButton.layer.shadowOpacity = 0.3
            optionButton.layer.shadowOffset = CGSize.zero
            optionButton.layer.shadowRadius = 5
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadNib()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadNib()
    }
    
    private func loadNib() {
        guard let view = Bundle(for: type(of: self)).loadNibNamed(R.nib.aiAccessoryView.name, owner: self, options: nil)?.first as? UIView else {
            return
        }
        self.addSubview(view)
        
        view.translatesAutoresizingMaskIntoConstraints = false
        view.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        view.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        view.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        view.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
        view.backgroundColor = UIColor.clear
    }
}

extension AIAccessoryView: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3//commentCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: R.nib.textLabelTableViewCell.name) as? TextLabelTableViewCell else {
            fatalError("This row is not exist")
        }
        cell.backgroundColor = UIColor.clear
        return cell
    }
}
