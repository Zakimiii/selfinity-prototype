//
//  LocalSearchHistory.swift
//  selfinity
//
//  Created by Apple on 2018/10/15.
//  Copyright © 2018年 Apple. All rights reserved.
//

import Foundation

enum SearchHistoryType: String {
    case search = "searchHistory"
    case location = "locationHistory"
}

class LocalSearchHistory: NSObject, NSCoding {
    var name: String
    
    init(name: String) {
        self.name = name
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.name = aDecoder.decodeObject(forKey: "name") as? String ?? ""
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: "name")
    }
}

protocol LocalSearchHistoryProtocol: class {
    func appendToSearchHistory(_ searchHistory: String, type: SearchHistoryType)
    func loadSearchHistory(type: SearchHistoryType) -> [LocalSearchHistory]
}

extension LocalSearchHistoryProtocol {
    func appendToSearchHistory(_ searchHistory: String, type: SearchHistoryType) {
        guard !searchHistory.isEmpty else {
            return
        }
        var history = loadSearchHistory(type: type)
        
        // Remove duplicates
        history = Array(history.filter { $0.name != searchHistory }.prefix(4))
        
        history.insert(LocalSearchHistory(name: searchHistory), at: 0)
        
        let placesData = NSKeyedArchiver.archivedData(withRootObject: history)
        UserDefaults.standard.set(placesData, forKey: type.rawValue)
    }
    
    func loadSearchHistory(type: SearchHistoryType) -> [LocalSearchHistory] {
        guard let historyData = UserDefaults.standard.object(forKey: type.rawValue) as? NSData else {
            print("'searchHistory' not found in UserDefaults")
            return []
        }
        
        guard let historyArray = NSKeyedUnarchiver.unarchiveObject(with: historyData as Data) as? [LocalSearchHistory] else {
            print("Could not unarchive from placesData")
            return []
        }
        
        return historyArray
    }
}
