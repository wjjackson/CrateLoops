//
//  GenreVC.swift
//  WJ Jackson
//
//  Created by Ashutosh Jani on 11/08/18.
//  Copyright © 2018 Ashutosh Jani. All rights reserved.
//

import UIKit
import Alamofire
import SVProgressHUD


class GenreVC: UIViewController, UITableViewDelegate, UITableViewDataSource
{
    
    //-------------------------------------
    // MARK: Outlets
    //-------------------------------------
    
    @IBOutlet weak var tblGenre: UITableView!
    
    //-------------------------------------
    // MARK: Identifiers
    //-------------------------------------
    
    var GenreData = NSMutableArray()
    
    //-------------------------------------
    // MARK: View Life Cycle
    //-------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()

        genreApi()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    //-------------------------------------
    // MARK: Delegate Methods
    //-------------------------------------
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return GenreData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let obj = tblGenre.dequeueReusableCell(withIdentifier: "tblCellGenre") as! tblCellGenre
        let dic = GenreData[indexPath.row] as! NSDictionary
        obj.lblGenreName.text = (dic["category_name"] as! String)
        obj.GenreImg.sd_setImage(with: URL(string: (dic["image"] as! String)), placeholderImage: UIImage(named: "Logo"), options: .refreshCached, completed: nil)
        return obj
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let dic = GenreData[indexPath.row] as! NSDictionary
       
        
        ApiString = "genresongs"
        SongVCBackId = 1
        parameter = ["u_id":123,"category_id":(dic["category_id"] as! Int)]
        songVCHeader = (dic["category_name"] as! String)
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
    
    func genreApi()
    {
        SVProgressHUD.show()
        self.view.isUserInteractionEnabled = false
        Alamofire.request("http://34.202.173.112/wjjackson/api/genres", method: .get, parameters: nil, encoding: JSONEncoding.default).validate().responseJSON
            { response in
                switch response.result
                {
                case .success:
                    print("Validation Successful")
                    let result = response.result.value! as! NSDictionary
                    print(result)
                    self.GenreData = (result["data"] as! NSArray).mutableCopy() as! NSMutableArray
                    self.tblGenre.reloadData()
                    SVProgressHUD.dismiss()
                    self.view.isUserInteractionEnabled = true
                case .failure(let error):
                    print(error)
                }
        }
        
        
        
    }

    

}
