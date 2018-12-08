//
//  ScheduleViewController.swift
//  selfinity
//
//  Created by Apple on 2018/10/07.
//  Copyright © 2018年 Apple. All rights reserved.
//

import UIKit
import SwiftDate
import FSCalendar
import CalculateCalendarLogic
import Firebase
import RxSwift

class ScheduleViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var actionView: ActionView!  {
        didSet {
            actionView.layer.shadowColor = Constant.baseStringColor.cgColor
            actionView.layer.shadowColor = Constant.baseStringColor.cgColor
            actionView.layer.shadowOpacity = 0.2
            actionView.layer.shadowOffset = CGSize.zero
            actionView.layer.shadowRadius = actionView.bounds.width / 2
            actionView.layer.shadowPath = UIBezierPath(roundedRect: actionView.bounds, cornerRadius: 10).cgPath
            actionView.layer.shouldRasterize = true
            actionView.layer.rasterizationScale = UIScreen.main.scale
            actionView.delegate = self
        }
    }
    @IBOutlet weak var calenderViewHeight: NSLayoutConstraint!
    @IBOutlet weak var calenderView: FSCalendar! {
        didSet {
            calenderView.delegate = self
            calenderView.dataSource = self
            calenderView.setScope(.week, animated: true)
            calenderView.locale = Locale(identifier: "ja_JP")
            calenderView.select(Date())
        }
    }
    fileprivate var currentDate = Date.CurrentDate()
    fileprivate let gregorian: Calendar = Calendar(identifier: .gregorian)
    fileprivate lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    fileprivate var scheduleCell: ScheduleTableViewCell!
    enum Section: Int {
        case schedule
        case task
        //case dairy
        case count
        
        var string: String {
            switch self {
            case .schedule: return R.string.localizable.scheduleSection()
            case .task: return R.string.localizable.taskSection()
            //case .dairy:  return NSLocalizedString("dairySection", tableName: Constant.scheduleString, comment: "")
            case .count: fatalError("This row is not exist")
            }
        }
    }
    
    fileprivate func judgeHoliday(_ date : Date) -> Bool {
        let tmpCalendar = Calendar(identifier: .gregorian)
        let year = tmpCalendar.component(.year, from: date)
        let month = tmpCalendar.component(.month, from: date)
        let day = tmpCalendar.component(.day, from: date)
        let holiday = CalculateCalendarLogic()
        
        return holiday.judgeJapaneseHoliday(year: year, month: month, day: day)
    }

    fileprivate func getDay(_ date:Date) -> (Int,Int,Int){
        let tmpCalendar = Calendar(identifier: .gregorian)
        let year = tmpCalendar.component(.year, from: date)
        let month = tmpCalendar.component(.month, from: date)
        let day = tmpCalendar.component(.day, from: date)
        return (year,month,day)
    }

    fileprivate func getWeekIdx(_ date: Date) -> Int{
        let tmpCalendar = Calendar(identifier: .gregorian)
        return tmpCalendar.component(.weekday, from: date)
    }
    
    fileprivate var presenter: SchedulePresenter?
    fileprivate let dataStore =  ReminderDataStoreImpl()
    fileprivate let error = ErrorTracker()
    fileprivate let disposeBag = DisposeBag()
    var repositories: RemindersModel! {
        didSet {
            configTableView()
        }
    }
    var cache: GoalModel!
    var toEditCache: ReminderModel!
    
    func inject(presenter: SchedulePresenter) {
        self.presenter = presenter
    }
    
    fileprivate func configTableView() {
        tableView.register(R.nib.scheduleTableViewCell(), forCellReuseIdentifier: R.nib.scheduleTableViewCell.name)
        tableView.estimatedRowHeight = 1000
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.tableFooterView = UIView()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewDidLoad() {
        ScheduleViewControllerBuilder.rebuild(self)
        self.presenter?.index()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if self.cache != nil {
            self.remindGeneratorFromCache()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.cache = nil
    }
    
    fileprivate func remindGeneratorFromCache() {
        self.presenter?.createFromGoal(repositories: self.cache)
        self.cache = nil
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? ReminderEditViewController, segue.identifier == R.segue.scheduleViewController.toCreate.identifier {
            vc.delegate = self
        } else if let vc = segue.destination as? ReminderEditViewController, segue.identifier == R.segue.scheduleViewController.toEdit.identifier {
            vc.delegate = self
            vc.repositories = self.toEditCache
        }
    }
}

extension ScheduleViewController: FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance {
    
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        calenderViewHeight.constant = bounds.height
        self.view.layoutIfNeeded()
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleDefaultColorFor date: Date) -> UIColor? {
        if self.judgeHoliday(date){
            return UIColor.red
        }
        let weekday = self.getWeekIdx(date)
        if weekday == 1 {
            return UIColor.red
        }
        else if weekday == 7 {
            return UIColor.blue
        }
        return nil
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        let date = date.convertLocalDate()
        self.tableView.reloadSections(IndexSet(integer: 0), with: currentDate > date ? .right : .left)
        if date == Date.CurrentPrunedDate() {
            self.scheduleCell.currentTime.isHidden = false
        } else {
            self.scheduleCell.currentTime.isHidden = true
        }
        self.currentDate = date
        self.scheduleCell.dateLabel.text = Date.getJAYMD(date)
        self.scheduleCell.setData(repositories: self.repositories.repositories.filter { $0.time.day == date.day && $0.time.month == date.month && $0.time.year == date.year })
    }
    
    func calendar(_ calendar: FSCalendar, hasEventFor date: Date) -> Bool {
        let date = date.convertLocalDate()
        guard let unwrappedRepositories = self.repositories else { return false }
        return !unwrappedRepositories.repositories.filter { $0.time.day == date.day && $0.time.month == date.month && $0.time.year == date.year }.isEmpty
    }
}

extension ScheduleViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: R.nib.scheduleTableViewCell.name) as? ScheduleTableViewCell else {
            fatalError("This row is not exist")
        }
        cell.titleLabel.text = R.string.localizable.mainTabText3()
        self.scheduleCell = cell
        cell.delegate = self
        scheduleCell.setData(repositories: self.repositories.repositories.filter { $0.time.day == Date.CurrentPrunedDate().day && $0.time.month ==  Date.CurrentPrunedDate().month && $0.time.year == Date.CurrentPrunedDate().year
        })
        return cell
    }
}

extension ScheduleViewController: ActionViewDelegate {
    func tapView() {
        self.presenter?.tapView()
    }
}

extension ScheduleViewController: SchedulePresenterInput {
    func index(didFetchRepository repository: RemindersModel) {
        self.repositories = repository
    }
    
    func showLoadingView() {
        
    }
    
    func hideLoadingView() {
        
    }
    
    func create(didCreateRepository repositories: RemindersModel) {
        for repository in repositories.repositories {
            self.repositories.repositories.append(repository)
        }
        self.tableView.reloadData()
    }
    
    func onErrorIndex() {
        
    }
}

extension ScheduleViewController: ReminderEditViewControllerDelegate {
    func pop(repositories: ReminderModel) {
        self.repositories.repositories.remove(value: repositories)
        self.repositories?.repositories.append(repositories)
        self.tableView.reloadData()
    }
}

extension ScheduleViewController: ScheduleTableViewCellDelegate {
    func tapReminder(uid: String) {
        self.toEditCache = self.repositories.repositories.filter { $0.uid == uid }.first
        self.presenter?.tapReminder()
    }
}
