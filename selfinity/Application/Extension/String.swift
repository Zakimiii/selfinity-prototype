//
//  String.swift
//  selfinity
//
//  Created by Apple on 2018/10/14.
//  Copyright © 2018年 Apple. All rights reserved.
//

import UIKit
import Foundation


extension String {
    
    var hasSpaceAndNewlines: Bool {
        return self.isEmpty || self.trimmingCharacters(in: .whitespacesAndNewlines) != self
    }
    
}

extension String {
    
    /// 言語設定が「英語」かどうか ※1
    var isEnglish: Bool {
        return self.hasPrefix("en")
    }
    
    /// 言語設定が「日本語」かどうか
    var isJapanese: Bool {
        return self.hasPrefix("ja")
    }
    
    /// 地域設定が「日本語」かどうか ※2
    var isJapan: Bool {
        return self.hasSuffix("JP")
    }
    
}

extension String {
    
    /// 「ひらがな」に変換 ※１
    var toHiragana: String? {
        return self.applyingTransform(.hiraganaToKatakana, reverse: false)
    }
    
    /// 「カタカナ」に変換
    var toKatakana: String? {
        return self.applyingTransform(.hiraganaToKatakana, reverse: true)
    }
    
    /// 「ひらがな」を含むかどうか ※2
    var hasHiragana: Bool {
        guard let hiragana = self.toKatakana else { return false }
        return self != hiragana // １文字でもカタカナに変換されている場合は含まれると断定できる
    }
    
    /// 「カタカナ」を含むかどうか
    var hasKatakana: Bool {
        guard let katakana = self.toHiragana else { return false }
        return self != katakana // １文字でもひらがなに変換されている場合は含まれると断定できる
    }
    
}

extension String {
    
    /// 「漢字」かどうか
    var isKanji: Bool {
        let range = "^[\u{3005}\u{3007}\u{303b}\u{3400}-\u{9fff}\u{f900}-\u{faff}\u{20000}-\u{2ffff}]+$"
        return NSPredicate(format: "SELF MATCHES %@", range).evaluate(with: self)
    }
    
    /// 「ひらがな」かどうか
    var isHiragana: Bool {
        let range = "^[ぁ-ゞ]+$"
        return NSPredicate(format: "SELF MATCHES %@", range).evaluate(with: self)
    }
    
    /// 「カタカナ」かどうか
    var isKatakana: Bool {
        let range = "^[ァ-ヾ]+$"
        return NSPredicate(format: "SELF MATCHES %@", range).evaluate(with: self)
    }
    
}

extension String {
    
    /// 「小文字だけ」かどうか
    var isLowrcased: Bool {
        return self == self.lowercased()
    }
    
    /// 「大文字だけ」かどうか
    var isUppercased: Bool {
        return self == self.uppercased()
    }
    
}

extension String {
    
    var isUrl: Bool {
        let linkValidation = NSTextCheckingResult.CheckingType.link.rawValue
        guard let detector = try? NSDataDetector(types: linkValidation) else { return false }
        
        let results = detector.matches(in: self, options: .reportCompletion, range: NSMakeRange(0, self.characters.count))
        return results.first?.url != nil
    }
    
}


extension String {
    func toBool() -> Bool? {
        switch self {
        case "True", "true", "yes", "1":
            return true
        case "False", "false", "no", "0":
            return false
        default:
            return nil
        }
    }
    
    func getDate() -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone = TimeZone(identifier: "Asia/Tokyo")
        dateFormatter.locale = Locale(identifier: "ja_JP")
        return dateFormatter.date(from: self)
    }
    
    func getPrunedDate() -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss +0000"
        return dateFormatter.date(from: self)
    }
    
    func getUTCDate() -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        dateFormatter.locale = Locale(identifier: "ja_JP")
        return dateFormatter.date(from: self)
    }
    
    func getDateyyyyMMddHHmm() -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd HH:mm"
        dateFormatter.timeZone = TimeZone(identifier: "Asia/Tokyo")
        dateFormatter.locale = Locale(identifier: "ja_JP")
        return dateFormatter.date(from: self)
    }
    
    func getUTCDateyyyyMMddHHmm() -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd HH:mm"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        dateFormatter.locale = Locale(identifier: "ja_JP")
        return dateFormatter.date(from: self)
    }
}

public extension String {
    subscript (bounds: CountableClosedRange<Int>) -> String {
        let start = index(startIndex, offsetBy: bounds.lowerBound)
        let end = index(startIndex, offsetBy: bounds.upperBound)
        return String(self[start...end])
    }
    
    subscript (bounds: CountableRange<Int>) -> String {
        let start = index(startIndex, offsetBy: bounds.lowerBound)
        let end = index(startIndex, offsetBy: bounds.upperBound)
        return String(self[start..<end])
    }
    
    subscript (bounds: PartialRangeUpTo<Int>) -> String {
        let end = index(startIndex, offsetBy: bounds.upperBound)
        return String(self[startIndex..<end])
    }
    
    subscript (bounds: PartialRangeThrough<Int>) -> String {
        let end = index(startIndex, offsetBy: bounds.upperBound)
        return String(self[startIndex...end])
    }
    
    subscript (bounds: CountablePartialRangeFrom<Int>) -> String {
        let start = index(startIndex, offsetBy: bounds.lowerBound)
        return String(self[start..<endIndex])
    }
}

public extension String {
    public var halfWidth: String {
        return transformFullWidthToHalfWidth(reverse: false)
    }
    
    public var fullWidth: String {
        return transformFullWidthToHalfWidth(reverse: true)
    }
    
    private func transformFullWidthToHalfWidth(reverse: Bool) -> String {
        let string = NSMutableString(string: self) as CFMutableString
        CFStringTransform(string, nil, kCFStringTransformFullwidthHalfwidth, reverse)
        return string as String
    }
}

public extension String {
    public var url: URL? {
        return URL(string: self)
    }
}

extension URL: ExpressibleByStringLiteral {
    public init(stringLiteral value: String) {
        guard let url = URL(string: value) else {
            fatalError("\(value) is an invalid url")
        }
        self = url
    }
    
    public init(extendedGraphemeClusterLiteral value: String) {
        self.init(stringLiteral: value)
    }
    
    public init(unicodeScalarLiteral value: String) {
        self.init(stringLiteral: value)
    }
}
