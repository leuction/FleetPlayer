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
    var avPlayer = AVPlayer()
    var avPlayerLayer: AVPlayerLayer!
    var invisibleStartOrPauseButton = UIButton()
    var timeObserver: AnyObject!
    //var timeRemainingLabel: UILabel = UILabel()
    //var seekSlider: UISlider = UISlider()
    @IBOutlet weak var timePassedLabel: UILabel!
    @IBOutlet weak var seekSlider: UISlider!
    @IBOutlet weak var timeRemainingLabel: UILabel!
    var playerRateBeforeSeek: Float = 0
    var loadingIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.WhiteLarge)
    let playbackLikelyToKeepUpContext = UnsafeMutablePointer<(Void)>(nil)


    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.blackColor()
        
        // add the player layer
        
        avPlayerLayer = AVPlayerLayer(player: avPlayer)
        view.layer.insertSublayer(avPlayerLayer, atIndex: 0)
        
        
        // double tap the screen to start or pause
        
        view.addSubview(invisibleStartOrPauseButton)
        invisibleStartOrPauseButton.addTarget(self, action: #selector(VideoPlayerViewController.invisibleStartOrPauseButtonDoubleTapped(_:)), forControlEvents: UIControlEvents.TouchDownRepeat)
        
        //tap to show or hide the user interface
        invisibleStartOrPauseButton.addTarget(self, action: #selector(VideoPlayerViewController.hideTheUserInterface(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        
        //control the URL of the video source
        
        let url = NSURL(string: "http://images.apple.com/media/cn/ipad-pro/2016/8242d954_d694_42b8_b6b7_a871bba6ed54/films/feature/ipadpro-9-7inch-feature-cn-20160321_1280x720h.mp4");
        let playerItem = AVPlayerItem(URL: url!)
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
        invisibleStartOrPauseButton.frame = view.bounds
        
//        let controlsHeight: CGFloat = 30
//        let controlsY: CGFloat = view.bounds.size.height - controlsHeight;
//        timeRemainingLabel.frame = CGRect(x: 5, y: controlsY, width: 60, height: controlsHeight)
//        seekSlider.frame = CGRect(x: timeRemainingLabel.frame.origin.x + timeRemainingLabel.bounds.size.width,
//                                  y: controlsY, width: view.bounds.size.width - timeRemainingLabel.bounds.size.width - 5, height: controlsHeight)
        
        
        loadingIndicatorView.center = CGPoint(x: CGRectGetMidX(view.bounds), y: CGRectGetMidY(view.bounds))
    }
    
    // called when the screen is double tapped to start or pause the video
    
    func invisibleStartOrPauseButtonDoubleTapped(sender: UIButton!){
        let playerIsPlaying:Bool = avPlayer.rate > 0
        if(playerIsPlaying){
            avPlayer.pause()
        }else{
            avPlayer.play()
        }
    }
    
    // called when the screen is tapped to hide or show the user interface
    
    func hideTheUserInterface(sender: UIButton!){
        timeRemainingLabel.hidden = !timeRemainingLabel.hidden
        seekSlider.hidden = !seekSlider.hidden
    }
    
    private func updateTimeLabel(elapsedTime: Float64, duration: Float64) {
        let timeRemaining: Float64 = CMTimeGetSeconds(avPlayer.currentItem!.duration) - elapsedTime
        timeRemainingLabel.text = String(format: "%02d:%02d", ((lround(timeRemaining) / 60) % 60), lround(timeRemaining) % 60)
        timePassedLabel.text = String(format: "%02d:%02d", ((lround(elapsedTime) / 60) % 60), lround(elapsedTime) % 60)
    }
    
    private func observeTime(elapsedTime: CMTime) {
        let duration = CMTimeGetSeconds(avPlayer.currentItem!.duration);
        if (isfinite(duration)) {
            let elapsedTime = CMTimeGetSeconds(elapsedTime)
            updateTimeLabel(elapsedTime, duration: duration)
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
