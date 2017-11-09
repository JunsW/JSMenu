//
//  PMPresentation.swift
//  JSPopoverMenu
//
//  Created by 王俊硕 on 2017/11/5.
//  Copyright © 2017年 王俊硕. All rights reserved.
//

import UIKit

extension JSPopoverMenuView {
    
    public func show(completion closure: (()->Void)?) {
        if !isOnScreen {
            delegate.baseView.addSubview(removalResponder)
            delegate.baseView.addSubview(self)
            isOnScreen = true
            UIView.animate(withDuration: 0.3, animations: {
                self.frame = self.frame.move(x: 0, y: self.animationOffset) //navigationBar 不透明 无高度
            }) { (_) in
                closure?()
            }
        }
        
    }
    public func dismiss(completion closure: (()->Void)?) { // @escaping?
        if isOnScreen {
            isOnScreen = false
            UIView.animate(withDuration: 0.3, animations: {
                self.frame = self.frame.move(x: 0, y: -self.animationOffset)
            }, completion: { (_) in
                self.removeFromSuperview()
                self.removalResponder.removeFromSuperview()
                closure?()
                print(self.frame)
            })
        }
    }
    public func quickSwitch() {
        isOnScreen ? dismiss(completion: nil) : show(completion: nil)
    }
    @objc internal func offDuty() {
        dismiss(completion: nil)
    }
}
