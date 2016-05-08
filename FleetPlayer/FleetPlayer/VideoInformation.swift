//
//  VideoInformation.swift
//  FleetPlayer
//
//  Created by 硕 王 on 5/6/16.
//  Copyright © 2016 硕 王. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

class VideoInformation
{//the description of video
    
    
    var title = ""
    var featuredImage: UIImage!
    var url: NSURL!
    
    init(title: String, featuredImage: UIImage!, url: NSURL!)
    {
        self.title = title
        self.featuredImage = featuredImage
        self.url = url
    }
    
    static func travelsalAllFilesInDocument() -> [VideoInformation]
    {
        var videoInformation: [VideoInformation] = []
        let manager = NSFileManager.defaultManager()
        let urlForDocument = manager.URLsForDirectory( .DocumentDirectory, inDomains:.UserDomainMask)
        let url = urlForDocument[0] as NSURL
        let contentsOfURL = try? manager.contentsOfDirectoryAtURL(url, includingPropertiesForKeys: nil, options: NSDirectoryEnumerationOptions.SkipsHiddenFiles);
        if let notEmptyContentsOfURL = contentsOfURL{
            for videoContentsOfURL in notEmptyContentsOfURL {
                if videoContentsOfURL.pathExtension! == "mp4" {
                    
                    
                    let newVideoInformation = VideoInformation(title: videoContentsOfURL.URLByDeletingPathExtension!.lastPathComponent!, featuredImage: thumbnailOfVideoForURL(videoContentsOfURL)!, url: videoContentsOfURL)
                    videoInformation.append(newVideoInformation)
                }
            }
        }
        return videoInformation
    }
    
    static func thumbnailOfVideoForURL(url: NSURL) -> UIImage?{
        let asset = AVAsset(URL: url)
        let assetImgGenerate = AVAssetImageGenerator(asset: asset)
        assetImgGenerate.appliesPreferredTrackTransform = true
        let time = CMTimeMake(asset.duration.value / 3, asset.duration.timescale)
        if let cgImage = try? assetImgGenerate.copyCGImageAtTime(time, actualTime: nil) {
            return UIImage(CGImage: cgImage)
        }else{
            return nil
        }
    }

    
}