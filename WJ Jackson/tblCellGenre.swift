//
//  tblCellGenre.swift
//  WJ Jackson
//
//  Created by Ashutosh Jani on 11/08/18.
//  Copyright © 2018 Ashutosh Jani. All rights reserved.
//

import UIKit

class tblCellGenre: UITableViewCell
{
    //-------------------------------
    // MARK: Outlets
    //-------------------------------

    @IBOutlet weak var GenreImg: UIImageView!
    
    @IBOutlet weak var lblGenreName: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
