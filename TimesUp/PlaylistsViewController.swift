//
//  PlaylistsViewController.swift
//  TimesUp
//
//  Created by Christopher Walter on 8/14/17.
//  Copyright © 2017 com.AssistStat. All rights reserved.
//

import UIKit
import CoreData

class PlaylistsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: Outlets
    @IBOutlet weak var playListTableView: UITableView!
    
    // MARK: Properties
    var playlists: [Playlist] = [Playlist]()
    var songs: [DeviceSong] = [DeviceSong]()
    
    
    let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavBar()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        loadPlaylistsAndReloadTable()
    }
    
    func setupNavBar() {
        
        let navBar = self.navigationController?.navigationBar
        navBar?.barStyle = .blackTranslucent
//        self.navigationController?.navigationBar.isTranslucent = true
//        self.navigationController?.navigationBar.barTintColor = UIColor.black
//        navigationController?.navigationBar.tintColor = UIColor.white
        
//        let addItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.add, target: nil, action: #selector(addNewPlaylist))
//        addItem.tintColor = UIColor.white
//        self.navigationItem.rightBarButtonItem = addItem
        
        
        
//        let screenSize: CGRect = UIScreen.main.bounds
//        let navBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: screenSize.width, height: 44))
//        let navItem = UINavigationItem(title: "")
//        let doneItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: nil, action: #selector(done))
//        navItem.rightBarButtonItem = doneItem
//        navBar.setItems([navItem], animated: false)
//        self.view.addSubview(navBar)
    }
    
    func addNewPlaylist() {
        performSegue(withIdentifier: "newPlaylistSegue", sender: self)
    }

    
    func loadPlaylistsAndReloadTable() {
        let entityDescription = NSEntityDescription.entity(forEntityName: "Playlist", in: managedObjectContext)
        let request = NSFetchRequest<NSFetchRequestResult>()
        request.entity = entityDescription
        let sortDescriptors = NSSortDescriptor(key: "created", ascending: false)
        request.sortDescriptors = [sortDescriptors]
        playlists = try! managedObjectContext.fetch(request) as! [Playlist]
        playListTableView.reloadData()
    }
    
    // MARK: Tableview Methods
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return playlists.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "playlistCell", for: indexPath) as! PlaylistTableViewCell
        cell.playlist = playlists[indexPath.row] // properties will be set in didSet method on tableviewCell
        
        return cell
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.delete) {
            // handle delete (by removing the data from your array and updating the tableview)
            let playlist = playlists[indexPath.row]
            managedObjectContext.delete(playlist)
            
            do {
                try managedObjectContext.save()
            } catch let error as NSError {
                print("Error While Deleting Note: \(error.userInfo)")
            }
            playlists.remove(at: indexPath.row)
            playListTableView.reloadData()
        }

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editPlaylistSegue" {
            let destVC = segue.destination as! SongsViewController
            if let indexPath = playListTableView.indexPathForSelectedRow {
                destVC.playlist = playlists[indexPath.row]
            }
        }

    }
    
    // sample loading from coredata
//    func loadScores() {
//        let entityDescription = NSEntityDescription.entity(forEntityName: "Score", in: managedObjectContext)
//        
//        let request = NSFetchRequest<NSFetchRequestResult>()
//        request.entity = entityDescription
//        
//        request.sortDescriptors = [NSSortDescriptor(key: "created", ascending: false)]
//        
//        let pred = NSPredicate(format: "(person = %@)", self.person!)
//        request.predicate = pred
//        
//        var scores = try! managedObjectContext.fetch(request) as! [Score]
//        
//        score = scores[0]
//    }
    


}
