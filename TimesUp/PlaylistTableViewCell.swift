//
//  PlaylistTableViewCell.swift
//  TimesUp
//
//  Created by Christopher Walter on 8/14/17.
//  Copyright © 2017 com.AssistStat. All rights reserved.
//

import UIKit

class PlaylistTableViewCell: UITableViewCell {

    @IBOutlet weak var numberOfSongsLabel: UILabel!
    @IBOutlet weak var playListTitleLabel: UILabel!
    
    var playlist: Playlist? {
        didSet {
            playListTitleLabel.text = playlist?.title
            if let songsCount = playlist?.deviceSongs?.count {
                numberOfSongsLabel.text = "\(String(describing: songsCount)) songs"
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
