//
//  HomeTableCollectionViewCell.swift
//  selfinity
//
//  Created by Apple on 2018/10/09.
//  Copyright © 2018年 Apple. All rights reserved.
//

import UIKit
import Firebase

protocol HomeTableCollectionViewCellDelegate: class {
    func tapNext(_ cell: HomeTableCollectionViewCell)
    func tapBack(_ cell: HomeTableCollectionViewCell)
}

@objcMembers
class HomeTableCollectionViewCell: UICollectionViewCell {
    var delegate: HomeTableCollectionViewCellDelegate!
    @IBOutlet weak var tableView: UITableView!
    enum Section: Int {
        case goal = 0
        case preStep = 1
        case step = 2
        //case task = 3
        case count = 3
        
        var string: String {
            switch self {
            case .goal: return R.string.localizable.homeSection()
            case .preStep: return R.string.localizable.stepSection()
            case .step: return R.string.localizable.stepSection()
            //case .task: return R.string.localizable.taskSection()
            case .count: fatalError("This row is not exist")
            }
        }
        
        var count: Int {
            switch self {
            case .goal: return GoalRow.count.rawValue
            case .preStep: return PreStepRow.count.rawValue
            case .step: return 10//StepRow.count.rawValue
            //case .task: return TaskRow.count.rawValue
            case .count: fatalError("This row is not exist")
            }
        }
        
        func getSectionCount(_ model: HomeIndexModel) -> Int {
            return GoalRow.count.rawValue + GoalRow.count.rawValue + model.steps.count
        }
        
        func getRowCount(_ model:HomeIndexModel, section: Int) -> Int {
            let count = 0
            let goalRange = count ..< count + GoalRow.count.rawValue
            let preStepRange = count + GoalRow.count.rawValue ..< count + GoalRow.count.rawValue + PreStepRow.count.rawValue
            let stepRange = count + GoalRow.count.rawValue + PreStepRow.count.rawValue ..< count + GoalRow.count.rawValue + PreStepRow.count.rawValue + model.steps.count
            
            switch section {
            case goalRange:
                return GoalRow.count.rawValue
            case preStepRange:
                return PreStepRow.content.rawValue
            case stepRange:
                return model.tasks[section - GoalRow.count.rawValue - PreStepRow.count.rawValue].count
            default: fatalError("This row is not exists")
            }
        }
        
        func getSectionString(_ model:HomeIndexModel, section: Int) -> String {
            let goalRange = 0 ..< GoalRow.count.rawValue
            let preStepRange = GoalRow.count.rawValue ..< GoalRow.count.rawValue + PreStepRow.count.rawValue
            let stepRange = GoalRow.count.rawValue + PreStepRow.count.rawValue ..< GoalRow.count.rawValue + PreStepRow.count.rawValue + model.steps.count
            
            switch section {
            case goalRange:
                return R.string.localizable.homeSection()
            case preStepRange:
                return R.string.localizable.stepSection()
            case stepRange:
                return R.string.localizable.stepSection()
            default: fatalError("This row is not exists")
            }
        }
    }
    
    enum GoalRow: Int {
        case goal = 0
        case count = 1
        
        var string: String {
            switch self {
            case .goal: return R.string.localizable.goalSection()
            case .count: fatalError("This row is not exist")
            }
        }
    }
    
    enum PreStepRow: Int {
        case content = 0
        case count = 1
    }
    
    enum StepRow: Int {
        case step
        case count
        
        func getCount(_ step: StepModel) -> Int {
            return step.tasks.count
        }
        
        func getSectionCount(_ model: HomeIndexModel) -> Int {
            return model.steps.count
        }
    }
    
    enum TaskRow: Int {
        case count = 0
    }
    
    var repository: HomeIndexModel! {
        didSet {
            self.confingTableView()
        }
    }
    
    func confingTableView() {
        tableView.register(R.nib.homeTableViewCell(), forCellReuseIdentifier: R.nib.homeTableViewCell.name)
        tableView.register(R.nib.homeRowTableViewCell(), forCellReuseIdentifier: R.nib.homeRowTableViewCell.name)
        tableView.register(R.nib.homeStepTableViewCell(), forCellReuseIdentifier: R.nib.homeStepTableViewCell.name)
        tableView.register(R.nib.homeTaskTableViewCell(), forCellReuseIdentifier: R.nib.homeTaskTableViewCell.name)
        tableView.register(R.nib.mainTableViewHeaderView(), forHeaderFooterViewReuseIdentifier: R.nib.mainTableViewHeaderView.name)
        tableView.register(R.nib.mainButtonTableViewHeaderView(), forHeaderFooterViewReuseIdentifier: R.nib.mainButtonTableViewHeaderView.name)
        tableView.register(R.nib.homeStepTableHeaderView(), forHeaderFooterViewReuseIdentifier: R.nib.homeStepTableHeaderView.name)
        tableView.estimatedRowHeight = 84
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.tableFooterView = UIView()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func setData(repository: HomeIndexModel) {
        self.repository = repository
    }
    
    func tapNext() {
        self.delegate?.tapNext(self)
    }
    
    func tapBack() {
        self.delegate?.tapBack(self)
    }
}

extension HomeTableCollectionViewCell: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return Section.count.getSectionCount(self.repository)//Section.count.rawValue
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Section.count.getRowCount(self.repository, section: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let goalRange = 0 ..< GoalRow.count.rawValue
        let preStepRange = GoalRow.count.rawValue ..< GoalRow.count.rawValue + PreStepRow.count.rawValue
        let stepRange = GoalRow.count.rawValue + PreStepRow.count.rawValue ..< GoalRow.count.rawValue + PreStepRow.count.rawValue + self.repository.steps.count
        switch indexPath.section {
        case goalRange:
            return self.tableView(tableView, cellForGoalRowAt: indexPath)
        case preStepRange:
            return UITableViewCell()
        case stepRange:
            return self.tableView(tableView, cellForStepRowAt: indexPath)
        //case .task: return self.tableView(tableView, cellForTaskRowAt: indexPath)
        default: fatalError("This row is not exists")
        }
    }
    
    private func tableView(_ tableView: UITableView, cellForGoalRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let row = GoalRow.init(rawValue: indexPath.row), let cell = tableView.dequeueReusableCell(withIdentifier: R.nib.homeTableViewCell.name) as? HomeTableViewCell else {
            fatalError("This row is not exist")
        }
        cell.titleLabel.text = row.string
        cell.valueLabel.text = self.repository.goal.text != "" ? self.repository.goal.text : self.repository.goal.smart.createJAText()
        return cell
    }
    
    private func tableView(_ tableView: UITableView, cellForStepRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: R.nib.homeTaskTableViewCell.name) as? HomeTaskTableViewCell else {
            fatalError("This row is not exist")
        }
        cell.titleLabel.text = self.repository.tasks[indexPath.section - (GoalRow.count.rawValue + PreStepRow.count.rawValue)][indexPath.row].text != "" ? self.repository.tasks[indexPath.section - (GoalRow.count.rawValue + PreStepRow.count.rawValue)][indexPath.row].text : self.repository.tasks[indexPath.section - (GoalRow.count.rawValue + PreStepRow.count.rawValue)][indexPath.row].smart.createJAText()
        return cell
    }
    
    private func tableView(_ tableView: UITableView, cellForTaskRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: R.nib.homeTaskTableViewCell.name) as? HomeTaskTableViewCell else {
            fatalError("This row is not exist")
        }
        cell.titleLabel.text = self.repository.tasks[indexPath.section][indexPath.row].text != "" ? self.repository.tasks[indexPath.section][indexPath.row].text : self.repository.tasks[indexPath.section][indexPath.row].smart.createJAText()
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let goalRange = 0 ..< GoalRow.count.rawValue
        let preStepRange = GoalRow.count.rawValue ..< GoalRow.count.rawValue + PreStepRow.count.rawValue
        let stepRange = GoalRow.count.rawValue + PreStepRow.count.rawValue ..< GoalRow.count.rawValue + PreStepRow.count.rawValue + self.repository.steps.count
        switch section {
        case goalRange:
            guard let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: R.nib.mainButtonTableViewHeaderView.name) as? MainButtonTableViewHeaderView else {
                return nil
            }
            view.titileLabel.text = Section.count.getSectionString(self.repository, section: section)
            view.hideCloseMode()
            view.backButton.button.addTarget(self, action: #selector(self.tapBack), for: .touchUpInside)
            view.nextButton.button.addTarget(self, action: #selector(self.tapNext), for: .touchUpInside)
            view.backButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.tapBack)))
            view.nextButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.tapNext)))
            return view
        case preStepRange:
            guard let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: R.nib.mainTableViewHeaderView.name) as? MainTableViewHeaderView else {
                return nil
            }
            view.titleLabel.textColor = Constant.mainColor
            view.setFontSize(22)
            view.titleLabel.text = Section.count.getSectionString(self.repository, section: section)
            return view
        case stepRange:
            guard let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: R.nib.homeStepTableHeaderView.name) as? HomeStepTableHeaderView else {
                return nil
            }
            view.titleLabel.text = self.repository.steps[section - (GoalRow.count.rawValue + PreStepRow.count.rawValue)].text != "" ? self.repository.steps[section - (GoalRow.count.rawValue + PreStepRow.count.rawValue)].text : self.repository.steps[section - (GoalRow.count.rawValue + PreStepRow.count.rawValue)].smart.createJAText()
            return view
//        case .task:
//            guard let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: R.nib.mainTableViewHeaderView.name) as? MainTableViewHeaderView else {
//                return nil
//            }
//            view.titleLabel.text = section.string
//            return view
        default: fatalError("This row is not exists")
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let goalRange = 0 ..< GoalRow.count.rawValue
        let preStepRange = GoalRow.count.rawValue ..< GoalRow.count.rawValue + PreStepRow.count.rawValue
        let stepRange = GoalRow.count.rawValue + PreStepRow.count.rawValue ..< GoalRow.count.rawValue + PreStepRow.count.rawValue + self.repository.steps.count
        switch section {
        case goalRange:
            return 84
        case preStepRange:
            return 64
        case stepRange:
            return 84
        default: fatalError("This row is not exists")
        }
    }
}

extension HomeTableCollectionViewCell: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (self.tableView.contentOffset.y <= 84 && self.tableView.contentOffset.y >= 0) {
            self.tableView.contentInset = UIEdgeInsets(top: -scrollView.contentOffset.y, left: 0, bottom: 0, right: 0)
        } else if (self.tableView.contentOffset.y >= 84) {
            self.tableView.contentInset = UIEdgeInsets(top: -84, left: 0, bottom: 00, right: 0)
        }
    }
}
