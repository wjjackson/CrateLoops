//
//  GenreSongVC.swift
//  WJ Jackson
//
//  Created by Ashutosh Jani on 12/08/18.
//  Copyright © 2018 Ashutosh Jani. All rights reserved.
//

import UIKit
import Alamofire
import SVProgressHUD

class GenreSongVC: UIViewController, UITableViewDelegate, UITableViewDataSource
{
    //-------------------------------------
    // MARK: Outlets
    //-------------------------------------

    @IBOutlet weak var tblSongList: UITableView!
    
    @IBOutlet weak var btnRemoveFromFav: UIButton!
    @IBOutlet weak var btnHideOptions: UIButton!
    @IBOutlet weak var tblPlaylistOption: UITableView!
    @IBOutlet weak var removeFavView: UIView!
    @IBOutlet weak var lblSongVCHeader: UILabel!
    
    @IBOutlet weak var txtPlaylistName: UITextField!
    @IBOutlet weak var addPlaylistView: UIView!
    
    @IBOutlet weak var NewOrOldPlaylistView: UIView!
    @IBOutlet weak var createPlaylistView: UIView!
    //-------------------------------------
    // MARK: Identifiers
    //-------------------------------------
    
    var playlistId = Int()
    
    var songData = NSMutableArray()
    var playlistData = NSMutableArray()
    
    //-------------------------------------
    // MARK: View Life Cycle
    //-------------------------------------
    override func viewDidLoad() {
        super.viewDidLoad()

        btnHideOptions.isHidden = true
        tblPlaylistOption.isHidden = true
        NewOrOldPlaylistView.isHidden = true
        addPlaylistView.isHidden = true
        removeFavView.isHidden = true
        createPlaylistView.isHidden = true
        songApi()
        lblSongVCHeader.text = songVCHeader
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //-------------------------------------
    // MARK: Delegate Methods
    //-------------------------------------
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if tableView.tag == 13
        {
            return playlistData.count
        }
        else
        {
            return songData.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if tableView.tag == 13
        {
            let obj = tblPlaylistOption.dequeueReusableCell(withIdentifier: "tblCellPlaylistOption") as! tblCellPlaylistOption
            let dic = playlistData[indexPath.row] as! NSDictionary
            obj.lblPlaylistName.text = (dic["name"] as! String)
            return obj
        }
        else
        {
            let obj = tblSongList.dequeueReusableCell(withIdentifier: "tblCellGenreSongs") as! tblCellGenreSongs
            let dic = songData[indexPath.row] as! NSDictionary
            obj.lblSongName.text = (dic["song_name"] as! String)
            obj.lblArtistName.text = (dic["artist_name"] as! String)
            obj.songImg.sd_setImage(with: URL(string: (dic["image"] as! String)), placeholderImage: UIImage(named: "Logo"), options: .refreshCached, completed: nil)
            obj.lblLikeCount.text = String(dic["total_likes"] as! Int)
            obj.lblDuration.text = (dic["song_time"] as! String)
           
            obj.btnOption.tag = indexPath.row
            
            obj.btnLike.tag = (dic["song_id"] as! Int)
            print(obj.btnLike.tag)
            if (dic["like_status"] as! Int) == 0
            {
                obj.btnLike.isSelected = false
            }
            else
            {
                obj.btnLike.isSelected = true
            }
            return obj
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.tag == 13
        {
            let dic = playlistData[indexPath.row] as! NSDictionary
            playlistId = (dic["playlist_id"] as! Int)
            addSongToPlaylistAPI()
            btnHideOptions.isHidden = true
            tblPlaylistOption.isHidden = true
        }
        else
        {
            if songData == SongList
            {
                songIndex = indexPath.row
                playSong()
            }
            else
            {
                SongList = songData
                songIndex = indexPath.row
                playSong()
                
            }
        }
    }
    
    //-------------------------------------
    // MARK: User Defined Function
    //-------------------------------------
    
    func playSong()
    {
        
        let dic = SongList[songIndex] as! NSDictionary
        audioPlayerSTK.play(dic["song_url"] as! String)
        
        
    }
    
    //-------------------------------------
    // MARK: Button Actions
    //-------------------------------------
    
    @IBAction func btnBackTUI(_ sender: UIButton)
    {
        if SongVCBackId == 0
        {
            NotificationCenter.default.post(name: Notification.Name(rawValue: "VcChanged"), object: nil, userInfo: ["Id":"MenuVC"])
        }
        else if SongVCBackId == 1
        {
            NotificationCenter.default.post(name: Notification.Name(rawValue: "VcChanged"), object: nil, userInfo: ["Id":"GenreVC"])
        }
        else if SongVCBackId == 2
        {
            NotificationCenter.default.post(name: Notification.Name(rawValue: "VcChanged"), object: nil, userInfo: ["Id":"AlbumVC"])
        }
        else if SongVCBackId == 3
        {
            NotificationCenter.default.post(name: Notification.Name(rawValue: "VcChanged"), object: nil, userInfo: ["Id":"PlaylistVC"])
        }
        
    }
    @IBAction func btnLikeTUI(_ sender: UIButton)
    {
        songId = sender.tag
        print(songId)
        likeAPI()
    }
    @IBAction func btnOptionTUI(_ sender: UIButton)
    {
        let dic = songData[sender.tag] as! NSDictionary
        songId = (dic["song_id"] as! Int)
        btnHideOptions.isHidden = false
        
        if SongVCBackId == 0
        {
            btnRemoveFromFav.tag = sender.tag
            removeFavView.isHidden = false
        }
        else
        {
            addPlaylistView.isHidden = false
        }
    }
    @IBAction func btnAddToPlaylistTUI(_ sender: UIButton)
    {
        addPlaylistView.isHidden = true
        NewOrOldPlaylistView.isHidden = false
    }
    @IBAction func btnAddToFavouriteTUI(_ sender: UIButton)
    {
        addPlaylistView.isHidden = true
        btnHideOptions.isHidden = true
        addSongToFavouritesAPI()
    }
    @IBAction func btnExistingPlaylistTUI(_ sender: UIButton)
    {
        NewOrOldPlaylistView.isHidden = true
        tblPlaylistOption.isHidden = false
        playlistApi()
    }
    
    @IBAction func btnNewPlaylistTUI(_ sender: UIButton)
    {
        NewOrOldPlaylistView.isHidden = true
        createPlaylistView.isHidden = false
    }
    @IBAction func btnCreatePlaylistTUI(_ sender: UIButton)
    {
        createPlaylistView.isHidden = true
        newPlaylistAPI()
        tblPlaylistOption.isHidden = false
        playlistApi()
        
    }
    @IBAction func btnHIdeOptionsTUI(_ sender: UIButton)
    {
        btnHideOptions.isHidden = true
        tblPlaylistOption.isHidden = true
        NewOrOldPlaylistView.isHidden = true
        addPlaylistView.isHidden = true
        removeFavView.isHidden = true
        createPlaylistView.isHidden = true
    }
    
    @IBAction func btnNowPlayingTUI(_ sender: UIButton)
    {
        navigationController?.popViewController(animated: true)
    }
    @IBAction func btnRemoveFavourite(_ sender: UIButton)
    {
        
        let dic = songData[sender.tag] as! NSDictionary
        
        songId = (dic["fav_id"] as! Int)
        removeSongFromFavouritesAPI()
    }
    
    //-------------------------------------
    // MARK: Web Services
    //-------------------------------------
    
    func songApi()
    {
        SVProgressHUD.show()
        self.view.isUserInteractionEnabled = false
        let str = "http://34.202.173.112/wjjackson/api/"+ApiString
        print(str)
        Alamofire.request(str, method: .post, parameters: parameter, encoding: JSONEncoding.default).validate().responseJSON
            { response in
                switch response.result
                {
                case .success:
                    print("Validation Successful")
                    let result = response.result.value! as! NSDictionary
                    print(result)
                    if (result["status"] as! Int) == 0
                    {
                        self.songData.removeAllObjects()
                        self.tblSongList.reloadData()
                    }
                    else
                    {
                        self.songData = (result["data"] as! NSArray).mutableCopy() as! NSMutableArray
                        self.tblSongList.reloadData()
                    }
                    SVProgressHUD.dismiss()
                    self.view.isUserInteractionEnabled = true
                case .failure(let error):
                    print(error)
                }
        }



    }
    
    func playlistApi()
    {
        SVProgressHUD.show()
        self.view.isUserInteractionEnabled = false
        let parameter = ["u_id":123]
        Alamofire.request("http://34.202.173.112/wjjackson/api/playlist/user", method: .post, parameters: parameter, encoding: JSONEncoding.default).validate().responseJSON
            { response in
                switch response.result
                {
                case .success:
                    print("Validation Successful")
                    let result = response.result.value! as! NSDictionary
                    print(result)
                    if (result["status"] as! Int) == 0
                    {
                        
                    }
                    else
                    {
                        self.playlistData = (result["data"] as! NSArray).mutableCopy() as! NSMutableArray
                        self.tblPlaylistOption.reloadData()
                    }
                    
                    SVProgressHUD.dismiss()
                    self.view.isUserInteractionEnabled = true
                case .failure(let error):
                    print(error)
                }
        }
        
        
        
    }
    
    func newPlaylistAPI()
    {
        SVProgressHUD.show()
        self.view.isUserInteractionEnabled = false
        let parameter = ["u_id":123, "name": txtPlaylistName.text!] as [String : Any]
        Alamofire.request("http://34.202.173.112/wjjackson/api/playlist/new", method: .post, parameters: parameter, encoding: JSONEncoding.default).validate().responseJSON
            { response in
                switch response.result
                {
                case .success:
                    print("Validation Successful")
                    let result = response.result.value! as! NSDictionary
                    print(result)
                    
                    SVProgressHUD.dismiss()
                    self.view.isUserInteractionEnabled = true
                case .failure(let error):
                    print(error)
                }
        }
        
        
        
    }
    
    func addSongToPlaylistAPI()
    {
        SVProgressHUD.show()
        self.view.isUserInteractionEnabled = false
        let parameter = ["u_id":123, "playlist_id": playlistId, "song_id": songId] as [String : Any]
        Alamofire.request("http://34.202.173.112/wjjackson/api/playlist/add", method: .post, parameters: parameter, encoding: JSONEncoding.default).validate().responseJSON
            { response in
                switch response.result
                {
                case .success:
                    print("Validation Successful")
                    let result = response.result.value! as! NSDictionary
                    print(result)
                    
                    SVProgressHUD.dismiss()
                    self.view.isUserInteractionEnabled = true
                case .failure(let error):
                    print(error)
                }
        }
        
        
        
    }
    
    func addSongToFavouritesAPI()
    {
        SVProgressHUD.show()
        self.view.isUserInteractionEnabled = false
        let parameter = ["u_id":123, "song_id": songId] as [String : Any]
        Alamofire.request("http://34.202.173.112/wjjackson/api/favs/add", method: .post, parameters: parameter, encoding: JSONEncoding.default).validate().responseJSON
            { response in
                switch response.result
                {
                case .success:
                    print("Validation Successful")
                    let result = response.result.value! as! NSDictionary
                    print(result)
                    
                    SVProgressHUD.dismiss()
                    self.view.isUserInteractionEnabled = true
                case .failure(let error):
                    print(error)
                }
        }
        
        
        
    }
    
    func removeSongFromFavouritesAPI()
    {
        SVProgressHUD.show()
        self.view.isUserInteractionEnabled = false
        let parameter = ["fav_id": songId] as [String : Any]
        print(songId)
        Alamofire.request("http://34.202.173.112/wjjackson/api/favs/remove", method: .post, parameters: parameter, encoding: JSONEncoding.default).validate().responseJSON
            { response in
                switch response.result
                {
                case .success:
                    print("Validation Successful")
                    let result = response.result.value! as! NSDictionary
                    print(result)
                    self.removeFavView.isHidden = true
                    self.btnHideOptions.isHidden = true
                    self.songApi()
                    
                    SVProgressHUD.dismiss()
                    self.view.isUserInteractionEnabled = true
                case .failure(let error):
                    print(error)
                }
        }
        
        
        
    }
    
    func likeAPI()
    {
        SVProgressHUD.show()
        self.view.isUserInteractionEnabled = false
        let parameter = ["u_id":123, "song_id": songId] as [String : Any]
        print(songId)
        Alamofire.request("http://34.202.173.112/wjjackson/api/addlike", method: .post, parameters: parameter, encoding: JSONEncoding.default).validate().responseJSON
            { response in
                switch response.result
                {
                case .success:
                    print("Validation Successful")
                    let result = response.result.value! as! NSDictionary
                    print(result)
                    
                    self.songApi()
                    
                    SVProgressHUD.dismiss()
                    self.view.isUserInteractionEnabled = true
                case .failure(let error):
                    print(error)
                }
        }
        
        
        
    }
}
