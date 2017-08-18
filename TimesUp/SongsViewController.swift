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
    @IBOutlet weak var songsTableView: UITableView!
    @IBOutlet weak var playListTitleTextField: UITextField!
    @IBOutlet weak var editBarButton: UIBarButtonItem!

    @IBOutlet weak var musicQueueNavBar: UINavigationBar!
    // MARK: Properties
    var deviceSongs: [DeviceSong] = [DeviceSong]() // used for CoreData
    var songs: [Song] = [Song]() // used to populate tableview and pass to gameVC.  Consider switching everything to one array so the you dont have to manage and up keep two arrays.
    var mediaPicker: MPMediaPickerController?
    var myMusicPlayer: MPMusicPlayerController?
    var playlist: Playlist?
    
    let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setPlaylistSettings()
        loadSongsAndReloadTable()
        songsTableView.tableFooterView = UIView() // this tricks the tableview to remove extra cells at the bottom because it thinks it needs to add a footer.

        // round corners of nav bar.  last cell in the tableview gets rounded in cellForRowatIndexpath.
        let path = UIBezierPath(roundedRect: musicQueueNavBar.bounds, byRoundingCorners: [UIRectCorner.topLeft, UIRectCorner.topRight], cornerRadii: CGSize(width: 8.0, height: 8.0))
        let maskLayer = CAShapeLayer()
        maskLayer.frame = musicQueueNavBar.bounds
        maskLayer.path = path.cgPath
        musicQueueNavBar.layer.mask = maskLayer
        
        songsTableView.layer.cornerRadius = 8.0
    
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if self.isMovingFromParentViewController {
            savePlaylist()
        }
    }
    
    func setPlaylistSettings() {
        if playlist == nil {
            playListTitleTextField.becomeFirstResponder()
        } else {
            playListTitleTextField.text = playlist?.title
            if let shuffleSongs = playlist?.shouldShuffleSongs {
                shuffleSongsSwitch.isOn = shuffleSongs
            }
        }
    }
    func loadSongsAndReloadTable() {
        if let myPlaylist = playlist {
            let entityDescription = NSEntityDescription.entity(forEntityName: "DeviceSong", in: managedObjectContext)
            let request = NSFetchRequest<NSFetchRequestResult>()
            request.entity = entityDescription
            let pred = NSPredicate(format: "(playlist = %@)", myPlaylist)
            request.predicate = pred
            let sortDescriptors = NSSortDescriptor(key: "position", ascending: true)
            request.sortDescriptors = [sortDescriptors]
            deviceSongs = try! managedObjectContext.fetch(request) as! [DeviceSong]
            
            // convert deviceSongs to songs
            for song in deviceSongs {
                let newSong = Song(deviceSong: song)
                songs.append(newSong)
            }
            songsTableView.reloadData()
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
    
    @IBAction func addSongTapped(_ sender: UIBarButtonItem) {
        mediaPicker = MPMediaPickerController(mediaTypes: .music)
        if let picker = mediaPicker {
            picker.delegate = self
            picker.allowsPickingMultipleItems = true
            if let playlistTitle = playlist?.title {
                picker.prompt = "Select songs to add to \(playlistTitle)"
            } else {
                picker.prompt = "Select songs to add to current playlist"
            }
//            picker.popoverPresentationController?.sourceView = sender
            picker.popoverPresentationController?.barButtonItem = sender
            self.present(picker, animated: true, completion: nil)
        }
    }
    
    @IBAction func editButtonTapped(_ sender: UIBarButtonItem) {
        if songsTableView.isEditing {
            editBarButton.title = "Done"
            songsTableView.setEditing(false, animated: true)
        } else {
            editBarButton.title = "Edit"
            songsTableView.setEditing(true, animated: true)
        }
    }

    @IBAction func playButtonPressed(_ sender: UIBarButtonItem) {
        savePlaylist()
        if songs.count > 0 {
            performSegue(withIdentifier: "gameSegue", sender: self)
        } else {
            noSongsInPlaylistAlert()
        }
    }
    
    func noSongsInPlaylistAlert() {
        let alert = UIAlertController(title: "You must select at least one song in order to play the game", message: "What would you like to do?", preferredStyle: .alert)
        let useAllSongsAction = UIAlertAction(title: "Play with all songs in library?", style: .default, handler: {action in
        self.grabAllSongsAndPlay()
        })
        let goBackAction = UIAlertAction(title: "Go back and add songs", style: .default, handler: nil)
        alert.addAction(useAllSongsAction)
        alert.addAction(goBackAction)
        present(alert, animated: true, completion: nil)
    }
    func grabAllSongsAndPlay() {
        if let songQueryItems = MPMediaQuery.songs().items {
            let mediaItemCollection = MPMediaItemCollection(items: songQueryItems)
            for item in mediaItemCollection.items {
                let newSong = Song(item: item)
                songs.append(newSong)
            }
            
            if songs.count > 0 {
                savePlaylist()
                performSegue(withIdentifier: "gameSegue", sender: self)
            } else {
                noSongsInLibraryAlert()
            }
        }
    }
    
    func noSongsInLibraryAlert() {
        let alert = UIAlertController(title: "Error", message: "We could not find any songs in your music library.", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
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
            saveSongToCoreData(song: newSong)
            songsTableView.reloadData()
        }
        mediaPicker.dismiss(animated: true, completion: nil)
    }
    func saveSongToCoreData(song: Song) {
        // create a new deviceSong in CoreData
        let newSong = NSEntityDescription.insertNewObject(forEntityName: "DeviceSong", into: managedObjectContext) as! DeviceSong
        newSong.created = NSDate()
        newSong.artist = song.artist
        newSong.title = song.title
        newSong.persistentID = song.persistentID
        if let length = song.length {
            newSong.length = length
        }
        if let myPlaylist = self.playlist {
            newSong.playlist = myPlaylist
        } else {
            savePlaylist() // create a newPlaylist
            newSong.playlist = playlist
        }
//        if let i = songs.index(where: {$0.persistentID == song.persistentID}) {
//            newSong.position = Int16(i)
//        }
        newSong.position = Int16(songs.count)
        deviceSongs.append(newSong)
        var error: NSError? = nil
        do {
            try self.managedObjectContext.save()
        } catch let error1 as NSError {
            error = error1
            NSLog("Unresolved error \(String(describing: error?.localizedDescription))), \(error!.userInfo)")
            abort()
        }
    }
    
    // MARK: TableView Methods

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return songs.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "songCell", for: indexPath) as! SongTableViewCell
        var song = songs[indexPath.row]
        cell.song = song
        song.position = indexPath.row + 1
        cell.positionLabel.text = String(indexPath.row + 1)
        let deviceSong = deviceSongs[indexPath.row]
        deviceSong.position = Int16(indexPath.row + 1)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        if tableView.isEditing {
            return .delete
        } else {
            return .none
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // delete song from songs and from coredata
            let song = deviceSongs[indexPath.row]
            managedObjectContext.delete(song)
            do {
                try managedObjectContext.save()
            } catch let error as NSError {
                print("Error While Deleting Note: \(error.userInfo)")
            }
            deviceSongs.remove(at: indexPath.row)
            songs.remove(at: indexPath.row)
            songsTableView.reloadData()
        }
    }
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        
        let itemToMove = songs[sourceIndexPath.row]
        songs.remove(at: sourceIndexPath.row)
        songs.insert(itemToMove, at: destinationIndexPath.row)
        
        let itemToMove2 = deviceSongs[sourceIndexPath.row]
        deviceSongs.remove(at: sourceIndexPath.row)
        deviceSongs.insert(itemToMove2, at: destinationIndexPath.row)
        songsTableView.reloadData()
    }
    
    // MARK: TextField Delegate Methods
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        playListTitleTextField.resignFirstResponder()
        self.view.endEditing(true)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        savePlaylist()
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
