//
//  SongsViewController.swift
//  TimesUp
//
//  Created by Christopher Walter on 8/14/17.
//  Copyright © 2017 com.AssistStat. All rights reserved.
//

import UIKit
import CoreData
import MediaPlayer
import AVFoundation

class SongsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate,MPMediaPickerControllerDelegate {

    // MARK: Outlets
    @IBOutlet weak var shuffleSongsLabel: UILabel!
    @IBOutlet weak var shuffleSongsSwitch: UISwitch!
    @IBOutlet weak var playListTableView: UITableView!
    @IBOutlet weak var playListTitleTextField: UITextField!
    
    // MARK: Properties
    var songs: [Song] = [Song]()
    var mediaPicker: MPMediaPickerController?
    var myMusicPlayer: MPMusicPlayerController?
    
    
    let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    // MARK: Actions
    @IBAction func shuffleSongsSwitchTapped(_ sender: UISwitch) {
    }
    
    @IBAction func addSongTapped(_ sender: Any) {
        displayMediaPicker()
    }
    
    
    // MARK: MediaPicker
    func mediaPickerDidCancel(_ mediaPicker: MPMediaPickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func mediaPicker(_ mediaPicker: MPMediaPickerController, didPickMediaItems mediaItemCollection: MPMediaItemCollection) {
        print(mediaItemCollection)
    }
    
//    func mediaPicker(mediaPicker: MPMediaPickerController,
//                     didPickMediaItems mediaItemCollection: MPMediaItemCollection){
//        
//        
//        myMusicPlayer = MPMusicPlayerController()
//        
//        if let player = myMusicPlayer{
//            player.beginGeneratingPlaybackNotifications()
//            
//            player.setQueueWithItemCollection(mediaItemCollection)
//            player.play()
//            self.updateNowPlayingItem()
//            
//            mediaPicker.dismissViewControllerAnimated(true, completion: nil)
//        }
//    }
    
    
    
    func displayMediaPicker() {
        mediaPicker = MPMediaPickerController(mediaTypes: .anyAudio)
        
        if let picker = mediaPicker{
            
            print("Successfully instantiated a media picker")
            picker.delegate = self
            view.addSubview(picker.view)
            present(picker, animated: true, completion: nil)
            
        } else {
            print("Could not instantiate a media picker")
        }
    }
    
    func nowPlayingItemIsChanged(notification: NSNotification){
        
        print("Playing Item Is Changed")
        
        let key = "MPMusicPlayerControllerNowPlayingItemPersistentIDKey"
        
        let persistentID =
            notification.userInfo![key] as? NSString
        
        if let id = persistentID{
            print("Persistent ID = \(id)")
        }
        
    }
    
//    func volumeIsChanged(notification: NSNotification){
//        print("Volume Is Changed")
//    }
//    
//    func updateNowPlayingItem(){
//        if let nowPlayingItem=self.myMusicPlayer!.nowPlayingItem{
//            let nowPlayingTitle=nowPlayingItem.title
//            self.nowPlayingLabel.text=nowPlayingTitle
//        }else{
//            self.nowPlayingLabel.text="Nothing Played"
//        }
//    }
    
    
//    @IBAction func openItunesLibraryTapped(sender: AnyObject) {
//        displayMediaPickerAndPlayItem()
//    }
//    
//    @IBAction func sliderVolume(sender: AnyObject) {
//        if let view = masterVolumeSlider.subviews.first as? UISlider{
//            view.value = sender.value
//        }
//    }

    // MARK: TableView Methods

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return songs.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "songCell", for: indexPath) as! SongTableViewCell
        
        return cell
    }

}
