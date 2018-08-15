//
//  tblCellArtistAlbum.swift
//  WJ Jackson
//
//  Created by Ashutosh Jani on 12/08/18.
//  Copyright © 2018 Ashutosh Jani. All rights reserved.
//

import UIKit

class tblCellArtistAlbum: UITableViewCell
{
    //-----------------------------------
    // MARK: Outlets
    //-----------------------------------

    @IBOutlet weak var albumImg: UIImageView!
    
    @IBOutlet weak var lblAlbumName: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
