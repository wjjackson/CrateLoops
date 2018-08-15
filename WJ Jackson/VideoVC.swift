//
//  VideoVC.swift
//  WJ Jackson
//
//  Created by Ashutosh Jani on 12/08/18.
//  Copyright © 2018 Ashutosh Jani. All rights reserved.
//

import UIKit
import Alamofire
import SVProgressHUD
import SDWebImage

class VideoVC: UIViewController, UITableViewDataSource, UITableViewDelegate
{
    //----------------------------
    // MARK: Outlets
    //----------------------------

    @IBOutlet weak var tblVideo: UITableView!
    
    //----------------------------
    // MARK: Identifiers
    //----------------------------
    
    var videoData = NSMutableArray()
    
    //----------------------------
    // MARK: View Life Cycle
    //----------------------------
    override func viewDidLoad() {
        super.viewDidLoad()

        videoApi()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    //----------------------------
    // MARK: Delegate Method
    //----------------------------
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return videoData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let obj = tblVideo.dequeueReusableCell(withIdentifier: "tblCellVideo") as! tblCellVideo
        let dic = videoData[indexPath.row] as! NSDictionary
        obj.lblVideoName.text = (dic["name"] as! String)
        obj.lblDate.text = (dic["date"] as! String)
        obj.videoImg.sd_setImage(with: URL(string: (dic["image"] as! String)), placeholderImage: UIImage(named: "Logo"), options: SDWebImageOptions.refreshCached, completed: nil)
        return obj
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dic = videoData[indexPath.row] as! NSDictionary
        videoLink = (dic["video_link"] as! String)
        NotificationCenter.default.post(name: Notification.Name("VcChanged"), object: nil, userInfo: ["Id":"VideoPlayVC"])
    }

    //----------------------------
    // MARK: Button Action
    //----------------------------
    
    
    @IBAction func btnBackTUI(_ sender: UIButton)
    {
        NotificationCenter.default.post(name: Notification.Name("VcChanged"), object: nil, userInfo: ["Id":"MenuVC"])
    }
    
    @IBAction func btnNowPlayingTUI(_ sender: UIButton)
    {
        navigationController?.popViewController(animated: true)
    }
    
    //----------------------------
    // MARK: Web Services
    //----------------------------


    func videoApi()
    {
        SVProgressHUD.show()
        self.view.isUserInteractionEnabled = false
        
        Alamofire.request("http://34.202.173.112/wjjackson/api/videos", method: .get, parameters: nil, encoding: JSONEncoding.default).validate().responseJSON
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
                        self.videoData = (result["data"] as! NSArray).mutableCopy() as! NSMutableArray
                        self.tblVideo.reloadData()
                    }
                    
                    SVProgressHUD.dismiss()
                    self.view.isUserInteractionEnabled = true
                case .failure(let error):
                    print(error)
                }
        }
        
        
        
    }
}
