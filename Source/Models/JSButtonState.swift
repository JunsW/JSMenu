//
//  JSButtonState.swift
//  JSPopoverMenu
//
//  Created by 王俊硕 on 2017/11/6.
//  Copyright © 2017年 王俊硕. All rights reserved.
//

import UIKit

public enum JSButtonState: String {
    case done = "Done"
    case reset = "Reset"
    case edit = "Edit"
    case group = "Tags"
    //TODO: 接受参数支持自定义颜色
    var textColor: UIColor { 
        switch self {
        case .group:
            return UIColor.from(hex: 0x939393)
        default:
            return UIColor.from(hex: 0xFD8B15)
        }
    }
    /// Apply localized string to the button
    func applyTo(_ button: UIButton) {
        if self == .edit || self == .done {
            button.contentHorizontalAlignment = .right
            button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 3)
        } else {
            button.contentHorizontalAlignment = .left
            button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 3, bottom: 0, right: 0)
        }
        button.setAttributedTitle(NSAttributedString(string: NSLocalizedString(self.rawValue, comment: "Localizable"), attributes: [NSAttributedStringKey.foregroundColor: textColor, NSAttributedStringKey.font: UIFont.systemFont(ofSize: 12)]), for: .normal)

    }
    
}

