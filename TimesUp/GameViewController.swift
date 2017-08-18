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
    @IBOutlet weak var nowPlayingView: UIView!
    
    // MARK: properties
    var playlist: Playlist?
    var songs: [Song] = [Song]()
    var song: Song?
    var musicPlayer: MPMusicPlayerController?
    
    // make this global so that I can make it appear and disappear.
    lazy var containerView: UIView = {
        let cView = UIView()
        cView.backgroundColor = UIColor.white
        cView.translatesAutoresizingMaskIntoConstraints = false
        return cView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        eraseLabelsAndHideView()
        setUpMusicPlayer()
        startGame()
        setupGameViews()
        containerView.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if let player = musicPlayer {
            player.stop()
        }
        if let myTimer = timer {
            myTimer.invalidate()
        }
        if let myCountdownTimer = countdownTimer {
            myCountdownTimer.invalidate()
        }
    }
    
    override func viewDidLayoutSubviews() {
        nowPlayingView.layer.shadowPath = UIBezierPath(rect: nowPlayingView.bounds).cgPath
        nowPlayingView.layer.shouldRasterize = true

    }
    func setUpMusicPlayer() {
        musicPlayer = MPMusicPlayerController()
        var mediaItems: [MPMediaItem] = [MPMediaItem]()
        // go through each song and grab them one at a time in a query from the library.  MPMedia queries do not allow OR queries so I was not able to all the songs with only one query
        for song in songs {
            if let item = song.mediaItem {
                mediaItems.append(item)
            } else {
                let songQuery = MPMediaQuery.songs()
                let predicate = MPMediaPropertyPredicate(value: song.persistentID, forProperty: MPMediaItemPropertyPersistentID)
                songQuery.addFilterPredicate(predicate)
                if let foundItems = songQuery.items {
                    if foundItems.count == 1 { // we should not be able to find more than one song for each query.
                        mediaItems.append(contentsOf: foundItems)
                    }
                }
            }
        }
        let mediaItemCollection = MPMediaItemCollection(items: mediaItems)
        if let player = musicPlayer {
            player.setQueue(with: mediaItemCollection)
        }
    }
    
    func playMusic() {
        if let player = musicPlayer {
            player.prepareToPlay()
            player.play()
            if let currentItem = player.nowPlayingItem {
                let song = Song(item: currentItem)
                setLabelsForCurrentSong(song: song)
            }
            getRandomNumberAndStartTimer()

        }
    }
    func eraseLabelsAndHideView() {
        mainLabel.text = ""
        nowPlayingLabel.text = ""
        timeLabel.text = ""
        artistLabel.text = ""
        songTitleLabel.text = ""
        nowPlayingView.isHidden = true
    }
    
    // countdown timer is used like a ready, set, go!.  it currently counts down from 5.
    var countdownTimer: Timer?
    var countdown = 5
    
    func startGame() {
        countdownTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(startCountdown), userInfo: nil, repeats: true)
    }
    
    func startCountdown() {

        if countdown > 3 {
            mainLabel.text = "Get Ready"
            countdown -= 1
        } else if countdown > 0 {
            mainLabel.text = "\(countdown)"
            countdown -= 1
            playBeep()
        }
        else {
            mainLabel.text = "List NBA teams"
            countdownTimer?.invalidate()
            countdown = 5
            playMusic()
        }
    }
    

    func displayResartGameButton() {
        containerView.isHidden = false
    }
    
    func restartGame() {
        containerView.isHidden = true
        eraseLabelsAndHideView()
        startGame()
    }
    
    func playBeep() {
        // create a sound ID, in this case its the beep sound.
        // 1106 = beep
        
        let systemSoundID: SystemSoundID = 1106
        // to play sound
        AudioServicesPlaySystemSound(systemSoundID)
    }
    
    func playEndGame() {
        // create a sound ID, in this case its the cho-cho sound.
        // 1023 cho-cho
        let systemSoundID: SystemSoundID = 1023
        // to play sound
        AudioServicesPlaySystemSound(systemSoundID)
    }
    
    
    // timer is used during the game and will count up from 0 until the song has played for a certain amount of time.  In the actual game it shoul be between 30 and 60 seconds.
    var timer: Timer?
    var count = 1
    var randomEndTime = 5
    
    func getRandomNumberAndStartTimer() {
        // get a random number between 0 and 10
        randomEndTime = Int(arc4random_uniform(10))
        print(randomEndTime)
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimeLabel), userInfo: nil, repeats: true)
    }
    
    func updateTimeLabel() {
        timeLabel.text = "\(count)"
        count += 1
        if count == randomEndTime {
            playEndGame() // play end game sound 1 second before end of game because sound is 1 second long
        }
        if count > randomEndTime {

            timer?.invalidate()
            count = 1
            if let player = musicPlayer {
                player.pause()
                player.skipToNextItem()
                displayResartGameButton()
            }
            nowPlayingLabel.text = "Game Over"
        }
    }

    func setLabelsForCurrentSong(song: Song) {
        nowPlayingView.isHidden = false
        songTitleLabel.text = song.title
        artistLabel.text = song.artist
        timeLabel.text = "0"
        nowPlayingLabel.text = "Now Playing:"
    }
    

    // delete this button after testing
    @IBAction func nextSongButtonPressed(_ sender: UIButton) {
        if let player = musicPlayer {
            player.skipToNextItem()
            if let currentItem = player.nowPlayingItem {
                let song = Song(item: currentItem)
                setLabelsForCurrentSong(song: song)
            }
        }
    }
    
    func setupGameViews() {
        containerView = UIView()
        containerView.frame = CGRect(x: view.center.x, y: 90, width: 200, height: 100)
        containerView.backgroundColor = UIColor.white
//        containerView.layer.borderWidth = 5.0
//        containerView.layer.borderColor = UIColor.darkGray.cgColor
        containerView.layer.cornerRadius = 10.0
        containerView.layer.shadowColor = UIColor.darkGray.cgColor
        containerView.layer.shadowOpacity = 1
        containerView.layer.shadowOffset = CGSize.zero
        containerView.layer.shadowRadius = 10
        containerView.layer.shadowPath = UIBezierPath(rect: containerView.bounds).cgPath
        containerView.layer.shouldRasterize = true

        
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(containerView)
        view.bringSubview(toFront: containerView)
        
        // Set up constraints: x,y,w,h
        containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        containerView.topAnchor.constraint(equalTo: view.topAnchor, constant: 90).isActive = true
        containerView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        containerView.widthAnchor.constraint(equalToConstant: 200).isActive = true
        
        let button = UIButton()
        button.setTitle("Game Over\nPlay Again?", for: .normal)
        button.titleLabel?.font = UIFont(name: "Avenir", size: 24)
        button.titleLabel?.numberOfLines = 0
        button.titleLabel?.lineBreakMode = .byWordWrapping
        button.addTarget(self, action: #selector(restartGame), for: .touchUpInside)
        button.setTitleColor(UIColor.darkGray, for: .normal)
        button.isHidden = false
        button.translatesAutoresizingMaskIntoConstraints = false
        
        // add button to container
        containerView.addSubview(button)
        // Set up constraints for button: pin to top, left, right, and bottom of containerview
        button.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        button.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
        button.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
        button.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
        
        nowPlayingView.layer.cornerRadius = 10.0
        //        nowPlayingView.layer.borderColor = UIColor.darkGray.cgColor
        //        nowPlayingView.layer.borderWidth = 5.0
        nowPlayingView.layer.shadowColor = UIColor.darkGray.cgColor
        nowPlayingView.layer.shadowOpacity = 1
        nowPlayingView.layer.shadowOffset = CGSize.zero
        nowPlayingView.layer.shadowRadius = 10
        nowPlayingView.layer.shadowPath = UIBezierPath(rect: nowPlayingView.bounds).cgPath
        nowPlayingView.layer.shouldRasterize = true

        

        mainLabel.layer.cornerRadius = 10.0
//        mainLabel.layer.borderColor = UIColor.white.cgColor
//        mainLabel.layer.borderWidth = 15.0
        
    }

    
}
