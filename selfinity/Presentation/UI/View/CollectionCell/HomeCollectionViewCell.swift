//
//  HomeCollectionViewCell.swift
//  selfinity
//
//  Created by Apple on 2018/10/08.
//  Copyright © 2018年 Apple. All rights reserved.
//

import UIKit

class HomeCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var titleLabel: UILabel! {
        didSet {
            titleLabel.textColor = Constant.mainColor
        }
    }
    @IBOutlet weak var rateLabel: UILabel! {
        didSet {
            rateLabel.textColor = Constant.baseStringColor
        }
    }
    @IBOutlet weak var textLabel: UILabel! {
        didSet {
            textLabel.textColor = Constant.baseStringColor
        }
    }
    @IBOutlet weak var baseView: UIView! {
        didSet {
            baseView.layer.cornerRadius = 15
            baseView.layer.shadowColor = Constant.baseStringColor.cgColor
            baseView.clipsToBounds = true
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    class func getSize() -> CGSize {
        let width = UIScreen.main.bounds.width - (20 * 2)
        let height = CGFloat(120)
        return CGSize(width: width, height: height)
    }

}
