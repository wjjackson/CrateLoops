//
//  EventsVC.swift
//  WJ Jackson
//
//  Created by Ashutosh Jani on 12/08/18.
//  Copyright © 2018 Ashutosh Jani. All rights reserved.
//

import UIKit
import Alamofire
import SVProgressHUD
import SDWebImage

class EventsVC: UIViewController, UITableViewDelegate, UITableViewDataSource
{
    //-------------------------------
    // MARK: Outlets
    //-------------------------------

    @IBOutlet weak var tblEvents: UITableView!
    
    //-------------------------------
    // MARK: Identifiers
    //-------------------------------
    
    var eventData = NSMutableArray()
    
    //-------------------------------
    // MARK: View Life Cycle
    //-------------------------------
    override func viewDidLoad() {
        super.viewDidLoad()

        eventApi()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //-------------------------------
    // MARK: Delegate Methods
    //-------------------------------
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return eventData.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let obj = tblEvents.dequeueReusableCell(withIdentifier: "tblCellEvent") as! tblCellEvent
        let dic = eventData[indexPath.row] as! NSDictionary
        obj.lblEventName.text = (dic["title"] as! String)
        obj.lblEventAddress.text = (dic["address"] as! String)
        obj.lblEventTime.text = (dic["time"] as! String)
        obj.eventImg.sd_setImage(with: URL(string: (dic["image"] as! String)), placeholderImage: UIImage(named: "Logo"), options: .refreshCached, completed: nil)
        return obj
    }
    
    //-------------------------------
    // MARK: Button Actions
    //-------------------------------

    @IBAction func btnBackTUI(_ sender: UIButton)
    {
        NotificationCenter.default.post(name: Notification.Name("VcChanged"), object: nil, userInfo: ["Id":"MenuVC"])
    }
    
    @IBAction func btnNowPlayingTUI(_ sender: UIButton)
    {
        navigationController?.popViewController(animated: true)
    }
    
    //-------------------------------
    // MARK: Web Services
    //-------------------------------
    

    func eventApi()
    {
        SVProgressHUD.show()
        self.view.isUserInteractionEnabled = false
        
        Alamofire.request("http://34.202.173.112/wjjackson/api/events", method: .get, parameters: nil, encoding: JSONEncoding.default).validate().responseJSON
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
                        self.eventData = (result["data"] as! NSArray).mutableCopy() as! NSMutableArray
                        self.tblEvents.reloadData()
                    }
                    
                    SVProgressHUD.dismiss()
                    self.view.isUserInteractionEnabled = true
                case .failure(let error):
                    print(error)
                }
        }
        
        
        
    }
}
