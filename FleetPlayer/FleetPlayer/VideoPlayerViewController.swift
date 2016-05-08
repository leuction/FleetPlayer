//
//  ViewController.swift
//  FleetPlayer
//
//  Created by 硕 王 on 4/25/16.
//  Copyright © 2016 硕 王. All rights reserved.
//

import UIKit
import AVFoundation

class VideoPlayerViewController: UIViewController {
    var isInternetVideoSource = false
    var playerItem: AVPlayerItem!
    var avPlayer = AVPlayer()
    var avPlayerLayer: AVPlayerLayer!
    var timeObserver: AnyObject!
    @IBOutlet weak var timePassedLabel: UILabel!
    @IBOutlet weak var seekSlider: UISlider!
    @IBOutlet weak var timeRemainingLabel: UILabel!
    var playerRateBeforeSeek: Float = 0
    var loadingIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.WhiteLarge)
    let playbackLikelyToKeepUpContext = UnsafeMutablePointer<(Void)>(nil)

    override func prefersStatusBarHidden() -> Bool {
        return true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // add the player layer
        
        avPlayerLayer = AVPlayerLayer(player: avPlayer)
        view.layer.insertSublayer(avPlayerLayer, atIndex: 0)
        
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(VideoPlayerViewController.startOrPauseTheVideo(_:)))
        doubleTap.numberOfTapsRequired = 2
        self.view.addGestureRecognizer(doubleTap)
        
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(VideoPlayerViewController.hideOrShowUserInterface(_:)))
        self.view.addGestureRecognizer(singleTap)
        singleTap.requireGestureRecognizerToFail(doubleTap)
        
        
        //control the URL of the video source
        
        if isInternetVideoSource
        {
            let url = NSURL(string: "http://images.apple.com/media/cn/ipad-pro/2016/8242d954_d694_42b8_b6b7_a871bba6ed54/films/feature/ipadpro-9-7inch-feature-cn-20160321_1280x720h.mp4");
            playerItem = AVPlayerItem(URL: url!)
        }else{
            let fileManager = NSFileManager.defaultManager()
            if let docsDir = fileManager.URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first {
                let url = docsDir.URLByAppendingPathComponent("video.mp4")
                playerItem = AVPlayerItem(URL: url)
            }
        }
        
        avPlayer.replaceCurrentItemWithPlayerItem(playerItem)
        
        //obverse the time of the player
        let timeInterval: CMTime = CMTimeMakeWithSeconds(1.0, 10)
        timeObserver = avPlayer.addPeriodicTimeObserverForInterval(timeInterval,
                                                                   queue: dispatch_get_main_queue()) { (elapsedTime: CMTime)-> Void in
                                                                    self.observeTime(elapsedTime)
        }
        loadingIndicatorView.hidesWhenStopped = true
        view.addSubview(loadingIndicatorView)
        avPlayer.addObserver(self, forKeyPath: "currentItem.playbackLikelyToKeepUp",
                             options: NSKeyValueObservingOptions.New, context: playbackLikelyToKeepUpContext)
    }
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if (context == playbackLikelyToKeepUpContext) {
            if (avPlayer.currentItem!.playbackLikelyToKeepUp) {
                loadingIndicatorView.stopAnimating()
            } else {
                loadingIndicatorView.startAnimating()
            }
        }
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        loadingIndicatorView.startAnimating()
        avPlayer.play() // Start the playback
    }
    
    //control the frame of the player and other controller
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        // Layout subviews manually
        avPlayerLayer.frame = view.bounds
        loadingIndicatorView.center = CGPoint(x: CGRectGetMidX(view.bounds), y: CGRectGetMidY(view.bounds))
    }
    

    
    //double tap the view to start or pause the video
    
    func startOrPauseTheVideo(sender: UITapGestureRecognizer){
        let playerIsPlaying:Bool = avPlayer.rate > 0
        if(playerIsPlaying){
            avPlayer.pause()
        }else{
            avPlayer.play()
        }
        
    }
    
    //single tap to hide or show the user interface
    
    func hideOrShowUserInterface(sender: UITapGestureRecognizer){
        timeRemainingLabel.hidden = !timeRemainingLabel.hidden
        seekSlider.hidden = !seekSlider.hidden
        timePassedLabel.hidden = !timePassedLabel.hidden
    }
    
    private func updateTimeLabel(elapsedTime: Float64, duration: Float64) {
        let timeRemaining: Float64 = CMTimeGetSeconds(avPlayer.currentItem!.duration) - elapsedTime
        timeRemainingLabel.text = String(format: "%02d:%02d", ((lround(timeRemaining) / 60) % 60), lround(timeRemaining) % 60)
        timePassedLabel.text = String(format: "%02d:%02d", ((lround(elapsedTime) / 60) % 60), lround(elapsedTime) % 60)
    }
    
    private func updateSeekSlider(elapsedTime: Float64, duration: Float64) {
        let timeDuration: Float64 = CMTimeGetSeconds(avPlayer.currentItem!.duration)
        seekSlider.setValue(Float(elapsedTime / timeDuration), animated: true)
    }
    
    private func observeTime(elapsedTime: CMTime) {
        let duration = CMTimeGetSeconds(avPlayer.currentItem!.duration);
        if (isfinite(duration)) {
            let elapsedTime = CMTimeGetSeconds(elapsedTime)
            updateTimeLabel(elapsedTime, duration: duration)
            updateSeekSlider(elapsedTime, duration: duration)
        }
    }
    
    @IBAction func sliderBeganTracking(sender: UISlider) {
        playerRateBeforeSeek = avPlayer.rate
        avPlayer.pause()
    }
    
    @IBAction func sliderEndedTracking(sender: UISlider) {
        let videoDuration = CMTimeGetSeconds(avPlayer.currentItem!.duration)
        let elapsedTime: Float64 = videoDuration * Float64(seekSlider.value)
        updateTimeLabel(elapsedTime, duration: videoDuration)
        
        avPlayer.seekToTime(CMTimeMakeWithSeconds(elapsedTime, 10)) { (completed: Bool) -> Void in
            if (self.playerRateBeforeSeek > 0) {
                self.avPlayer.play()
            }
        }
    }
    
    @IBAction func sliderValueChanged(sender: UISlider) {
        let videoDuration = CMTimeGetSeconds(avPlayer.currentItem!.duration)
        let elapsedTime: Float64 = videoDuration * Float64(seekSlider.value)
        updateTimeLabel(elapsedTime, duration: videoDuration)
    }
    
    
    deinit {
        avPlayer.removeTimeObserver(timeObserver)
        avPlayer.removeObserver(self, forKeyPath: "currentItem.playbackLikelyToKeepUp")
    }


}

