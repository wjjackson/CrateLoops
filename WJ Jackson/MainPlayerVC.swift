//
//  MainPlayerVC.swift
//  WJ Jackson
//
//  Created by Ashutosh Jani on 11/08/18.
//  Copyright © 2018 Ashutosh Jani. All rights reserved.
//

import UIKit
import Alamofire
import SVProgressHUD
import FirebaseInstanceID
import StreamingKit
import MediaPlayer

class MainPlayerVC: UIViewController, STKAudioPlayerDelegate
{
    
    
    //-------------------------------------
    // MARK: Outlets
    //-------------------------------------
    
    @IBOutlet weak var playerGif: UIImageView!
    @IBOutlet weak var btnShuffle: UIButton!
    @IBOutlet weak var btnRepeat: UIButton!
    @IBOutlet weak var btnPlay: UIButton!
    @IBOutlet weak var seekSlider: UISlider!
    @IBOutlet weak var lblSongDuration: UILabel!
    @IBOutlet weak var lblSongName: UILabel!
    
    //--------------------------------------
    // MARK: Identifiers
    //--------------------------------------
    
    var timer = Timer()
    
    
    //-------------------------------------
    // MARK: View Life Cycle
    //-------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()

        do{
            
            
            try AVAudioSession.sharedInstance().setCategory({AVAudioSessionCategoryPlayback}())
            try AVAudioSession.sharedInstance().setActive(true)
        }
            
        catch
        {
            print("there is an exception")
        }
        allSongApi()
        registerUserApi()
        audioPlayerSTK.delegate = self
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool)
    {

        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(Loader), userInfo: nil, repeats: true)
        timer.fire()
    
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //--------------------------
    // MARK: Delegate Method
    //--------------------------
    
    func audioPlayer(_ audioPlayer: STKAudioPlayer, didStartPlayingQueueItemId queueItemId: NSObject) {
        
    }
    
    func audioPlayer(_ audioPlayer: STKAudioPlayer, didFinishBufferingSourceWithQueueItemId queueItemId: NSObject) {
        
    }
    
    func audioPlayer(_ audioPlayer: STKAudioPlayer, stateChanged state: STKAudioPlayerState, previousState: STKAudioPlayerState)
    {
        switch state {
        case .buffering:
            SVProgressHUD.show()
        case .playing:
            SVProgressHUD.dismiss()
        default:
            print("state: ",state)
        }
        
    }
    
    func audioPlayer(_ audioPlayer: STKAudioPlayer, didFinishPlayingQueueItemId queueItemId: NSObject, with stopReason: STKAudioPlayerStopReason, andProgress progress: Double, andDuration duration: Double)
    {
        print(seekSlider.value)
        print(UInt8((audioPlayerSTK.state).rawValue))
        
        if audioPlayerSTK.state == .init(rawValue: 16)
        {
            if btnShuffle.isSelected
            {
                songIndex = Int(arc4random_uniform(UInt32(SongList.count)))
                 playSong()
                
            }
            else if btnRepeat.isSelected
            {
                playSong()
            }
            else if songIndex == SongList.count - 1
                    {
                        songIndex = 0
                        playSong()
                    }
                    else
                    {
                        songIndex += 1
                        playSong()
                    }
        }
        

        
    }
    
    func audioPlayer(_ audioPlayer: STKAudioPlayer, unexpectedError errorCode: STKAudioPlayerErrorCode)
    {
        
    }
    
    //--------------------------
    // MARK: Button Actions
    //--------------------------
    
    @IBAction func btnMenuTUI(_ sender: UIButton)
    {
        let obj = storyboard?.instantiateViewController(withIdentifier: "Player2VC") as! Player2VC
        navigationController?.pushViewController(obj, animated: true)
    }
    
    @IBAction func btnPlayTUI(_ sender: UIButton)
    {
        if !btnPlay.isSelected
        {
            if songIndex == -1
            {
                songIndex += 1
                playSong()
                btnPlay.isSelected = true
            }
            else
            {
                audioPlayerSTK.resume()
                btnPlay.isSelected = true
            }
            
        }
        else
        {
            
            audioPlayerSTK.pause()
            btnPlay.isSelected = false
        }
        
        
    }
    
    @IBAction func btnNextTUI(_ sender: UIButton)
    {
        if songIndex == SongList.count - 1
        {
            songIndex = 0
            playSong()
        }
        else
        {
            songIndex += 1
            playSong()
        }
    }
    
    @IBAction func btnPreviousTUI(_ sender: UIButton)
    {
        if songIndex == 0
        {
            songIndex = SongList.count - 1
            playSong()
        }
        else
        {
            songIndex -= 1
            playSong()
        }
    }
    
    @IBAction func seekSliderVC(_ sender: UISlider)
    {
        audioPlayerSTK.seek(toTime: Double(seekSlider.value))
    }
    
    @IBAction func btnRepeatTUI(_ sender: UIButton)
    {
        if btnRepeat.isSelected
        {
            btnRepeat.isSelected = false
        }
        else
        {
            btnRepeat.isSelected = true
        }
    }
    
    @IBAction func btnShuffleTUI(_ sender: UIButton)
    {
        if btnShuffle.isSelected
        {
            btnShuffle.isSelected = false
        }
        else
        {
            btnShuffle.isSelected = true
        }
    }
    
    
    //--------------------------------------
    // MARK: User Defined Functions
    //--------------------------------------
    
    
    func playSong()
    {
        
            let dic = SongList[songIndex] as! NSDictionary
            audioPlayerSTK.play(dic["song_url"] as! String)
        commandCenter()
        btnPlay.isSelected = true
        
    }
    
    @objc func Loader()
     {
        
        seekSlider.maximumValue = Float(audioPlayerSTK.duration)
        seekSlider.value = Float(audioPlayerSTK.progress)
        lblSongDuration.text = (String(Int(Float(audioPlayerSTK.progress)/3600)) + ":" + String(Int(Float(audioPlayerSTK.progress)/60)) + ":" + String(Int(Float(audioPlayerSTK.progress).truncatingRemainder(dividingBy: 60))))
        if songIndex != -1
        {
            let dic = SongList[songIndex] as! NSDictionary
            lblSongName.text = (dic["song_name"] as! String)
        }
        if audioPlayerSTK.state == .playing
        {
            if playerGif.image == UIImage(named: "StaticGifImg")
            {
                playerGif.loadGif(name: "gif")
            }
            btnPlay.isSelected = true
        }
        else
        {
            if playerGif.image != UIImage(named: "StaticGifImg")
            {
               playerGif.image = UIImage(named: "StaticGifImg")
            }
            
            btnPlay.isSelected = false
        }
        
    }
    
    func commandCenter()
    {
        self.setupNowPlaying()
        let commandObj = MPRemoteCommandCenter.shared()
        commandObj.playCommand.addTarget { [] event in
            
            
            self.setupNowPlaying()
            if audioPlayerSTK.state != .playing
            {
                audioPlayerSTK.resume()
                self.btnPlay.isSelected = true
            }
            
            return .success
            
            //return .commandFailed
        }
        commandObj.pauseCommand.addTarget { [] event in
            if audioPlayerSTK.state == .playing
            {
                audioPlayerSTK.pause()
                self.btnPlay.isSelected = false
                return .success
            }
            return .commandFailed
        }
        commandObj.nextTrackCommand.addTarget { [] event in
            self.setupNowPlaying()
            if songIndex == SongList.count - 1
            {
                songIndex = 0
                self.playSong()
                return .success
            }
            else
            {
                songIndex += 1
                self.playSong()
                return .success
            }
            
            //return .commandFailed
        }
        commandObj.previousTrackCommand.addTarget { [] event in
            self.setupNowPlaying()
            if songIndex == 0
            {
                songIndex = SongList.count - 1
                self.playSong()
                return .success
            }
            else
            {
                songIndex -= 1
                self.playSong()
                return .success
            }
            
            
            //return .commandFailed
        }
        
        
    }
    func setupNowPlaying() {
        // Define Now Playing Info
        var nowPlayingInfo = [String : Any]()
        let dic = SongList[songIndex] as! NSDictionary
        nowPlayingInfo[MPMediaItemPropertyTitle] = (dic["song_name"] as! String)
        
        if let image = UIImage(named: "lockscreen") {
            
            if #available(iOS 10.0, *) {
                nowPlayingInfo[MPMediaItemPropertyArtwork] =
                    MPMediaItemArtwork(boundsSize: image.size) { size in
                        return image
                }
            } else {
                // Fallback on earlier versions
            }
            
        }
        nowPlayingInfo[MPNowPlayingInfoPropertyElapsedPlaybackTime] = (String(Int(Float(audioPlayerSTK.progress)/3600)) + ":" + String(Int(Float(audioPlayerSTK.progress)/60)) + ":" + String(Int(Float(audioPlayerSTK.progress).truncatingRemainder(dividingBy: 60))))
        nowPlayingInfo[MPMediaItemPropertyPlaybackDuration] = (String(Int(Float(audioPlayerSTK.progress)/3600)) + ":" + String(Int(Float(audioPlayerSTK.progress)/60)) + ":" + String(Int(Float(audioPlayerSTK.progress).truncatingRemainder(dividingBy: 60))))
        
        
        
        // Set the metadata
        MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
    }
    
    //---------------------------
    // MARK: Web Services
    //---------------------------

    func registerUserApi()
    {
        SVProgressHUD.show()
        self.view.isUserInteractionEnabled = false
        print(appDelegate.GcmId)
        let parameter = ["gcm_id": "e-RrXHL4UMA:APA91bGJ8gaKlPGe-aM0hJbw02lgX-hoeJQTH7D2kiayeR4gO2U14-S0Ti3V4NwuXKH5Hcu7tHu-q6YunS4iqrzlR6IVc_sIIhFidDzk8ghvbRgGmKUz5lYDQjcZw5d-tjqkMGsM40TekN4iEOSzGi6YlUxHZ87Ldw", "device":"ios", "u_id": UIDevice.current.identifierForVendor!.uuidString]
        
        Alamofire.request("http://34.202.173.112/wjjackson/api/add_user", method: .post, parameters: parameter, encoding: JSONEncoding.default).validate().responseJSON
            { response in
                switch response.result
                {
                case .success:
                    print("Validation Successful")
                    let result = response.result.value! as! NSDictionary
                    print(result)
                    let dic = (result["data"] as! NSDictionary)
                    user_id = (dic["u_id"] as! String)
                    SVProgressHUD.dismiss()
                    self.view.isUserInteractionEnabled = true
                case .failure(let error):
                    print(error)
                }
        }
        
        
        
    }
    
    func allSongApi()
    {
        SVProgressHUD.show()
        
        print(appDelegate.GcmId)
        let parameter = ["u_id":123]
        
        Alamofire.request("http://34.202.173.112/wjjackson/api/all_songs", method: .post, parameters: parameter, encoding: JSONEncoding.default).validate().responseJSON
            { response in
                switch response.result
                {
                case .success:
                    print("Validation Successful")
                    let result = response.result.value! as! NSDictionary
                    print(result)
                    SongList = ((result["data"] as! NSArray).mutableCopy()) as! NSMutableArray
                    //let dic = (result["data"] as! NSDictionary)
                    //user_id = (dic["u_id"] as! String)
                
                    SVProgressHUD.dismiss()
                    
                    
                case .failure(let error):
                    print(error)
                }
        }
        
        
        
    }
}
