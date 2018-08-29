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
    
    //Review: делегаты должны быть по слабым ссылкам
    /* weak */ var delegate: ImageViewCellDelegate? = nil
    
    @IBAction func removeImage(_ sender: Any) {
        //Review: Проверка на nil не нужна
        if( delegate != nil ) {
            delegate?.removePhoto(index: index)
        }
    }
    
    //Review: Методы подразумевающие действий называть нужно глаголами - hide()
    func hidden() {
    }
    
    func show() {
    }
}
protocol ImageViewCellDelegate {
    func removePhoto(index: NSInteger)

}
