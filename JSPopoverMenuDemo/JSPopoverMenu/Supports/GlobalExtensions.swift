//
//  GlobalExtensions.swift
//  JSPopoverMenu
//
//  Created by 王俊硕 on 2017/11/4.
//  Copyright © 2017年 王俊硕. All rights reserved.
//

import UIKit

extension UIColor {
    class func from(hex: Int) -> UIColor {
        let r = (hex & 0xff0000) >> 16
        let g = (hex & 0x00ff00) >> 8
        let b = hex & 0x0000ff
        return UIColor(red: CGFloat(r)/255, green: CGFloat(g)/255, blue: CGFloat(b)/255, alpha: 1)
    }
}
extension IndexPath {
    static func ofRow(_ row: Int) -> IndexPath {
        return IndexPath(row: row, section: 0)
    }
}
extension CGRect {
    func scale(x: CGFloat ,y: CGFloat) -> CGRect {
        return CGRect(origin: origin, size: CGSize(width: width*x, height: height*y))
    }
    func move(x: CGFloat, y: CGFloat) -> CGRect {
        return CGRect(x: origin.x + x, y: origin.y + y, width: width, height: height)
    }
}
