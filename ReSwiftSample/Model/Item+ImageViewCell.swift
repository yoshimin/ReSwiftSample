//
//  Item+ImageViewCell.swift
//  ReSwiftSample
//
//  Created by Shingai Yoshimi on 2018/02/17.
//  Copyright © 2018年 Shingai Yoshimi. All rights reserved.
//

import Foundation

extension Item: ImageViewCellModel {
    var imageUrl: URL? {
        return image.thumbnailLink
    }
    
    var labelText: String {
        return link
    }
}
