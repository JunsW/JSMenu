//
//  PopoverViewDelegate.swift
//  JSPopoverMenu
//
//  Created by 王俊硕 on 2017/11/5.
//  Copyright © 2017年 王俊硕. All rights reserved.
//

import UIKit

public protocol JSPopoverMenuViewDelegate: NSObjectProtocol {
    var baseView: UIView { get }
    func popoverMenu(_ popoverMenu: JSPopoverMenuView, didSelectedAt indexPath: IndexPath)
    func popoverMenu(_ popoverMenu: JSPopoverMenuView, updatedData data: [JSTag])
    func popoverMenu(_ popoverMenu: JSPopoverMenuView, newTag value: JSTag) 
}
