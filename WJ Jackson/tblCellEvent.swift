//
//  tblCellEvent.swift
//  WJ Jackson
//
//  Created by Ashutosh Jani on 12/08/18.
//  Copyright © 2018 Ashutosh Jani. All rights reserved.
//

import UIKit

class tblCellEvent: UITableViewCell
{

    //-----------------------------
    // MARK: Outlets
    //-----------------------------
    
    @IBOutlet weak var eventImg: UIImageView!
    
    @IBOutlet weak var lblEventName: UILabel!
    
    @IBOutlet weak var lblEventAddress: UILabel!
    
    @IBOutlet weak var lblEventTime: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
