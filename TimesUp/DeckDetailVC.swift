//
//  DeckDetailVC.swift
//  TimesUp
//
//  Created by Christopher Walter on 8/22/17.
//  Copyright © 2017 com.AssistStat. All rights reserved.
//

import UIKit

protocol DeckDetailsVCDelegate {
    func showPlaylistVC()
}
class DeckDetailVC: UIViewController {
    
    //MARK: Outlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var bodyTextView: UITextView!
    @IBOutlet weak var detailView: UIView!
    @IBOutlet weak var playButton: UIBarButtonItem!
    
    // MARK: Properties
    var delegate: DeckDetailsVCDelegate?
    
    var deck: Deck?
    
    lazy var buyButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.textAlignment = .center
        button.setTitle("Buy", for: UIControlState())
        button.addTarget(self, action: #selector(buyButtonTapped), for: .touchUpInside)
        button.layer.frame = CGRect(x: 0, y: 0, width: 120, height: 50)
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bodyTextView.isEditable = false
        bodyTextView.isSelectable = false
        
    }
    override func viewWillAppear(_ animated: Bool) {
        setupDetails()
    }
    
    func setupDetails() {
        if let myDeck = deck {
            titleLabel.text = myDeck.title
            bodyTextView.text = myDeck.about
            
            detailView.backgroundColor = UIColor.darkGray
            detailView.addSubview(buyButton)
            detailView.layer.cornerRadius = 8.0
            
            if myDeck.isPurchased == true {
                // display play Button
                playButton.isEnabled = true
                buyButton.isEnabled = true
                buyButton.setTitle("Play", for: UIControlState())
//                buyButton.setTitle("Free with App", for: UIControlState())
                
                // buy button title should be disabled and read Owner
                
            } else {
                playButton.isEnabled = false
                buyButton.isEnabled = true
                // display buy button
            }
        }
    }
    @IBAction func playButtonTapped(_ sender: UIBarButtonItem) {
        if deck != nil {
//            performSegue(withIdentifier: "selectPlaylistSegue", sender: self)
            self.dismiss(animated: true, completion: {action in
                let presentingVC = self.presentingViewController as! DeckViewController
                presentingVC.showPlaylistVC()
            })
        }
    }
    
    func buyButtonTapped() {
        if buyButton.title(for: UIControlState()) == "Play" {
            self.dismiss(animated: true, completion: nil)
            delegate?.showPlaylistVC()
        } else {
            //handle purchasing a deck
        }
    }
    
        
    func newBuyButton() -> UIButton {
        let button = UIButton(type: .system)
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.textAlignment = .center
        button.setTitle("Buy", for: UIControlState())
        button.addTarget(self, action: #selector(ProductCollectionViewCell.buyButtonTapped(_:)), for: .touchUpInside)
        button.layer.frame = CGRect(x: 0, y: 0, width: 120, height: 50)
        
        return button
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "selectPlaylistSegue" {
            let destVC = segue.destination as! PlaylistsViewController
            destVC.deck = deck
        }
    }


}
