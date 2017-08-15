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

class SongsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate,MPMediaPickerControllerDelegate, UITextFieldDelegate {

    // MARK: Outlets
    @IBOutlet weak var shuffleSongsLabel: UILabel!
    @IBOutlet weak var shuffleSongsSwitch: UISwitch!
    @IBOutlet weak var playListTableView: UITableView!
    @IBOutlet weak var playListTitleTextField: UITextField!
    @IBOutlet weak var repeatSongsLabel: UILabel!
    @IBOutlet weak var repeatSongsSwitch: UISwitch!
    
    // MARK: Properties
    var deviceSongs: [DeviceSong] = [DeviceSong]()
    var songs: [Song] = [Song]()
    var mediaPicker: MPMediaPickerController?
    var myMusicPlayer: MPMusicPlayerController?
    var playlist: Playlist?
    
    let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        setPlaylistSettings()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if self.isMovingFromParentViewController {
            savePlaylist()
        }
    }
    
    func setPlaylistSettings () {
        if playlist == nil {
            playListTitleTextField.becomeFirstResponder()
        } else {
            playListTitleTextField.text = playlist?.title
            if let repeatSongs = playlist?.shouldRepeatSongs, let shuffleSongs = playlist?.shouldShuffleSongs {
                repeatSongsSwitch.isOn = repeatSongs
                shuffleSongsSwitch.isOn = shuffleSongs
            }
        }
    }
    
    func savePlaylist() {

        if playlist != nil {
            // update playlist
            if var title = playListTitleTextField.text {
                if title == "" {
                    title = "My Playlist"
                }
                playlist?.title = title
            } else {
                playlist?.title = "My Playlist"
            }
            playlist?.shouldRepeatSongs = repeatSongsSwitch.isOn
            playlist?.shouldShuffleSongs = shuffleSongsSwitch.isOn
            
        } else {
            // create a new playlist
            let newPlaylist = NSEntityDescription.insertNewObject(forEntityName: "Playlist", into: managedObjectContext) as! Playlist
            newPlaylist.created = NSDate()
            if var title = playListTitleTextField.text {
                if title == "" {
                    title = "My Playlist"
                }
                newPlaylist.title = title
            } else {
                newPlaylist.title = "My Playlist"
            }
            newPlaylist.shouldRepeatSongs = repeatSongsSwitch.isOn
            newPlaylist.shouldShuffleSongs = shuffleSongsSwitch.isOn
            self.playlist = newPlaylist
            
            var error: NSError? = nil
            do {
                try self.managedObjectContext.save()
            } catch let error1 as NSError {
                error = error1
                NSLog("Unresolved error \(String(describing: error?.localizedDescription))), \(error!.userInfo)")
                abort()
            }
        }
    }

    // MARK: Actions
    @IBAction func shuffleSongsSwitchTapped(_ sender: UISwitch) {
        savePlaylist()
    }
    
    @IBAction func addSongTapped(_ sender: Any) {
        displayMediaPicker()
    }
    
    @IBAction func repeatSongsSwitchTapped(_ sender: UISwitch) {
        savePlaylist()
    }

    @IBAction func playButtonPressed(_ sender: UIBarButtonItem) {
        savePlaylist()
        performSegue(withIdentifier: "gameSegue", sender: self)
    }
    
    // MARK: MediaPicker
    func mediaPickerDidCancel(_ mediaPicker: MPMediaPickerController) {
        mediaPicker.dismiss(animated: true, completion: nil)
    }
    
    func mediaPicker(_ mediaPicker: MPMediaPickerController, didPickMediaItems mediaItemCollection: MPMediaItemCollection) {
        print(mediaItemCollection.items)
        
        for item in mediaItemCollection.items {
            let newSong = Song(item: item)
            songs.append(newSong)
            
            playListTableView.reloadData()
        }
        mediaPicker.dismiss(animated: true, completion: nil)
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
            picker.allowsPickingMultipleItems = true
            picker.prompt = "Select songs to add to current playlist"
            view.addSubview(picker.view)
            present(picker, animated: true, completion: nil)
            
        } else {
            print("Could not instantiate a media picker")
        }
    }
    
    func nowPlayingItemIsChanged(notification: NSNotification){
        
        print("Playing Item Is Changed")
        
        let key = "MPMusicPlayerControllerNowPlayingItemPersistentIDKey"
        
        let persistentID = notification.userInfo![key] as? NSString
        
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
        
        cell.song = songs[indexPath.row]
        cell.positionLabel.text = String(indexPath.row + 1)
        return cell
    }

    // MARK: TextField Delegate Methods
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        playListTitleTextField.resignFirstResponder()
        self.view.endEditing(true)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "gameSegue" {
            let destVC = segue.destination as! GameViewController
            destVC.songs = self.songs
            destVC.playlist = self.playlist
                
            
        }
    }

}
