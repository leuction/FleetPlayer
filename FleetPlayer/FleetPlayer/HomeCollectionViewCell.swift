//
//  HomeCollectionViewCell.swift
//  FleetPlayer
//
//  Created by 硕 王 on 5/6/16.
//  Copyright © 2016 硕 王. All rights reserved.
//

import UIKit

class HomeCollectionViewCell: UICollectionViewCell {
    
    let imageWidth: CGFloat = 260
    
    @IBOutlet weak var videoImage: UIImageView!
    @IBOutlet weak var videoTitle: UILabel!
    @IBOutlet weak var deleteButton: UIButton!
    
    var isEditable:Bool! {
        didSet {
            if isEditable!{
                deleteButton.hidden = false
            } else {
                deleteButton.hidden = true
            }
        }
    }
    
    var videoInformation: VideoInformation!{
        didSet {
            videoImage.image! = videoInformation.featuredImage
            videoImage.contentMode = .ScaleAspectFill
            videoTitle.text! = videoInformation.title
        }
    }
 
}
