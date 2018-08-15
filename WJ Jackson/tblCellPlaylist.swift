//
//  tblCellPlaylist.swift
//  WJ Jackson
//
//  Created by Ashutosh Jani on 12/08/18.
//  Copyright © 2018 Ashutosh Jani. All rights reserved.
//

import UIKit

class tblCellPlaylist: UITableViewCell {
    
    //-----------------------------------
    // MARK: Outlets
    //-----------------------------------

    @IBOutlet weak var playlistImg: UIImageView!
    
    @IBOutlet weak var lblPlaylistName: UILabel!
    
    @IBOutlet weak var lblSongCount: UILabel!
    
    @IBOutlet weak var btnDeletePlaylist: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
