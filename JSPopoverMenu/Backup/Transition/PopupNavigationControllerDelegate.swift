//
//  JSPopupNavigationControllerDelegate.swift
//  JSPopoverMenu
//
//  Created by 王俊硕 on 2017/11/3.
//  Copyright © 2017年 王俊硕. All rights reserved.
//

import UIKit

class PopoverTransitionDelegate: NSObject, UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return PopoverTransion()
    }
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return PopoverTransion()
    }
}

