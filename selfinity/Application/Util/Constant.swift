//
//  Constant.swift
//  selfinity
//
//  Created by Apple on 2018/10/05.
//  Copyright © 2018年 Apple. All rights reserved.
//

import UIKit

struct Constant {
    
    enum MainIndex: Int {
        case home = 0
        case think = 1
        case memo = 2
        case schedule = 3
        case activity = 4
        
        var image: UIImage {
            switch self {
            case .home: return (UIImage(named: R.image.home.name)?.withRenderingMode(.alwaysTemplate).resizedImage(newSize: CGSize(width: 25, height: 25)))!
            case .think: return (UIImage(named: R.image.think.name)?.withRenderingMode(.alwaysTemplate).resizedImage(newSize: CGSize(width: 25, height: 25)))!
            case .memo: return (UIImage(named: R.image.memo.name)?.withRenderingMode(.alwaysTemplate).resizedImage(newSize: CGSize(width: 25, height: 25)))!
            case .schedule: return (UIImage(named: R.image.schedule.name)?.withRenderingMode(.alwaysTemplate).resizedImage(newSize: CGSize(width: 25, height: 25)))!
            case .activity: return (UIImage(named: R.image.star.name)?.withRenderingMode(.alwaysTemplate).resizedImage(newSize: CGSize(width: 25, height: 25)))!
            }
        }
        
        var tabbarItem: UITabBarItem {
            switch self {
            case .home: return UITabBarItem(title: R.string.localizable.mainTabText0(),
                                               image: self.image,
                                               tag: self.rawValue)
            case .think: return UITabBarItem(title: R.string.localizable.mainTabText1(),
                                              image: self.image,
                                              tag: self.rawValue)
            case .memo: return UITabBarItem(title: R.string.localizable.mainTabText2(),
                                                image: self.image,
                                                tag: self.rawValue)
            case .schedule: return UITabBarItem(title: R.string.localizable.mainTabText3(),
                                            image: self.image,
                                            tag: self.rawValue)
            case .activity: return UITabBarItem(title: R.string.localizable.mainTabText4(),
                                                image: self.image,
                                                tag: self.rawValue)
            }
        }
    }
    static let baseColor = UIColor.white
    static let transparentBaseColor = UIColor(red: 255, green: 255, blue: 255, alpha: 0.5)
    static let baseStringColor = UIColor.black
    static let basePlaceHolderColor = UIColor(red: 0.25, green: 0.25, blue: 0.25, alpha: 1.0)
    static let subPlaceHolderColor = UIColor(red: 0.56, green: 0.56, blue: 0.56, alpha: 1.0)
    static let mainColor = UIColor(red: 1.00, green: 0.64, blue: 0.0, alpha: 1.0)
    static let subColor = UIColor(red: 0.85, green: 0.64, blue: 0.12, alpha: 1.0)
    static let borderColor = UIColor(red: 0.94, green: 0.94, blue: 0.94, alpha: 1.0)
    
    static let chatWaveColor = UIColor(red: 0, green: 122, blue: 255, alpha: 1.0)
    
    static let fontLight = "HelveticaNeue-Light"
    static let fontThin = "HelveticaNeue-Thin"
    //static let fontRegular = "Memo"
    static let fontBold = "HelveticaNeue-Bold"
    static let fontMedium = "HelveticaNeue-Medium"
    
    static let filePrefix = "preFile"
    static let reminderPrefix = "preReminder"
    //Firebaseにスラッシュ/はだめっぽいw
    static let allFolderPrefix = "all"
    
    static func getNowClockString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd' 'HH:mm:ss"
        let now = Date.CurrentDate()
        return formatter.string(from: now)
    }
}
