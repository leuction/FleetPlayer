//
//  HomeViewController.swift
//  FleetPlayer
//
//  Created by 硕 王 on 5/6/16.
//  Copyright © 2016 硕 王. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false

        // Do any additional setup after loading the view.
        
    }
    
    
    private var videoInformation = VideoInformation.travelsalAllFilesInDocument()

    @IBAction func showPath(sender: UIButton) {
        
        let manager = NSFileManager.defaultManager()
        let urlForDocument = manager.URLsForDirectory( .DocumentDirectory, inDomains:.UserDomainMask)
        let url = urlForDocument[0] as NSURL
        
        let contentsOfURL = try? manager.contentsOfDirectoryAtURL(url, includingPropertiesForKeys: nil, options: NSDirectoryEnumerationOptions.SkipsHiddenFiles);

        
        if let notEmptyContentsOfURL = contentsOfURL{
            for videoContentsOfURL in notEmptyContentsOfURL {
                if videoContentsOfURL.pathExtension! == "mp4" {
                    print(videoContentsOfURL.URLByDeletingPathExtension!.lastPathComponent!)
                }
            }
        }
        
    }
    
    //MARK: - UICollectionViewDelegate
    
    private struct Storyboard {
        static let cellReuseIdentifier = "VideoCell"
        static let showVideoPlayer = "ShowVideoPlayer"
    }

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return videoInformation.count
    }
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(Storyboard.cellReuseIdentifier, forIndexPath: indexPath) as! HomeCollectionViewCell
        cell.videoInformation = self.videoInformation[indexPath.item]
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        let newVideoInfomation = videoInformation[indexPath.item]
        performSegueWithIdentifier(Storyboard.showVideoPlayer, sender: newVideoInfomation)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var destination = segue.destinationViewController
        if let navCon = destination as? UINavigationController{
            destination = navCon.visibleViewController!
        }

        if let identifier = segue.identifier{
            if identifier == Storyboard.showVideoPlayer {
                if let vpvc = destination as? VideoPlayerViewController{
                    vpvc.isInternetVideoSource = false
                    vpvc.videoInformation = sender as? VideoInformation
                }
            }
        }
    }
    


}