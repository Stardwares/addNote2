//
//  ImageViewCell.swift
//  nodeProject
//
//  Created by Вадим Пустовойтов on 13.08.2018.
//  Copyright © 2018 Вадим Пустовойтов. All rights reserved.
//

import UIKit

class ImageViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    
    var index: NSInteger = 0
    var delegate: ImageViewCellDelegate? = nil
    
    @IBAction func removeImage(_ sender: Any) {
        if( delegate != nil ) {
            delegate?.removePhoto(index: index)
        }
    }
}
protocol ImageViewCellDelegate {
    func removePhoto(index: NSInteger)

}
