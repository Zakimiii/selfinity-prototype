//
//  Array.swift
//  softbank_prototype
//
//  Created by Apple on 2018/09/06.
//  Copyright © 2018年 Apple. All rights reserved.
//

import Foundation

public extension Array where Element: Equatable {
    @discardableResult
    public mutating func remove(element: Element) -> Index? {
        guard let index = index(of: element) else { return nil }
        remove(at: index)
        return index
    }
    
    @discardableResult
    public mutating func remove(elements: [Element]) -> [Index] {
        return elements.compactMap { remove(element: $0) }
    }
}

public extension Array where Element: Hashable {
    public mutating func unify() {
        self = unified()
    }
}

public extension Collection where Element: Hashable {
    public func unified() -> [Element] {
        return reduce(into: []) {
            if !$0.contains($1) {
                $0.append($1)
            }
        }
    }
}

public extension Collection {
    public subscript(safe index: Index) -> Element? {
        return startIndex <= index && index < endIndex ? self[index] : nil
    }
}


extension Array where Element: Equatable {
    mutating func remove(value: Element) {
        if let i = self.index(of: value) {
            self.remove(at: i)
        }
    }
}

extension Array where Element: Equatable {
    var unique: [Element] {
        return reduce([Element]()) { $0.contains($1) ? $0 : $0 + [$1] }
    }
}

extension StepModel : Equatable {}

func == (lhs: StepModel, rhs: StepModel) -> Bool {
    return lhs.uid == rhs.uid
}

extension GoalModel : Equatable {}

func == (lhs: GoalModel, rhs: GoalModel) -> Bool {
    return lhs.uid == rhs.uid
}

extension TaskModel : Equatable {}

func == (lhs: TaskModel, rhs: TaskModel) -> Bool {
    return lhs.uid == rhs.uid
}

extension FileModel : Equatable {}

func == (lhs: FileModel, rhs: FileModel) -> Bool {
    return lhs.uid == rhs.uid
}

extension FolderModel : Equatable {}

func == (lhs: FolderModel, rhs: FolderModel) -> Bool {
    return lhs.uid == rhs.uid
}

extension ReminderModel : Equatable {}

func == (lhs: ReminderModel, rhs: ReminderModel) -> Bool {
    return lhs.uid == rhs.uid
}


