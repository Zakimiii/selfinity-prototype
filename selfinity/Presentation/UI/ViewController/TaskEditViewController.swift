//
//  TaskNewViewController.swift
//  selfinity
//
//  Created by Apple on 2018/10/19.
//  Copyright © 2018年 Apple. All rights reserved.
//

import UIKit

protocol TaskEditViewControllerDelegate: class {
    func pop(repositories: TaskModel)
}

@objcMembers
class TaskEditViewController: UIViewController {
    var delegate: TaskEditViewControllerDelegate!
    @IBOutlet weak var nextButton: GradationButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var headerView: ThinkHeaderView! {
        didSet {
            headerView.onlyCloseMode()
            headerView.titileLabel.setHelveticaNeueMediumFontSize(42)
            headerView.closeButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.tapClose)))
            headerView.closeButton.button.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.tapClose)))
            headerView.titileLabel.text = R.string.localizable.newEvent()
        }
    }
    var repositories: TaskModel!
    
    enum TaskRow: Int {
        case subject
        case verb
        case measurable
        case time
        case count
        
        var string: String {
            switch self {
            case .subject: return R.string.localizable.subject()
            case .verb: return R.string.localizable.verb()
            case .measurable: return R.string.localizable.measurable()
            case .time: return R.string.localizable.often()
            case .count: fatalError("This row is not exist")
            }
        }
        
        func getSmart(smart: SmartModel) -> String {
            switch self {
            case .subject:
                if smart.specificSubject == "" {
                    return self.string
                } else {
                    return smart.specificSubject
                }
            case .verb:
                if smart.specificVerb == "" {
                    return self.string
                } else {
                    return smart.specificVerb
                }
            case .measurable:
                if smart.measurable == "" {
                    return self.string
                } else {
                    return smart.measurable
                }
            case .time:
                if smart.timeBound == "" {
                    return self.string
                } else {
                    return smart.timeBound
                }
            case .count: fatalError("This row is not exist")
            }
        }
        
        func checkSmart(smart: SmartModel) -> Bool {
            switch self {
            case .subject:
                if smart.specificSubject == "" {
                    return false
                } else {
                    return true
                }
            case .verb:
                if smart.specificVerb == "" {
                    return false
                } else {
                    return true
                }
            case .measurable:
                if smart.measurable == "" {
                    return false
                } else {
                    return true
                }
            case .time:
                if smart.timeBound == "" {
                    return false
                } else {
                    return true
                }
            case .count: fatalError("This row is not exist")
            }
        }
    }
    
    override func viewDidLoad() {
        DispatchQueue.main.async {
            self.configTableView()
        }
    }
    
    func configTableView() {
        //guard self.repositories != nil else { return  }
        tableView.register(R.nib.textFieldTableViewCell(), forCellReuseIdentifier: R.nib.textFieldTableViewCell.name)
        tableView.register(R.nib.switchTableViewCell(), forCellReuseIdentifier: R.nib.switchTableViewCell.name)
        tableView.register(R.nib.reminderMemoTableViewCell(), forCellReuseIdentifier: R.nib.reminderMemoTableViewCell.name)
        tableView.register(R.nib.thinkTableViewCell(), forCellReuseIdentifier: R.nib.thinkTableViewCell.name)
        tableView.register(R.nib.mainDetailTableHeaderView(), forHeaderFooterViewReuseIdentifier: R.nib.mainDetailTableHeaderView.name)
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
}

extension TaskEditViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return TaskRow.count.rawValue
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let row = TaskRow.init(rawValue: indexPath.section) else { fatalError("This row is not exist")}
        guard let cell = tableView.dequeueReusableCell(withIdentifier: R.nib.thinkTableViewCell.name) as? ThinkTableViewCell else {
            fatalError("This row is not exist")
        }
        cell.titleLabel.text = row.string
        cell.placeholderMode()
        cell.titleLabel.text = row.getSmart(smart: self.repositories.smart)
        row.checkSmart(smart: self.repositories.smart) ? cell.defaultTextMode() : cell.placeholderMode()
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: R.nib.mainDetailTableHeaderView.name) as? MainDetailTableHeaderView else {
            fatalError("This section is not exist")
        }
        view.titleLabel.text = R.string.localizable.thinkStep()
        view.detailLabel.text = R.string.localizable.thinkStepDetail()
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 140
    }
}

extension TaskEditViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (self.tableView.contentOffset.y <= 140 && self.tableView.contentOffset.y >= 0) {
            self.tableView.contentInset = UIEdgeInsets(top: -scrollView.contentOffset.y, left: 0, bottom: 0, right: 0)
        } else if (self.tableView.contentOffset.y >= 140) {
            self.tableView.contentInset = UIEdgeInsets(top: -140, left: 0, bottom: 0, right: 0)
        }
    }
}
