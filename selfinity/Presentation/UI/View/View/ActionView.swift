//
//  ActionView.swift
//  selfinity
//
//  Created by Apple on 2018/10/11.
//  Copyright © 2018年 Apple. All rights reserved.
//

import UIKit

protocol ActionViewDelegate: class {
    func tapView()
}

extension ActionViewDelegate where Self: UIViewController {
    func tapView() { }
}

@objcMembers
class ActionView: UIView {
    @IBOutlet weak var gradationView: GradationView!
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var listenerView: UIView! {
        didSet {
            listenerView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.tapView)))
        }
    }
    var delegate: ActionViewDelegate!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadNib()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadNib()
    }
    
    private func loadNib() {
        guard let view = Bundle(for: type(of: self)).loadNibNamed(R.nib.actionView.name, owner: self, options: nil)?.first as? UIView else {
            return
        }
        self.addSubview(view)
        
        view.translatesAutoresizingMaskIntoConstraints = false
        view.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        view.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        view.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        view.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
        view.layer.cornerRadius = self.bounds.size.height / 2
        view.layer.masksToBounds = true
    }
    
    func tapView() {
        gradationView.waveCenter()
        self.delegate?.tapView()
    }
}
