//
//  VideoInformation.swift
//  FleetPlayer
//
//  Created by 硕 王 on 5/6/16.
//  Copyright © 2016 硕 王. All rights reserved.
//

import Foundation
import UIKit

class VideoInformation
{//the description of video
    
    
    var title = ""
    var description = ""
    var featuredImage: UIImage!
    var url: NSURL!
    
    init(title: String, description :String, featuredImage: UIImage!, url: NSURL!)
    {
        self.title = title
        self.description = description
        self.featuredImage = featuredImage
        self.url = url
    }
    
    //MARK: - Test
//    static func createInformation() -> [VideoInformation]
//    {
//        return[
//            VideoInformation(title: "the first one", description: "yes we can", featuredImage: UIImage(named: "p1")),
//            VideoInformation(title: "the second one", description: "ass we can", featuredImage: UIImage(named: "p2"))
//        ]
//    }
    
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
                    let newVideoInformation = VideoInformation(title: videoContentsOfURL.URLByDeletingPathExtension!.lastPathComponent!, description: "test", featuredImage: UIImage(named: "p1"), url: videoContentsOfURL)
                    videoInformation.append(newVideoInformation)
                }
            }
        }
        
        for a in videoInformation {
            print(a.title)
        }
        
        return videoInformation
    }
    
    
//    func saveVideoFiles() {
//        let fileManager = NSFileManager()
//        if let docsDir = fileManager.URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first {
//            let unique = NSDate.timeIntervalSinceReferenceDate()
//            let url = docsDir.URLByAppendingPathComponent("\(unique).jpg")
//            if let path = url.absoluteString{
//                
//            }
//        }
//    }
    
    
}