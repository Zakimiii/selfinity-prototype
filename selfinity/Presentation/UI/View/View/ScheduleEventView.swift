//
//  ScheduleEventView.swift
//  selfinity
//
//  Created by Apple on 2018/10/22.
//  Copyright © 2018年 Apple. All rights reserved.
//

import UIKit

protocol ScheduleEventViewDelegate: class {
    func tapView(uid: String)
}

@objcMembers
class ScheduleEventView: UIView {
    @IBOutlet weak var gradationView: GradationView! {
        didSet {
            gradationView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.tapView(_:))))
        }
    }
    @IBOutlet weak var titleLabel: UILabel!
    var uid: String!
    var delegate: ScheduleEventViewDelegate!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadNib()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadNib()
    }
    
    private func loadNib() {
        guard let view = Bundle(for: type(of: self)).loadNibNamed(R.nib.scheduleEventView.name, owner: self, options: nil)?.first as? UIView else {
            return
        }
        self.addSubview(view)
        
        view.translatesAutoresizingMaskIntoConstraints = false
        view.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        view.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        view.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        view.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
        view.layer.cornerRadius = 5
        view.layer.masksToBounds = true
    }
    
    func tapView(_ gesture:UITapGestureRecognizer) {
        gesture.cancelsTouchesInView = false
        gradationView.waveColorCenter(color: Constant.baseColor, point: gradationView.center)
        self.delegate?.tapView(uid: self.uid)
    }
}
