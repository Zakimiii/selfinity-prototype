//
//  Date.swift
//  selfinity
//
//  Created by Apple on 2018/10/17.
//  Copyright © 2018年 Apple. All rights reserved.
//

import UIKit

extension Date {
    
    func UTCToLocal(date:String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        
        let dt = dateFormatter.date(from: date)
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        return dateFormatter.string(from: dt!)
    }
    
    static func CurrentDate() -> Date {
        let format = DateFormatter()
        
        format.dateFormat =  "yyyy-MM-dd HH:mm:ss"
        format.timeZone   = TimeZone.current
        format.locale = Locale.current
        return format.string(from: Date()).getUTCDate()!
    }
    
    static func CurrentPrunedDate() -> Date {
        let format = DateFormatter()
        
        format.dateFormat =  "yyyy-MM-dd 00:00:00"
        format.timeZone   = TimeZone.current
        format.locale = Locale.current
        return format.string(from: Date()).getUTCDate()!
    }
    
    func convertLocalDate() -> Date {
        let format = DateFormatter()
        format.dateFormat =  "yyyy-MM-dd HH:mm:ss"
        format.timeZone   = TimeZone.current
        format.locale = Locale.current
        return format.string(from: self).getUTCDate()!
    }
    
    func convertJADate() -> Date {
        let format = DateFormatter()
        format.dateFormat =  "yyyy-MM-dd HH:mm:ss"
        format.timeZone   = TimeZone(identifier: "Asia/Tokyo")
        format.locale = Locale(identifier: "ja_JP")
        return format.string(from: self).getDate()!
    }
    
    static func getJADate() -> Date {
        let format = DateFormatter()
        format.dateFormat =  "yyyy-MM-dd HH:mm:ss"
        format.timeZone   = TimeZone(identifier: "Asia/Tokyo")
        return format.string(from: Date()).getDate()!
    }
    
    static func getJADateYMD() -> String {
        let format = DateFormatter()
        format.dateFormat = "yyyy/MM/dd"
        format.timeZone   = TimeZone(identifier: "Asia/Tokyo")
        return format.string(from: Date())
    }
    
    static func getJADateH() -> String {
        let format = DateFormatter()
        format.dateFormat = "H"
        format.timeZone   = TimeZone(identifier: "Asia/Tokyo")
        return format.string(from: Date())
    }
    
    static func getJADatem() -> String {
        let format = DateFormatter()
        format.dateFormat = "m"
        format.timeZone   = TimeZone(identifier: "Asia/Tokyo")
        return format.string(from: Date())
    }
    
    static func getJADatemm() -> String {
        let format = DateFormatter()
        format.dateFormat = "mm"
        format.timeZone   = TimeZone(identifier: "Asia/Tokyo")
        return format.string(from: Date())
    }
    
    static func getJAYMD(_ date: Date) -> String {
        let format = DateFormatter()
        format.dateFormat = "yyyy/MM/dd"
        format.timeZone   = TimeZone(identifier: "Asia/Tokyo")
        return format.string(from: date)
    }
}
