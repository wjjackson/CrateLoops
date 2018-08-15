//
//  tblCellGenreSongs.swift
//  WJ Jackson
//
//  Created by Ashutosh Jani on 12/08/18.
//  Copyright © 2018 Ashutosh Jani. All rights reserved.
//

import UIKit

class tblCellGenreSongs: UITableViewCell {

    
    //-------------------------------
    // MARK: Outlets
    //-------------------------------
    
    @IBOutlet weak var btnOption: UIButton!
    @IBOutlet weak var songImg: UIImageView!
    @IBOutlet weak var lblSongName: UILabel!
    @IBOutlet weak var lblArtistName: UILabel!
    
    @IBOutlet weak var lblLikeCount: UILabel!
    @IBOutlet weak var lblDuration: UILabel!
    
    @IBOutlet weak var btnLike: UIButton!
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //------------------------------
    // MARK: Button Actions
    //------------------------------
    
    @IBAction func btnLikeTUI(_ sender: UIButton)
    {
        
        
        
    }
    

}
