//
//  JSButtonState.swift
//  JSPopoverMenu
//
//  Created by 王俊硕 on 2017/11/6.
//  Copyright © 2017年 王俊硕. All rights reserved.
//

import UIKit

enum JSButtonState: String {
    case done = "完成"
    case reset = "复原"
    case edit = "编辑"
    case group = "类别"
    //TODO: 接受参数支持自定义颜色
    var textColor: UIColor { 
        switch self {
        case .group:
            return UIColor.from(hex: 0x939393)
        default:
            return UIColor.from(hex: 0xFD8B15)
        }
    }
    func applyTo(_ button: UIButton) {
        
        button.setAttributedTitle(NSAttributedString(string: rawValue, attributes: [NSAttributedStringKey.foregroundColor: textColor, NSAttributedStringKey.font: UIFont.systemFont(ofSize: 12)]), for: .normal)

    }
}
