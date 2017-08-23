//
//  Extensions.swift
//  TimesUp
//
//  Created by Christopher Walter on 8/15/17.
//  Copyright © 2017 com.AssistStat. All rights reserved.
//

import UIKit


enum DeckType {
    case justMusic
    case movies
    case sports
    case mixedBag
}

extension Array {
    mutating func shuffle() {
        for _ in 0..<((count>0) ? (count-1) : 0) {
            sort { (_,_) in arc4random() < arc4random() }
        }
    }
}

