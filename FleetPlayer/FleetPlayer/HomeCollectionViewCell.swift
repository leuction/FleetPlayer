//
//  HomeCollectionViewCell.swift
//  FleetPlayer
//
//  Created by 硕 王 on 5/6/16.
//  Copyright © 2016 硕 王. All rights reserved.
//

import UIKit

class HomeCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var videoImage: UIImageView!
    @IBOutlet weak var videoTitle: UILabel!
    
    var videoInformation: VideoInformation!{
        didSet{
            updateUI()
        }
    }
    
    func updateUI(){
        videoImage.image! = videoInformation.featuredImage
        videoImage.contentMode = .ScaleAspectFill
        videoTitle.text! = videoInformation.title
    }
}
