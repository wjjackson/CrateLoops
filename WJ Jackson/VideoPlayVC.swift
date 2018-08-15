//
//  VideoPlayVC.swift
//  WJ Jackson
//
//  Created by Ashutosh Jani on 13/08/18.
//  Copyright © 2018 Ashutosh Jani. All rights reserved.
//

import UIKit
import WebKit
import SVProgressHUD

class VideoPlayVC: UIViewController
{
    //---------------------------
    // MARK: Outlets
    //---------------------------
    @IBOutlet weak var VideoWebView: WKWebView!
    
    
    
    //---------------------------
    // MARK: View Life Cycle
    //---------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        
        VideoWebView.load(URLRequest(url: URL(string: videoLink)!))
        
        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //---------------------------
    // MARK: Button Actions
    //---------------------------

    @IBAction func btnBackTUI(_ sender: UIButton)
    {
        NotificationCenter.default.post(name: Notification.Name("VcChanged"), object: nil, userInfo: ["Id":"VideoVC"])
    }
    
    //---------------------------
    // MARK: User Defined Functions
    //---------------------------
    
    
    

}
