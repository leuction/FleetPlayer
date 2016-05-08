//
//  HomeViewController.swift
//  FleetPlayer
//
//  Created by 硕 王 on 5/6/16.
//  Copyright © 2016 硕 王. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    
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
        //假设用户文档下有如下文件和文件夹[test1.txt,fold1/test2.txt]
        let manager = NSFileManager.defaultManager()
        let urlForDocument = manager.URLsForDirectory( .DocumentDirectory, inDomains:.UserDomainMask)
        let url = urlForDocument[0] as NSURL
        
        //（1）对指定路径执行浅搜索，返回指定目录路径下的文件、子目录及符号链接的列表
        let contentsOfPath = try? manager.contentsOfDirectoryAtPath(url.path!)
        //contentsOfPath：Optional([fold1, test1.txt])
        //print("contentsOfPath: \(contentsOfPath)")
        
        //（2）类似上面的，对指定路径执行浅搜索，返回指定目录路径下的文件、子目录及符号链接的列表
        let contentsOfURL = try? manager.contentsOfDirectoryAtURL(url, includingPropertiesForKeys: nil, options: NSDirectoryEnumerationOptions.SkipsHiddenFiles);
        //contentsOfURL：Optional([file://Users/.../Application/.../Documents/fold1/,
        // file://Users/.../Application/.../Documents/test1.txt])
        //print("contentsOfURL: \(contentsOfURL)")
        
        if let notEmptyContentsOfURL = contentsOfURL{
            for videoContentsOfURL in notEmptyContentsOfURL {
                if videoContentsOfURL.pathExtension! == "mp4" {
                    print(videoContentsOfURL.URLByDeletingPathExtension!.lastPathComponent!)
                }
            }
        }
        
    }
}


extension HomeViewController: UICollectionViewDataSource{
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return videoInformation.count
    }
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    //it will crash when the videoInformaion is nil
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("VideoCell", forIndexPath: indexPath) as! HomeCollectionViewCell
        cell.videoInformation = self.videoInformation[indexPath.item]
        return cell
    }
}