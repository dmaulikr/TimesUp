//
//  Song.swift
//  TimesUp
//
//  Created by Christopher Walter on 8/14/17.
//  Copyright © 2017 com.AssistStat. All rights reserved.
//

import UIKit
import MediaPlayer

struct Song {
    var title: String?
    var artist: String?
    var length: Double?
    var created: Date?
    var mediaItem: MPMediaItem?
    
    init(item: MPMediaItem) {
        title = item.title
        artist = item.artist
        length = item.playbackDuration
        created = Date()
        mediaItem = item
    }
}
