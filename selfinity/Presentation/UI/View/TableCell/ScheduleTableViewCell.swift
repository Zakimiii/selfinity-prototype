//
//  ScheduleTableViewCell.swift
//  selfinity
//
//  Created by Apple on 2018/10/10.
//  Copyright © 2018年 Apple. All rights reserved.
//

import UIKit
import SwiftDate

@objcMembers
class ScheduleTableViewCell: UITableViewCell {
    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var otherView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel! {
        didSet{
            dateLabel.text = String(describing: Date.getJADateYMD())
        }
    }
    @IBOutlet weak var time1: TimeAxeView! {
        didSet {
            self.timeAxeViews[0] = time1
        }
    }
    @IBOutlet weak var time2: TimeAxeView! {
        didSet {
            self.timeAxeViews[1] = time2
        }
    }
    @IBOutlet weak var time3: TimeAxeView!{
        didSet {
            self.timeAxeViews[2] = time3
        }
    }
    @IBOutlet weak var time4: TimeAxeView!{
        didSet {
            self.timeAxeViews[3] = time4
        }
    }
    @IBOutlet weak var time5: TimeAxeView!{
        didSet {
            self.timeAxeViews[4] = time5
        }
    }
    @IBOutlet weak var time6: TimeAxeView!{
        didSet {
            self.timeAxeViews[5] = time6
        }
    }
    @IBOutlet weak var time7: TimeAxeView!{
        didSet {
            self.timeAxeViews[6] = time7
        }
    }
    @IBOutlet weak var time8: TimeAxeView!{
        didSet {
            self.timeAxeViews[7] = time8
        }
    }
    @IBOutlet weak var time9: TimeAxeView!{
        didSet {
            self.timeAxeViews[8] = time9
        }
    }
    @IBOutlet weak var time10: TimeAxeView!{
        didSet {
            self.timeAxeViews[9] = time10
        }
    }
    @IBOutlet weak var time11: TimeAxeView!{
        didSet {
            self.timeAxeViews[10] = time11
        }
    }
    @IBOutlet weak var time12: TimeAxeView!{
        didSet {
            self.timeAxeViews[11] = time12
        }
    }
    @IBOutlet weak var time13: TimeAxeView!{
        didSet {
            self.timeAxeViews[12] = time13
        }
    }
    @IBOutlet weak var time14: TimeAxeView!{
        didSet {
            self.timeAxeViews[13] = time14
        }
    }
    @IBOutlet weak var time15: TimeAxeView!{
        didSet {
            self.timeAxeViews[14] = time15
        }
    }
    @IBOutlet weak var time16: TimeAxeView!{
        didSet {
            self.timeAxeViews[15] = time16
        }
    }
    @IBOutlet weak var time17: TimeAxeView!{
        didSet {
            self.timeAxeViews[16] = time17
        }
    }
    @IBOutlet weak var time18: TimeAxeView!{
        didSet {
            self.timeAxeViews[17] = time18
        }
    }
    @IBOutlet weak var time19: TimeAxeView!{
        didSet {
            self.timeAxeViews[18] = time19
        }
    }
    @IBOutlet weak var time20: TimeAxeView!{
        didSet {
            self.timeAxeViews[19] = time20
        }
    }
    @IBOutlet weak var time21: TimeAxeView!{
        didSet {
            self.timeAxeViews[20] = time21
        }
    }
    @IBOutlet weak var time22: TimeAxeView!{
        didSet {
            self.timeAxeViews[21] = time22
        }
    }
    @IBOutlet weak var time23: TimeAxeView!{
        didSet {
            self.timeAxeViews[22] = time23
        }
    }
    @IBOutlet weak var time24: TimeAxeView!{
        didSet {
            self.timeAxeViews[23] = time24
        }
    }
    @IBOutlet weak var time25: TimeAxeView!{
        didSet {
            self.timeAxeViews[24] = time25
        }
    }
    @IBOutlet weak var timeBottom0: NSLayoutConstraint! {
        didSet {
            self.timeBottoms[0] = timeBottom0
        }
    }
    @IBOutlet weak var timeBottom1: NSLayoutConstraint!{
        didSet {
            self.timeBottoms[1] = timeBottom1
        }
    }
    @IBOutlet weak var timeBottom2: NSLayoutConstraint!{
        didSet {
            self.timeBottoms[2] = timeBottom2
        }
    }
    @IBOutlet weak var timeBottom3: NSLayoutConstraint!{
        didSet {
            self.timeBottoms[3] = timeBottom3
        }
    }
    @IBOutlet weak var timeBottom4: NSLayoutConstraint!{
        didSet {
            self.timeBottoms[4] = timeBottom4
        }
    }
    @IBOutlet weak var timeBottom5: NSLayoutConstraint!{
        didSet {
            self.timeBottoms[5] = timeBottom5
        }
    }
    @IBOutlet weak var timeBottom6: NSLayoutConstraint!{
        didSet {
            self.timeBottoms[6] = timeBottom6
        }
    }
    @IBOutlet weak var timeBottom7: NSLayoutConstraint!{
        didSet {
            self.timeBottoms[7] = timeBottom7
        }
    }
    @IBOutlet weak var timeBottom8: NSLayoutConstraint!{
        didSet {
            self.timeBottoms[8] = timeBottom8
        }
    }
    @IBOutlet weak var timeBottom9: NSLayoutConstraint!{
        didSet {
            self.timeBottoms[9] = timeBottom9
        }
    }
    @IBOutlet weak var timeBottom10: NSLayoutConstraint!{
        didSet {
            self.timeBottoms[10] = timeBottom10
        }
    }
    @IBOutlet weak var timeBottom11: NSLayoutConstraint!{
        didSet {
            self.timeBottoms[11] = timeBottom11
        }
    }
    @IBOutlet weak var timeBottom12: NSLayoutConstraint!{
        didSet {
            self.timeBottoms[12] = timeBottom12
        }
    }
    @IBOutlet weak var timeBottom13: NSLayoutConstraint!{
        didSet {
            self.timeBottoms[13] = timeBottom13
        }
    }
    @IBOutlet weak var timeBottom14: NSLayoutConstraint!{
        didSet {
            self.timeBottoms[14] = timeBottom14
        }
    }
    @IBOutlet weak var timeBottom15: NSLayoutConstraint!{
        didSet {
            self.timeBottoms[15] = timeBottom15
        }
    }
    @IBOutlet weak var timeBottom16: NSLayoutConstraint!{
        didSet {
            self.timeBottoms[16] = timeBottom16
        }
    }
    @IBOutlet weak var timeBottom17: NSLayoutConstraint!{
        didSet {
            self.timeBottoms[17] = timeBottom17
        }
    }
    @IBOutlet weak var timeBottom18: NSLayoutConstraint!{
        didSet {
            self.timeBottoms[18] = timeBottom18
        }
    }
    @IBOutlet weak var timeBottom19: NSLayoutConstraint!{
        didSet {
            self.timeBottoms[19] = timeBottom19
        }
    }
    @IBOutlet weak var timeBottom20: NSLayoutConstraint!{
        didSet {
            self.timeBottoms[20] = timeBottom20
        }
    }
    @IBOutlet weak var timeBottom21: NSLayoutConstraint!{
        didSet {
            self.timeBottoms[21] = timeBottom21
        }
    }
    @IBOutlet weak var timeBottom22: NSLayoutConstraint!{
        didSet {
            self.timeBottoms[22] = timeBottom22
        }
    }
    @IBOutlet weak var timeBottom23: NSLayoutConstraint!{
        didSet {
            self.timeBottoms[23] = timeBottom23
        }
    }
    @IBOutlet weak var timeBottom24: NSLayoutConstraint!{
        didSet {
            self.timeBottoms[24] = timeBottom24
        }
    }
    var timeAxeViews: [TimeAxeView] = [TimeAxeView(),TimeAxeView(),TimeAxeView(),TimeAxeView(),TimeAxeView(),TimeAxeView(),TimeAxeView(),TimeAxeView(),TimeAxeView(),TimeAxeView(),TimeAxeView(),TimeAxeView(),TimeAxeView(),TimeAxeView(),TimeAxeView(),TimeAxeView(),TimeAxeView(),TimeAxeView(),TimeAxeView(),TimeAxeView(),TimeAxeView(),TimeAxeView(),TimeAxeView(),TimeAxeView(),TimeAxeView()]
    
    var timeBottoms: [NSLayoutConstraint] = [NSLayoutConstraint(), NSLayoutConstraint(), NSLayoutConstraint(), NSLayoutConstraint(), NSLayoutConstraint(), NSLayoutConstraint(), NSLayoutConstraint(), NSLayoutConstraint(), NSLayoutConstraint(), NSLayoutConstraint(), NSLayoutConstraint(), NSLayoutConstraint(), NSLayoutConstraint(), NSLayoutConstraint(), NSLayoutConstraint(), NSLayoutConstraint(), NSLayoutConstraint(), NSLayoutConstraint(), NSLayoutConstraint(), NSLayoutConstraint(), NSLayoutConstraint(), NSLayoutConstraint(), NSLayoutConstraint(), NSLayoutConstraint(), NSLayoutConstraint()]
    
    @IBOutlet weak var currentTimeTop: NSLayoutConstraint! {
        didSet {
            currentTimeTop.constant = 93
        }
    }
    
    @IBOutlet weak var currentTime: CurrentAxeView!
    var delegate: ScheduleTableViewCellDelegate!
    
    override func awakeFromNib() {
        super.layoutSubviews()
        baseView.layer.cornerRadius = 15
        baseView.layer.masksToBounds = true
        baseView.layer.borderWidth = 1
        baseView.layer.borderColor = Constant.borderColor.cgColor
        otherView.layer.shadowColor = Constant.baseStringColor.cgColor
        otherView.layer.shadowOpacity = 0.5
        otherView.layer.shadowOffset = CGSize.zero
        otherView.layer.shadowRadius = 15
        
        for view in self.timeAxeViews.enumerated() {
            view.element.timeLabel.text = "\(view.offset):00"
        }
        
        configCurrentTime()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        if selected == true {
            baseView.waveCenter()
        }
    }
    
    func setData(repositories: [ReminderModel]) {
        self.subviews.forEach {
            guard let view = $0 as? ScheduleEventView else {
                return
            }
            view.removeFromSuperview()
        }
        for repository in repositories.enumerated() {
            let view = ScheduleEventView(frame: CGRect(x: timeAxeViews[repository.element.time.hour].borderView.frame.minX + 30, y: timeAxeViews[repository.element.time.hour].bottom, width: timeAxeViews[repository.element.time.hour].borderView.bounds.width, height: 40))
            view.titleLabel.text = repository.element.title
            view.uid = repository.element.uid
            view.delegate = self
            self.addSubview(view)
        }
    }
    
    func configCurrentTime() {
        let hour = Int(Date.getJADateH())!
        let minutes = Int(Date.getJADatem())!
        currentTimeTop.constant = timeAxeViews[hour].top + (CGFloat(minutes) * ((timeBottoms[hour].constant + timeAxeViews[hour].bounds.height) / CGFloat(60)))
        currentTime.timeLabel.text = "\(hour):\(Date.getJADatemm())"
    }
}

protocol ScheduleTableViewCellDelegate: class {
    func tapReminder(uid: String)
}

extension ScheduleTableViewCell: ScheduleEventViewDelegate {
    func tapView(uid: String) {
        self.delegate?.tapReminder(uid: uid)
    }
}
