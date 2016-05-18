//
//  MusicInformation.swift
//  FleetPlayer
//
//  Created by 硕 王 on 5/18/16.
//  Copyright © 2016 硕 王. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

class MusicInformation
{//the description of video
    
    
    var title = ""
    var featuredImage: UIImage!
    var url: NSURL!
    var artist: String?
    
    init(title: String, featuredImage: UIImage!, url: NSURL!, artist: String?)
    {
        self.title = title
        self.featuredImage = featuredImage
        self.url = url
        self.artist = artist
    }
    
    static func travelsalAllFilesInDocument() -> [MusicInformation]
    {
        var musicInformation: [MusicInformation] = []
        let manager = NSFileManager.defaultManager()
        let urlForDocument = manager.URLsForDirectory( .DocumentDirectory, inDomains:.UserDomainMask)
        let url = urlForDocument[0] as NSURL
        let contentsOfURL = try? manager.contentsOfDirectoryAtURL(url, includingPropertiesForKeys: nil, options: NSDirectoryEnumerationOptions.SkipsHiddenFiles);
        if let notEmptyContentsOfURL = contentsOfURL{
            for musicContentsOfURL in notEmptyContentsOfURL {
                if musicContentsOfURL.pathExtension! == "mp3" {
                    let newMusicInformation:MusicInformation
                    if let musicImage = albumImageWithMusicURL(musicContentsOfURL) {
                        if let musicArtist = artistWithMusicURL(musicContentsOfURL){
                            newMusicInformation = MusicInformation(title: musicContentsOfURL.URLByDeletingPathExtension!.lastPathComponent!, featuredImage: musicImage, url: musicContentsOfURL, artist: musicArtist)
                        }else {
                            newMusicInformation = MusicInformation(title: musicContentsOfURL.URLByDeletingPathExtension!.lastPathComponent!, featuredImage: musicImage, url: musicContentsOfURL, artist: nil)
                        }
                        
                    }else {
                        newMusicInformation = MusicInformation(title: musicContentsOfURL.URLByDeletingPathExtension!.lastPathComponent!, featuredImage: UIImage(named: "p1"), url: musicContentsOfURL, artist: nil)
                    }
                    musicInformation.append(newMusicInformation)
                }
            }
        }
        return musicInformation
    }
    
    static func albumImageWithMusicURL (url: NSURL) -> UIImage?{
        
        var audioImage: UIImage?
        
        let musicAsset: AVURLAsset = AVURLAsset(URL: url)
        for format in musicAsset.availableMetadataFormats {
            for metadataItem in musicAsset.metadataForFormat(format){
                if metadataItem.commonKey == AVMetadataCommonKeyArtwork {
                    audioImage =  UIImage(data: (metadataItem.value as? NSData)!)
                }
            }
        }
        return audioImage
    }
    
    static func artistWithMusicURL (url: NSURL) -> String?{
        
        var artist: String?
        
        let musicAsset: AVURLAsset = AVURLAsset(URL: url)
        for format in musicAsset.availableMetadataFormats {
            for metadataItem in musicAsset.metadataForFormat(format){
                if metadataItem.commonKey == AVMetadataCommonKeyArtist {
                    artist = metadataItem.value as? String
                }
            }
        }
        return artist
    }

    
    static func deleteFilesForURL(url: NSURL) -> Bool{
        let fileManager = NSFileManager.defaultManager()
        do{
            try fileManager.removeItemAtURL(url)
            return true
        }catch{
            return false
        }
    }
}