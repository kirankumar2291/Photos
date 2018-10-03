//
//  AlbumsCollectionViewCell.swift
//  Photos
//
//  Created by Kiran kumar on 03/10/18.
//  Copyright © 2018 Kiran kumar. All rights reserved.
//

import UIKit

class AlbumsCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var labelAlbumCount: UILabel!
    @IBOutlet weak var labelAlbumTitle: UILabel!
    @IBOutlet weak var imageViewAlbumTile: UIImageView!
    @IBOutlet weak var viewBackground: UIView!
    
    override func awakeFromNib() {
        self.viewBackground.layer.cornerRadius = 5.0
        self.viewBackground.clipsToBounds = true
        self.imageViewAlbumTile.layer.borderColor = UIColor.lightGray.cgColor
        self.imageViewAlbumTile.layer.borderWidth = 0.5
    }
}
