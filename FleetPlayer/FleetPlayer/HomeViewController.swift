//
//  HomeViewController.swift
//  FleetPlayer
//
//  Created by 硕 王 on 5/6/16.
//  Copyright © 2016 硕 王. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UIGestureRecognizerDelegate {
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.barTintColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        navigationController?.navigationBar.translucent = true
        navigationController?.navigationBar.barStyle = UIBarStyle.BlackTranslucent
        
        
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(HomeViewController.editVideoFiles(_:)))
        longPress.minimumPressDuration = 0.5
        longPress.allowableMovement = 15
        longPress.numberOfTouchesRequired = 1
        self.collectionView.addGestureRecognizer(longPress)
        
        let cancelEditable = UITapGestureRecognizer(target: self, action: #selector(HomeViewController.cancelEditVideoFiles(_:)))
        self.view.addGestureRecognizer(cancelEditable)
        cancelEditable.delegate = self
        
        
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false

        // Do any additional setup after loading the view.
        
        // prevent the collection view be blocked by th navigation bar
        self.edgesForExtendedLayout = UIRectEdge.None
        self.automaticallyAdjustsScrollViewInsets = false
    }

    private var videoInformation = VideoInformation.travelsalAllFilesInDocument()
    //private var videoInformation = [VideoInformation(title: "1", featuredImage: UIImage(named: "p2"), url: NSURL(fileURLWithPath: "123"))]
    
    func editVideoFiles(sender: UILongPressGestureRecognizer) {
        if sender.state == UIGestureRecognizerState.Began{
//            let p:CGPoint = sender.locationInView(self.collectionView)
//            let index: NSIndexPath = self.collectionView.indexPathForItemAtPoint(p)!
//            if let cell = self.collectionView.cellForItemAtIndexPath(index) as? HomeCollectionViewCell {
//                cell.isEditable = true
//            }
//            print("long press")
            
            for cell in (self.collectionView.visibleCells() as? [HomeCollectionViewCell])!{
                
                cell.isEditable = true
            
            }
        }
    }
    
    func cancelEditVideoFiles(sender: UITapGestureRecognizer) {
        for cell in (self.collectionView.visibleCells() as? [HomeCollectionViewCell])! {
            if cell.isEditable {
                cell.isEditable = false
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
        cell.isEditable = false
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        let newVideoInfomation = videoInformation[indexPath.item]
        performSegueWithIdentifier(Storyboard.showVideoPlayer, sender: newVideoInfomation)
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
                let success = VideoInformation.deleteFilesForURL(self.videoInformation[indexPath.item].url)
                if success {
                    self.videoInformation = VideoInformation.travelsalAllFilesInDocument()
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
        let p: CGPoint =  touch.locationInView(self.view)
        for cell in self.collectionView.visibleCells(){
            if CGRectContainsPoint(cell.frame, p) {
                return false
            }
        }
        return true
    }
}

//check out the error in AutoLayout

extension NSLayoutConstraint {
    
    override public var description: String {
        let id = identifier ?? ""
        return "id: \(id), constant: \(constant)" //you may print whatever you want here
    }
}