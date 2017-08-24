//
//  Deck.swift
//  TimesUp
//
//  Created by Christopher Walter on 8/21/17.
//  Copyright © 2017 com.AssistStat. All rights reserved.
//

import UIKit

struct Deck {
    var title: String = ""
    var items: [String] = [String]()
    var isPurchased: Bool = false
    var about: String = ""
    
    init(title: String, items: [String], purchased: Bool, about: String) {
        self.title = title
        self.items = items
        self.isPurchased = purchased
        self.about = about
    }
}
