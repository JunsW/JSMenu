//
//  MVPopoverDelegate.swift
//  JSPopoverMenu
//
//  Created by 王俊硕 on 2017/11/5.
//  Copyright © 2017年 王俊硕. All rights reserved.
//

import UIKit

extension MainViewController: JSPopoverMenuViewDelegate {
    var baseView: UIView { return self.view }
    

    func popoverMenu(_ popoverMenu: PopoverMenuView, didSelectedAt indexPath: IndexPath) {
        print("Don't mess up with me: \(indexPath)")
    }
    func popoverMenu(_ popoverMenu: PopoverMenuView, updatedData data: [String]) {
        displayerLabel.text = reduceArray(data)
    }
}
