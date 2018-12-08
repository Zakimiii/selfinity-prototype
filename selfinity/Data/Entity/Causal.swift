//
//  Causal.swift
//  selfinity
//
//  Created by Apple on 2018/10/25.
//  Copyright © 2018年 Apple. All rights reserved.
//

import UIKit

enum Causal:Int {
    case cause = 0 //reasonが原因となりresultに対して因果関係である
    case equal = 1 //reasonがresultと等しい
    case specific = 2 //reasonがresultへと具体化している = reasonはresultを含む
    case abstract = 3 //reasonがresultへと抽象化している = resultはreasonを含む
}
