//
//  JSHeaderButton.swift
//  JSPopoverMenu
//
//  Created by 王俊硕 on 2017/11/5.
//  Copyright © 2017年 王俊硕. All rights reserved.
//

import UIKit

class JSHeaderButton: UIButton {
    
    ///
    public var currentState: JSButtonState {
        get { return buttonState }
        set(state) {
            buttonState = state
            switchTo(state: state)
        }
    }
    
    private var buttonState: JSButtonState!
    private let textColor = UIColor.from(hex: 0x939393)
    private let hightTextColor = UIColor.from(hex: 0xFD8B15)
    
    init(originX x: CGFloat, state: JSButtonState) {
        super.init(frame: CGRect(x: x, y: 0, width: 30, height: 30))
        switchTo(state: state)
        titleLabel!.textAlignment = .left
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func switchTo(state: JSButtonState) {
        isEnabled = true
        buttonState = state
        switch state {
        case .done:
            setTitle("完成", withColor: hightTextColor)
        case .reset:
            setTitle("取消", withColor: hightTextColor)
        case .edit:
            setTitle("编辑", withColor: hightTextColor)
        case .group:
            setTitle("分类", withColor: textColor)
            isEnabled = false
//        default:
//            setTitle("出错", withColor: textColor)
        }
    }
    private func setTitle(_ title: String, withColor color: UIColor) {
        setAttributedTitle(NSAttributedString(string: title, attributes: [NSAttributedStringKey.foregroundColor: color, NSAttributedStringKey.font: UIFont.systemFont(ofSize: 12)]), for: .normal)
    }
    
    
    
}

