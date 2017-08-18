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
    var persistentID: String?
    var mediaItem: MPMediaItem?
    var position: Int?
    
    init(item: MPMediaItem) {
        title = item.title
        artist = item.artist
        length = item.playbackDuration
        created = Date()
        mediaItem = item
        persistentID = "\(item.persistentID)"
        position = 0
    }
    init(deviceSong: DeviceSong) {
        title = deviceSong.title
        artist = deviceSong.artist
        length = deviceSong.length
        created = deviceSong.created as Date?
        persistentID = deviceSong.persistentID
        position = Int(deviceSong.position)
        
    }
}
