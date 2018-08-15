//
//  AlbumVC.swift
//  WJ Jackson
//
//  Created by Ashutosh Jani on 12/08/18.
//  Copyright © 2018 Ashutosh Jani. All rights reserved.
//

import UIKit
import Alamofire
import SVProgressHUD

class AlbumVC: UIViewController, UITableViewDataSource, UITableViewDelegate
{
    //------------------------------
    // MARK: Outlets
    //------------------------------

    @IBOutlet weak var tblAlbum: UITableView!
    
    //-------------------------------------
    // MARK: Identifiers
    //-------------------------------------
    
    var albumData = NSMutableArray()
    
    //-------------------------------------
    // MARK: View Life Cycle
    //-------------------------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        albumApi()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //-------------------------------------
    // MARK: Delegate Methods
    //-------------------------------------
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return albumData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let obj = tblAlbum.dequeueReusableCell(withIdentifier: "tblCellArtistAlbum") as! tblCellArtistAlbum
        let dic = albumData[indexPath.row] as! NSDictionary
        obj.lblAlbumName.text = (dic["artist_name"] as! String)
        obj.albumImg.sd_setImage(with: URL(string: (dic["image"] as! String)), placeholderImage: UIImage(named: "Logo"), options: .refreshCached, completed: nil)
        return obj
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let dic = albumData[indexPath.row] as! NSDictionary
        songVCHeader = (dic["artist_name"] as! String)
        
        ApiString = "artists/songs"
        parameter = ["u_id": 123, "artist_id": (dic["artist_id"] as! Int)]
        SongVCBackId = 2
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "VcChanged"), object: nil, userInfo: ["Id":"GenreSongVC"])
        
    }
    
    //-------------------------------------
    // MARK: Button Actions
    //-------------------------------------
    
    @IBAction func btnBackTUI(_ sender: UIButton)
    {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "VcChanged"), object: nil, userInfo: ["Id":"MenuVC"])
    }
    
    @IBAction func btnNowPlayingTUI(_ sender: UIButton)
    {
        navigationController?.popViewController(animated: true)
    }
    
    //-------------------------------------
    // MARK: Web Services
    //-------------------------------------
    

    func albumApi()
    {
        SVProgressHUD.show()
        self.view.isUserInteractionEnabled = false
        Alamofire.request("http://34.202.173.112/wjjackson/api/artists", method: .get, parameters: nil, encoding: JSONEncoding.default).validate().responseJSON
            { response in
                switch response.result
                {
                case .success:
                    print("Validation Successful")
                    let result = response.result.value! as! NSDictionary
                    print(result)
                    self.albumData = (result["data"] as! NSArray).mutableCopy() as! NSMutableArray
                    self.tblAlbum.reloadData()
                    SVProgressHUD.dismiss()
                    self.view.isUserInteractionEnabled = true
                case .failure(let error):
                    print(error)
                }
        }
        
        
        
    }

}
