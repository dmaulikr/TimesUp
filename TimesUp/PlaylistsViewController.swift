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

        
    }
    
    func loadPlaylists() {
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return playlists.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "playlistCell", for: indexPath) as! PlaylistTableViewCell
        
        return cell
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
    
    // example of saving to coredata
//    func createNewScore() {
//        // calculate new academic score based on gpa and activities
//        var academicScore = 0.0
//        var communityScore = 0.0
//        var healthScore = 0.0
//        var socialScore = 0.0
//        
//        if (person?.weightedGPA)! > 5.0 {
//            academicScore += 100.0
//        }
//        else {
//            academicScore += 20.0 * (person?.weightedGPA)!
//        }
//        if (person?.gpa)! > 4.0 {
//            academicScore += 100.0
//        }
//        else {
//            academicScore += 25.0 * (person?.gpa)!
//        }
//        
//        // give attendance Bump.  Kids start with 100 point and work down from there
//        academicScore += 100
//        academicScore -= 5 * (person?.lates)!
//        academicScore -= 10 * (person?.absences)!
//        
//        loadActivities()
//        // use activities to change score
//        for activity in activities {
//            if activity.category == "Academic" {
//                academicScore += activity.weight * activity.value
//            }
//            if activity.category == "Social" {
//                socialScore += activity.weight * activity.value
//            }
//            if activity.category == "Community" {
//                communityScore += activity.weight * activity.value
//            }
//            if activity.category == "Health" {
//                healthScore += activity.weight * activity.value
//            }
//        }
//        loadEvents()
//        // use events to update score
//        for event in events {
//            if event.category == "Academic" {
//                academicScore += event.weight * event.value
//            }
//            if event.category == "Social" {
//                socialScore += event.weight * event.value
//            }
//            if event.category == "Community" {
//                communityScore += event.weight * event.value
//            }
//            if event.category == "Health" {
//                healthScore += event.weight * event.value
//            }
//        }
//        
//        // add DailyScores to newScore
//        loadDailyScores()
//        
//        // to make sure we get at least 5 daily scores, to make the kids use the app more than once
//        if dailyScores.count < 5 {
//            
//            // give dailyScore category Bump for not doing the negative things.
//            academicScore += 4.0 * Double(dailyScores.count) //negative phone in class
//            healthScore += 3.0 * Double(dailyScores.count) // negative fast food
//            socialScore += 18.0 * Double(dailyScores.count) // negative tv/videogame/phone
//            communityScore += 10.0 * Double(dailyScores.count) //detention, suspension, litter, talk negative
//            
//            for score in dailyScores {
//                academicScore += score.academicScore
//                healthScore += score.healthScore
//                socialScore += score.socialScore
//                communityScore += score.communityScore
//            }
//        }
//        else {
//            
//            // give dailyScore category Bump for not doing the negative things.
//            academicScore += 20.0 //negative phone in class
//            healthScore += 15.0 // negative fast food
//            socialScore += 90.0 // negative tv/videogame/phone
//            communityScore += 50.0 //detention, suspension, litter, talk negative
//            
//            // sum the scores, divide by however many there are (.count) and multiply by 10
//            var dsAcademic = 0.0
//            var dsHealth = 0.0
//            var dsCommunity = 0.0
//            var dsSocial = 0.0
//            for score in dailyScores {
//                dsAcademic += score.academicScore
//                dsHealth += score.healthScore
//                dsSocial += score.socialScore
//                dsCommunity += score.communityScore
//            }
//            
//            academicScore += dsAcademic / Double(dailyScores.count) * 5.0
//            healthScore += dsHealth / Double(dailyScores.count) * 5.0
//            socialScore += dsSocial / Double(dailyScores.count) * 5.0
//            communityScore += dsCommunity / Double(dailyScores.count) * 5.0
//        }
//        
//        let newScore = NSEntityDescription.insertNewObject(forEntityName: "Score", into: managedObjectContext) as! Score
//        
//        newScore.created = NSDate()
//        newScore.person = person
//        newScore.communityScore = communityScore
//        newScore.healthScore = healthScore
//        newScore.socialScore = socialScore
//        newScore.academicScore = academicScore
//        newScore.totalScore = academicScore + communityScore + healthScore + socialScore
//        
//        var error : NSError? = nil
//        do {
//            try self.managedObjectContext.save()
//        } catch let error1 as NSError {
//            error = error1
//            NSLog("Unresolved error \(error), \(error!.userInfo)")
//            abort()
//        }
//    }


}
