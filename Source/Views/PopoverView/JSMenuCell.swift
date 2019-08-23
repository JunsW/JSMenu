//
//  JSMenuCell.swift
//  JSPopoverMenu
//
//  Created by 王俊硕 on 2017/11/4.
//  Copyright © 2017年 王俊硕. All rights reserved.
//

import UIKit

open class JSMenuCell: UICollectionViewCell {
    var label: UILabel?
    var imageView: UIImageView?
    
    public func setup(title: String) {
        contentView.subviews.forEach() { $0.removeFromSuperview() }
        
        backgroundColor = .from(hex: 0xe6e6e6)
        layer.cornerRadius = 3
        
        label = UILabel(frame: bounds)
        label!.textAlignment = .center
        
        label!.attributedText = NSAttributedString(string: title, attributes: [NSAttributedStringKey.foregroundColor: UIColor.from(hex: 0x363636), NSAttributedStringKey.font: UIFont.systemFont(ofSize: 13)])
        contentView.addSubview(label!)
    }
    public func setupImage(image: UIImage?) {
        contentView.subviews.forEach() { $0.removeFromSuperview() }
        
        layer.cornerRadius = 3
        clipsToBounds = true

        imageView = UIImageView(image: image)
        imageView!.frame = bounds
        imageView!.contentMode = .scaleAspectFit
        contentView.addSubview(imageView!)
    }
    /// Turn cell style to moving. Called when the cell is draging.
    public func moving() {
        guard (label != nil) else { return }
        label!.textColor = .from(hex: 0xffffff)
        backgroundColor = .from(hex: 0xFD8B15) //Orange
    }
    /// Turn cell style to halt.
    public func halt() {
        guard (label != nil) else { return }
        label!.textColor = .from(hex: 0x363636) //Black
        backgroundColor = .from(hex: 0xe6e6e6) //Gray
    }
    /// Turn cell style to detain. Called when the cell is dragged to deleted area but not confirmed.
    public func detained() {
        guard (label != nil) else { return }
        label!.alpha = 0.3
    }
    /// Restore cell style to normal.
    public func discharged() {
        guard (label != nil) else { return }
        label!.alpha = 1
    }
}
