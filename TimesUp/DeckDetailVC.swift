//
//  DeckDetailVC.swift
//  TimesUp
//
//  Created by Christopher Walter on 8/22/17.
//  Copyright © 2017 com.AssistStat. All rights reserved.
//

import UIKit

protocol DeckDetailsVCDelegate {
    func playGame()
}
class DeckDetailVC: UIViewController {
    
    //MARK: Outlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var bodyTextView: UITextView!
    @IBOutlet weak var detailView: UIView!
    @IBOutlet weak var backView: UIView!
    
    
    // MARK: Properties
    var delegate: DeckDetailsVCDelegate?
    
    var deck: Deck?
    
    lazy var buyButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.textAlignment = .center
        button.setTitle("Buy", for: UIControlState())
        button.titleLabel?.font = UIFont(name: "Avenir-Medium", size: 17.0)
        button.addTarget(self, action: #selector(buyButtonTapped), for: .touchUpInside)
        button.layer.frame = CGRect(x: 0, y: 0, width: 120, height: 50)
        
        return button
    }()
    
    lazy var backButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.textAlignment = .center
        button.setTitle("Go Back", for: UIControlState())
        button.titleLabel?.font = UIFont(name: "Avenir-Medium", size: 17.0)
        button.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
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
            
            backView.backgroundColor = UIColor.darkGray
            backView.addSubview(backButton)
            backView.layer.cornerRadius = 8.0
            
            if myDeck.isPurchased == true {
                buyButton.setTitle("Play", for: UIControlState())
            } else {
                // display buy button
                buyButton.setTitle("Buy", for: UIControlState())
                // figure out more logic
            }
        }
        
        
    }

    func backButtonTapped() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func buyButtonTapped() {
        if buyButton.title(for: UIControlState()) == "Play" {
            self.dismiss(animated: true, completion: nil)
            delegate?.playGame()
        } else {
            //handle purchasing a deck
        }
    }
    
        
//    func newBuyButton() -> UIButton {
//        let button = UIButton(type: .system)
//        button.setTitleColor(UIColor.white, for: .normal)
//        button.titleLabel?.textAlignment = .center
//        button.setTitle("Buy", for: UIControlState())
//        button.addTarget(self, action: #selector(ProductCollectionViewCell.buyButtonTapped(_:)), for: .touchUpInside)
//        button.layer.frame = CGRect(x: 0, y: 0, width: 120, height: 50)
//        
//        return button
//    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "selectPlaylistSegue" {
//            let destVC = segue.destination as! PlaylistsViewController
//            destVC.deck = deck
//        }
//    }


}
