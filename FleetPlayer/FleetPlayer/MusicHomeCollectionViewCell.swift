//
//  MusicHomeCollectionViewCell.swift
//  FleetPlayer
//
//  Created by 硕 王 on 5/18/16.
//  Copyright © 2016 硕 王. All rights reserved.
//

import UIKit

class MusicHomeCollectionViewCell: UICollectionViewCell {
    let imageWidth: CGFloat = 260
    
    @IBOutlet weak var musicImage: UIImageView!

    @IBOutlet weak var deleteButton: UIButton!
    
    @IBOutlet weak var musicTitle: UILabel!
    
    @IBOutlet weak var musicArtist: UILabel!
    
    var isEditable:Bool! {
        didSet {
            if (isEditable!){
                deleteButton.hidden = false
            } else {
                deleteButton.hidden = true
            }
        }
    }

    
//    var isEditable:Bool = false {
//        didSet {
//            updateUI()
//        }
//    }
    var musicInformation: MusicInformation!{
        didSet {
            musicImage.image! = musicInformation.featuredImage
            musicImage.contentMode = .ScaleAspectFill
            musicTitle.text! = musicInformation.title
            if let musicArtist = musicInformation.artist{
                self.musicArtist.text! = musicArtist
            }
        }
    }
//    func updateUI(){
//        
//        
//
//    }
}
