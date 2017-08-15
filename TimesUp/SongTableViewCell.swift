//
//  SongTableViewCell.swift
//  TimesUp
//
//  Created by Christopher Walter on 8/14/17.
//  Copyright © 2017 com.AssistStat. All rights reserved.
//

import UIKit

class SongTableViewCell: UITableViewCell {

    @IBOutlet weak var lengthLabel: UILabel!
    @IBOutlet weak var artistLabel: UILabel!
    @IBOutlet weak var songTitleLabel: UILabel!
    @IBOutlet weak var positionLabel: UILabel!
    
    var song: Song? {
        didSet {

            artistLabel.text = song?.artist
            songTitleLabel.text = song?.title
            
            if let lengthAsDouble = song?.length {
                let min: Int = Int(lengthAsDouble) / 60
                let seconds: Int = Int(lengthAsDouble) % 60
                var secondsAsString = ""
                if seconds < 10 {
                    secondsAsString = "0\(seconds)"
                } else {
                    secondsAsString = "\(seconds)"
                }
                let time = "\(min):\(secondsAsString)"
                lengthLabel.text = time
            } else {
                lengthLabel.text = "Error"
            }
            
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
