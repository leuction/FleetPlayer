//
//  MusicHomeViewController.swift
//  FleetPlayer
//
//  Created by 硕 王 on 5/18/16.
//  Copyright © 2016 硕 王. All rights reserved.
//

import UIKit
import MMDrawerController
import AVFoundation

class MusicHomeViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UIGestureRecognizerDelegate {
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var seekSlider: UISlider!
    @IBOutlet weak var playControlButton: UIButton!
    var isMusicCellEditable: Bool!
    var musicPlayer = AVPlayer()
    var playerItem: AVPlayerItem!
    var isMusicLoaded: Bool!
    var timeObserver: AnyObject!
    var playerRateBeforeSeek: Float = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        isMusicCellEditable = false
        isMusicLoaded = false
        
        navigationController?.navigationBar.barTintColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        navigationController?.navigationBar.translucent = true
        navigationController?.navigationBar.barStyle = UIBarStyle.BlackTranslucent
        
        
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(MusicHomeViewController.editVideoFiles(_:)))
        longPress.minimumPressDuration = 0.5
        longPress.allowableMovement = 15
        longPress.numberOfTouchesRequired = 1
        self.collectionView.addGestureRecognizer(longPress)
        
        let cancelEditable = UITapGestureRecognizer(target: self, action: #selector(MusicHomeViewController.cancelEditVideoFiles(_:)))
        self.view.addGestureRecognizer(cancelEditable)
        cancelEditable.delegate = self
        
        
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        
        // Do any additional setup after loading the view.
        
        // prevent the collection view be blocked by th navigation bar
        self.edgesForExtendedLayout = UIRectEdge.None
        self.automaticallyAdjustsScrollViewInsets = false
        
        let timeInterval: CMTime = CMTimeMakeWithSeconds(1.0, 10)
        timeObserver = musicPlayer.addPeriodicTimeObserverForInterval(timeInterval, queue: dispatch_get_main_queue(), usingBlock: { (elapsedTime) in
            self.observeTime(elapsedTime)
        })
        
    }
    
    private func observeTime(elapsedTime: CMTime) {
        let duration = CMTimeGetSeconds(musicPlayer.currentItem!.duration);
        if (isfinite(duration)) {
            let elapsedTime = CMTimeGetSeconds(elapsedTime)
            updateSeekSlider(elapsedTime, duration: duration)
        }
    }
    private func updateSeekSlider(elapsedTime: Float64, duration: Float64) {
        let timeDuration: Float64 = CMTimeGetSeconds(musicPlayer.currentItem!.duration)
        seekSlider.setValue(Float(elapsedTime / timeDuration), animated: true)
    }
    
    @IBAction func sliderBeganTracking(sender: UISlider) {
        playerRateBeforeSeek = musicPlayer.rate
        musicPlayer.pause()
        playControlButton.setImage(UIImage(named: "Media-Play-256"), forState: UIControlState.Normal)
    }
    
    @IBAction func sliderEndedTracking(sender: UISlider) {
        let videoDuration = CMTimeGetSeconds(musicPlayer.currentItem!.duration)
        let elapsedTime: Float64 = videoDuration * Float64(seekSlider.value)
        
        musicPlayer.seekToTime(CMTimeMakeWithSeconds(elapsedTime, 10)) { (completed: Bool) -> Void in
            if (self.playerRateBeforeSeek > 0) {
                self.musicPlayer.play()
                self.playControlButton.setImage(UIImage(named: "Media-Pause-256"), forState: UIControlState.Normal)
            }
        }
    }
    
    
    
    private var musicInformation = MusicInformation.travelsalAllFilesInDocument()
    

    
    func editVideoFiles(sender: UILongPressGestureRecognizer) {
        if sender.state == UIGestureRecognizerState.Began{
            for cell in (self.collectionView.visibleCells() as? [MusicHomeCollectionViewCell])!{
                
                isMusicCellEditable = true
                cell.isEditable = isMusicCellEditable
                
            }
        }
    }
    
    func cancelEditVideoFiles(sender: UITapGestureRecognizer) {
        for cell in (self.collectionView.visibleCells() as? [MusicHomeCollectionViewCell])! {
            if cell.isEditable! {
                isMusicCellEditable = false
                cell.isEditable = isMusicCellEditable
            }
        }
    }
    
    @IBAction func leftSideButtonTapped(sender: UIBarButtonItem) {
        
        let appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.centerContainer?.toggleDrawerSide(MMDrawerSide.Left, animated: true, completion: nil)
    }
    
    @IBAction func playOrPauseButtonTapped(sender: UIButton) {
        
        
        if isMusicLoaded! {
            let playerIsPlayering: Bool = musicPlayer.rate > 0
            if playerIsPlayering{
                musicPlayer.pause()
                sender.setImage(UIImage(named: "Media-Play-256"), forState: UIControlState.Normal)
            }else {
                musicPlayer.play()
                sender.setImage(UIImage(named: "Media-Pause-256"), forState: UIControlState.Normal)
            }
        }
    }
    
    
    //MARK: - UICollectionViewDelegate
    
    private struct Storyboard {
        static let cellReuseIdentifier = "MusicCell"
        static let showVideoPlayer = "ShowVideoPlayer"
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return musicInformation.count
    }
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(Storyboard.cellReuseIdentifier, forIndexPath: indexPath) as! MusicHomeCollectionViewCell
        cell.isEditable = isMusicCellEditable
        cell.musicInformation = self.musicInformation[indexPath.item]
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        
        
        let newMusicInfomation = musicInformation[indexPath.item]
        
        playerItem = AVPlayerItem(URL: newMusicInfomation.url)
        isMusicLoaded = true
        musicPlayer.replaceCurrentItemWithPlayerItem(playerItem)
        print("播放")
        musicPlayer.play()
        playControlButton.setImage(UIImage(named: "Media-Pause-256"), forState: UIControlState.Normal)
        
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let identifier = segue.identifier{
            if identifier == Storyboard.showVideoPlayer {
                let destination = segue.destinationViewController
                if let vpvc = destination as? VideoPlayerViewController{
                    vpvc.isInternetVideoSource = false
                    vpvc.videoInformation = sender as? VideoInformation
                }
            }
        }
    }
    @IBAction func deleteItems(sender: UIButton) {
        let alertController = UIAlertController(title: "Are you sure?", message: "delete file", preferredStyle: UIAlertControllerStyle.Alert)
        let cancelAction = UIAlertAction(title: "cancel", style: UIAlertActionStyle.Cancel, handler: nil)
        let okAction = UIAlertAction(title: "confirm", style: UIAlertActionStyle.Destructive) { (action) in
            let p = sender.convertRect(sender.bounds, toView: self.collectionView)
            print(p)
            if let indexPath = self.collectionView.indexPathForItemAtPoint(p.origin){
                let success = VideoInformation.deleteFilesForURL(self.musicInformation[indexPath.item].url)
                if success {
                    self.musicInformation = MusicInformation.travelsalAllFilesInDocument()
                    self.collectionView.reloadData()
                }else {
                    let errorAlert = UIAlertController(title: "Deletion Failed", message: nil, preferredStyle: UIAlertControllerStyle.Alert)
                    let confirmAction = UIAlertAction(title: "confirm", style: UIAlertActionStyle.Default, handler: nil)
                    errorAlert.addAction(confirmAction)
                    self.presentViewController(errorAlert, animated: true, completion: nil)
                }
            }
        }
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldReceiveTouch touch: UITouch) -> Bool {
        if let touchView = touch.view{
            if touchView.isDescendantOfView(self.collectionView){
                return false
            }
        }
        return true
    }
}
