//
//  Player2VC.swift
//  WJ Jackson
//
//  Created by Ashutosh Jani on 11/08/18.
//  Copyright © 2018 Ashutosh Jani. All rights reserved.
//

import UIKit
import MediaPlayer

class Player2VC: UIViewController
{
    //-------------------------------------
    // MARK: Outlets
    //-------------------------------------

    
    @IBOutlet weak var lblSongDuration: UILabel!
    @IBOutlet weak var lblSongName: UILabel!
    @IBOutlet weak var seekSlider: UISlider!
    @IBOutlet weak var btnPlay: UIButton!
    @IBOutlet weak var ContainerVIew: UIView!
    
    //-------------------------------------
    // MARK: Identifiers
    //-------------------------------------
    
    var timer = Timer()
    var vc : UIViewController!
    
    //-------------------------------------
    // MARK: View Life Cycle
    //-------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
         vc = storyboard?.instantiateViewController(withIdentifier: "MenuVC") as! MenuVC
        self.addChildViewController(vc)
        vc.view.frame = CGRect.init(x: 0, y: 0, width: self.ContainerVIew.frame.size.width, height: self.ContainerVIew.frame.size.height)
        self.ContainerVIew.addSubview(vc.view)
        vc.didMove(toParentViewController: self)
        
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(Loader), userInfo: nil, repeats: true)
        timer.fire()
        NotificationCenter.default.addObserver(self, selector: #selector(ChangeVC), name: Notification.Name("VcChanged"), object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //-------------------------------------
    // MARK: User Defined Functions
    //-------------------------------------
    
    @objc func ChangeVC(_notification: Notification)
    {
        switch (_notification.userInfo!["Id"] as! String)
        {
        case "MenuVC":
            vc = storyboard?.instantiateViewController(withIdentifier: "MenuVC") as! MenuVC
        case "GenreVC":
            vc = storyboard?.instantiateViewController(withIdentifier: "GenreVC") as! GenreVC
        case "AlbumVC":
            vc = storyboard?.instantiateViewController(withIdentifier: "AlbumVC") as! AlbumVC
        case "GenreSongVC":
            vc = storyboard?.instantiateViewController(withIdentifier: "GenreSongVC") as! GenreSongVC
        case "PlaylistVC":
            vc = storyboard?.instantiateViewController(withIdentifier: "PlaylistVC") as! PlaylistVC
        case "EventsVC":
            vc = storyboard?.instantiateViewController(withIdentifier: "EventsVC") as! EventsVC
        case "VideoVC":
            vc = storyboard?.instantiateViewController(withIdentifier: "VideoVC") as! VideoVC
        case "VideoPlayVC":
            vc = storyboard?.instantiateViewController(withIdentifier: "VideoPlayVC") as! VideoPlayVC
        default:
            print("")
        }
        self.addChildViewController(vc)
        vc.view.frame = CGRect.init(x: 0, y: 0, width: self.ContainerVIew.frame.size.width, height: self.ContainerVIew.frame.size.height)
        self.ContainerVIew.addSubview(vc.view)
        vc.didMove(toParentViewController: self)
    }
    
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
            btnPlay.isSelected = true
        }
        else
        {
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

    //-------------------------------------
    // MARK: Button Actions
    //-------------------------------------

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
    
    //-------------------------------------
    // MARK: Web Services
    //-------------------------------------

}
