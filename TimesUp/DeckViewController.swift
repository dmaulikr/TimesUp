//
//  DeckViewController.swift
//  TimesUp
//
//  Created by Christopher Walter on 8/20/17.
//  Copyright © 2017 com.AssistStat. All rights reserved.
//

import UIKit
import StoreKit

class DeckViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, DeckDetailsVCDelegate {
    
    // MARK: Outlets
    @IBOutlet weak var deckCollectionView: UICollectionView!
    
    // MARK: Properties
    var decks: [Deck] = [Deck]()
    var moviesItems: [String] = [String]()
    var sportsItems: [String] = [String]()
    var mixedBagItems: [String] = [String]()
    var selectedDeck: Deck? // used globally to pass selecteddeck to nextVC
    
    var products = [SKProduct]()
    
    var refreshControl: UIRefreshControl?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadDecks()
        
        let navBar = self.navigationController?.navigationBar
        navBar?.barStyle = .blackTranslucent
        navBar?.tintColor = UIColor.white
        
        refreshControl = UIRefreshControl()
        refreshControl = deckCollectionView.refreshControl
        refreshControl?.addTarget(self, action: #selector(reloadProducts), for: .valueChanged)
        
        let restoreButton = UIBarButtonItem(title: "Restore", style: .plain, target: self, action: #selector(DeckViewController.restoreTapped(_:)))
        navigationItem.rightBarButtonItem = restoreButton
        
        NotificationCenter.default.addObserver(self, selector: #selector(DeckViewController.handlePurchaseNotification(_:)), name: NSNotification.Name(rawValue: IAPHelper.IAPHelperPurchaseNotification), object: nil)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
//        reloadProducts()
    }
    
    func loadDecks() {
        
        moviesItems = ["Movies with animals", "Movies with Tom Hanks", "Disney Movies", "Movies with Will Smith", "Movies with Julia Roberts", "Movies with Matt Damon", "Spy movies", "Movies about sports", "Romantic Comedies", "Movies with car chases", "War movies", "Movies made after books", "Action Movies", "Comedy Movies", "Movies with a sequel", "Movies with Dogs", "Movie Villans", "Horror Movies", "Leonardo DiCaprio Movies", "Black and White Movies", "Movies about a Heist", "Movies with a Wedding", "Holiday Movies" ]
        
        mixedBagItems = ["Types of Vegetables", "Types of Fruit", "Countries in Europe", "Cartoon Characters", "Foods that are Orange", "Types of citrus", "Dog Breeds", "Countries in Europe", "States in the US", "Boy names that begin with the letter 'S'", "Girl names that begin with a vowel", "Super Heroes", "Animals you would find on an African Safari", "Boy names that begin with a vowel", "Girl names that begin with the letter 'B'", "Disney Characters", "Names that begin with 'C'", "Social Media websites/apps", "Items you can order at a Mexican Restaurant", "Items you can order at a Chinease Restaurant", "Animals you would find in the ocean", "Types of exercises you can do in the gym"]
        
        sportsItems = ["NBA Teams", "NFL Teams", "MLB Teams", "NHL Teams", "Types of Sports", "College and Mascot", "Sports Teams with cats as mascots", "Profesional Futbol/Soccer teams", "Games you would play in gym class", "Sports Teams with birds as Mascots", "NCAA Basketball March Madness Champions", "NBA Point Gaurds", "NFL Quarterbacks", "NFL Wide Recievers", "NBA Centers", "MLB Pitchers", "NHL Goalies", "MLB Homerun Hitters", "NHL Centers", "College and Mascot", "Profesional Tennis Players", "Profesional Basketball Players", "Profesional Soccer/Futbol players", "Profesional Baseball Players", "Profesional Football Players", "Profesional Hockey Players", "Olympic Events", "Gold Medal Olympians"]
        
        let aboutMovies = "A song will play for a random amount of time between 30 and 60 seconds.  A Movie topic will be displayed on the screen.  Take turns with your group listing items for that topic.  If the music stops on your turn, you lose.  If you are stumped and cannot think of an item for that topic, you can skip the topic for a 5 second penalty.\n\nExample: Topic is 'Movies with animals'\nPlayer 1 says \"Pets\", Player 2 says \"Jaws\", Player 3 says \"Babe\", Player 4 is thinking when the music stops.  Player 4 loses."
        let aboutSports = "A song will play for a random amount of time between 30 and 60 seconds.  A Sports topic will be displayed on the screen.  Take turns with your group listing items for that topic.  If the music stops on your turn, you lose.  If you are stumped and cannot think of an item for that topic, you can skip the topic for a 5 second penalty.\n\nExample: Topic is 'Sports Teams with cats as mascots'\nPlayer 1 says \"Jacksonville Jaguars\", Player 2 says \"Cinci Bengals\", Player 3 says \"Villanova Wildcats\", Player 4 is thinking when the music stops.  Player 4 loses."
        let aboutMixedBag = "A song will play for a random amount of time between 30 and 60 seconds.  A Random topic will be displayed on the screen.  Take turns with your group listing items for that topic.  If the music stops on your turn, you lose.  If you are stumped and cannot think of an item for that topic, you can skip the topic for a 5 second penalty.\n\nExample: Topic is 'Foods that are orange'\nPlayer 1 says \"Chedder Cheese\", Player 2 says \"Carrots\", Player 3 says \"Sweet Potatoes\", Player 4 says \"Orange Juice\", everyone has gone so its Player 1's turn again and Player 1 is thinking when the music stops.  Player 1 loses."
        let aboutJustMusic = "In this game a song will play for a random amount of time between 30 and 60 seconds.  During that time, your group can play 'Hot Potato' with some soft object in the room, 'Musical Chairs', or any other game that would need a timer and fun music."

        let justMusicDeck = Deck(title: "Just Music", items: [""], purchased: true, about: aboutJustMusic)
        decks.append(justMusicDeck)
        let moviesDeck = Deck(title: "Movies", items: moviesItems, purchased: true, about: aboutMovies)
        decks.append(moviesDeck)
        let sportsDeck = Deck(title: "Sports", items: sportsItems, purchased: true, about: aboutSports)
        decks.append(sportsDeck)
        let mixedBagDeck = Deck(title: "Mixed Bag", items: mixedBagItems, purchased: true, about: aboutMixedBag)
        decks.append(mixedBagDeck)

    }
    func reloadProducts() {
        products = []
        deckCollectionView.reloadData()
        
        TimesUpProducts.store.requestProducts{success, products in
            if success {
                if let foundProducts = products {
                    self.products = foundProducts
                    self.deckCollectionView.reloadData()
                }
            }
            self.refreshControl?.endRefreshing()
        }
    }
    func handlePurchaseNotification(_ notification: Notification) {
        guard let productID = notification.object as? String else { return }
        
        for (index, product) in products.enumerated() {
            guard product.productIdentifier == productID else { continue }
            
            deckCollectionView.reloadItems(at: [IndexPath(row: index, section: 0)])
//            deckCollectionView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .fade)
        }
    }
    func restoreTapped(_ sender: AnyObject) {
        TimesUpProducts.store.restorePurchases()
    }
    
    // MARK: UICollectionView methods
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let screenSize = UIScreen.main.bounds
        let width = (screenSize.width - 40.0) / 2.0
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 8.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout
        collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8.0
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return decks.count
        } else {
            return 0  // when you are ready for in app purchases remove this and load all products
//            return products.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "deckCell", for: indexPath) as! DeckCollectionViewCell
            
            let deck = decks[indexPath.row]
            cell.deckLabel.text = deck.title
            
            // round corners
            cell.deckView.layer.cornerRadius = 8.0
            cell.deckView.layer.borderWidth = 3.0
            cell.deckView.layer.borderColor = UIColor.white.cgColor
            
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "productCell", for: indexPath) as! ProductCollectionViewCell
            let product = products[indexPath.row]
            cell.product = product
            
            cell.buyButtonHandler = { product in
                print("user tapped buyButton")
                TimesUpProducts.store.buyProduct(product)
            }
//            cell.deckLabel.text = product.localizedTitle
            cell.productView.layer.cornerRadius = 8.0
            cell.productView.layer.borderWidth = 3.0
            cell.productView.layer.borderColor = UIColor.white.cgColor
            
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // set globalselectedMemory to the selected Memory then pass the segue to the next vc
        if indexPath.section == 0 {
            
            selectedDeck = decks[indexPath.row]
            self.performSegue(withIdentifier: "deckDetailsSegue", sender: self)
        } else {
            let product = products[indexPath.row]
            print("selected product:\(product.localizedDescription)")
        }
    }
    
    func showPlaylistVC() {
        if selectedDeck != nil {
            performSegue(withIdentifier: "deckSelectedSegue", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "deckDetailsSegue" {
            let destVC = segue.destination as! DeckDetailVC
            destVC.deck = selectedDeck
            destVC.delegate = self
        }
        if segue.identifier == "deckSelectedSegue" {
            let destVC = segue.destination as! PlaylistsViewController
            destVC.deck = selectedDeck
        }
    }


    
}
