//
//  ImageViewCell.swift
//  ReSwiftSample
//
//  Created by Shingai Yoshimi on 2018/02/17.
//  Copyright © 2018年 Shingai Yoshimi. All rights reserved.
//

import UIKit
import SDWebImage

protocol ImageViewCellModel {
    var imageUrl: URL? { get }
    var labelText: String { get }
}

class ImageViewCell: UICollectionViewCell {
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var label: UILabel!
    
    func setup(with model: ImageViewCellModel) {
        if let url = model.imageUrl {
            imageView.sd_setImage(with: url)
        }
        label.text = model.labelText
    }
}
