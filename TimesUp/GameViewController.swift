//
//  GameViewController.swift
//  TimesUp
//
//  Created by Christopher Walter on 8/15/17.
//  Copyright © 2017 com.AssistStat. All rights reserved.
//

import UIKit
import CoreData
import MediaPlayer
import AVFoundation

class GameViewController: UIViewController {

    // MARK: outlets
    @IBOutlet weak var mainLabel: UILabel!
    @IBOutlet weak var nowPlayingLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var artistLabel: UILabel!
    @IBOutlet weak var songTitleLabel: UILabel!
    
    // MARK: properties
    var playlist: Playlist?
    var songs: [Song] = [Song]()
    var song: Song?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        playSongs()

    }


    func playSongs() {
        if songs.count > 0 {
            let song = songs[0]
            songTitleLabel.text = song.title
            artistLabel.text = song.artist
            if let lengthAsDouble = song.length {
                let min: Int = Int(lengthAsDouble) / 60
                let seconds: Int = Int(lengthAsDouble) % 60
                var secondsAsString = ""
                if seconds < 10 {
                    secondsAsString = "0\(seconds)"
                } else {
                    secondsAsString = "\(seconds)"
                }
                let time = "\(min):\(secondsAsString)"
                timeLabel.text = time
            } else {
                timeLabel.text = "Error"
            }

            
        }
        
    }
    

    
}
