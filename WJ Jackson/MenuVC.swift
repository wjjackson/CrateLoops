//
//  MenuVC.swift
//  WJ Jackson
//
//  Created by Ashutosh Jani on 11/08/18.
//  Copyright © 2018 Ashutosh Jani. All rights reserved.
//

import UIKit

class MenuVC: UIViewController
{
    
    //-------------------------------------
    // MARK: Outlets
    //-------------------------------------

    @IBOutlet weak var btnGenre: UIButton!
    
    //-------------------------------------
    // MARK: View Life Cycle
    //-------------------------------------
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //-------------------------------------
    // MARK: Button Actions
    //-------------------------------------
    
    @IBAction func btnAlbumTUI(_ sender: UIButton)
    {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "VcChanged"), object: nil, userInfo: ["Id":"AlbumVC"])
    }
    
    @IBAction func btnGenreTUI(_ sender: UIButton)
    {
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "VcChanged"), object: nil, userInfo: ["Id":"GenreVC"])
    }
    
    @IBAction func btnPlaylistTUI(_ sender: UIButton)
    {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "VcChanged"), object: nil, userInfo: ["Id":"PlaylistVC"])
    }
    
    @IBAction func btnFavouriteTUI(_ sender: UIButton)
    {
        parameter = ["u_id":123]
        ApiString = "favs/getsongs"
        SongVCBackId = 0
        songVCHeader = "My Favourites"
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "VcChanged"), object: nil, userInfo: ["Id":"GenreSongVC"])
    }
    
    @IBAction func btnEventsTUI(_ sender: UIButton)
    {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "VcChanged"), object: nil, userInfo: ["Id":"EventsVC"])
    }
    @IBAction func btnVideoTUI(_ sender: UIButton)
    {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "VcChanged"), object: nil, userInfo: ["Id":"VideoVC"])
    }
    @IBAction func btnNowPlayingTUI(_ sender: UIButton)
    {
        navigationController?.popViewController(animated: true)
    }
    @IBAction func btnMainPlayerTUI(_ sender: UIButton)
    {
        navigationController?.popViewController(animated: true)
    }
}
