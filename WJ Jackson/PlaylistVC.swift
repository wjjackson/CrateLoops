//
//  PlaylistVC.swift
//  WJ Jackson
//
//  Created by Ashutosh Jani on 12/08/18.
//  Copyright © 2018 Ashutosh Jani. All rights reserved.
//

import UIKit
import Alamofire
import SVProgressHUD

class PlaylistVC: UIViewController, UITableViewDataSource, UITableViewDelegate
{
    //------------------------------
    // MARK: Outlets
    //------------------------------
    
    @IBOutlet weak var tblPlaylist: UITableView!
    
    //------------------------------
    // MARK: Identifiers
    //------------------------------
    
    var playlistId = Int()
    
    var playlistData = NSMutableArray()
    
    //------------------------------
    // MARK: View Life Cycle
    //------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        playlistApi()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //------------------------------
    // MARK: Delegate Methods
    //------------------------------

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return playlistData.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let obj = tblPlaylist.dequeueReusableCell(withIdentifier: "tblCellPlaylist") as! tblCellPlaylist
        let dic = playlistData[indexPath.row] as! NSDictionary
        obj.lblPlaylistName.text = (dic["name"] as! String)
        obj.lblSongCount.text = String(dic["total_count"] as! Int)
        obj.playlistImg.image = UIImage(named: "Logo")
        obj.btnDeletePlaylist.tag = (dic["playlist_id"] as! Int)
        return obj
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let dic = playlistData[indexPath.row] as! NSDictionary
        songVCHeader = (dic["name"] as! String)
        
        ApiString = "playlist/getsongs"
        SongVCBackId = 3
        parameter = ["u_id":123,"playlist_id":(dic["playlist_id"] as! Int)]
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "VcChanged"), object: nil, userInfo: ["Id":"GenreSongVC"])
        
    }
    
    //------------------------------
    // MARK: Button Actions
    //------------------------------
    
    @IBAction func btnBackTUI(_ sender: UIButton)
    {
        NotificationCenter.default.post(name: Notification.Name("VcChanged"), object: nil, userInfo: ["Id":"MenuVC"])
    }
    
    @IBAction func btnNowPlayingTUI(_ sender: UIButton)
    {
        navigationController?.popViewController(animated: true)
    }

    @IBAction func btnDeletePlaylistTUI(_ sender: UIButton)
    {
        let refreshAlert = UIAlertController(title: "Delete!!!", message: "Are you sure to delete playlist?", preferredStyle: UIAlertControllerStyle.alert)
        
        refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
            self.playlistId = sender.tag
            self.removePlaylistAPI()
        }))
        
        refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
            print("Handle Cancel Logic here")
        }))
        
        present(refreshAlert, animated: true, completion: nil)
        
    }
    //------------------------------
    // MARK: Web Services
    //------------------------------
    
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
                        self.playlistData.removeAllObjects()
                        self.tblPlaylist.reloadData()
                    }
                    else
                    {
                        self.playlistData = (result["data"] as! NSArray).mutableCopy() as! NSMutableArray
                        self.tblPlaylist.reloadData()
                    }
                    
                    SVProgressHUD.dismiss()
                    self.view.isUserInteractionEnabled = true
                case .failure(let error):
                    print(error)
                }
        }
        
        
        
    }
    func removePlaylistAPI()
    {
        SVProgressHUD.show()
        
        let parameter = ["playlist_id":playlistId] as [String : Any]
        Alamofire.request("http://34.202.173.112/wjjackson/api/playlist/removePlaylist", method: .post, parameters: parameter, encoding: JSONEncoding.default).validate().responseJSON
            { response in
                switch response.result
                {
                case .success:
                    print("Validation Successful")
                    let result = response.result.value! as! NSDictionary
                    print(result)
                    
                    
                    SVProgressHUD.dismiss()
                    self.playlistApi()
                    
                case .failure(let error):
                    print(error)
                }
        }
        
        
        
    }
}
