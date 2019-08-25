//
//  JSMenuBundle.swift
//  JSMenuExample
//
//  Created by Junshuo on 2019/8/25.
//  Copyright © 2019 王俊硕. All rights reserved.
//

import UIKit

class JSMenuBundle {
    enum Icon {
        case add
        case dustbin
        
        var name: String {
            return "ICON_\(self)".uppercased()
        }
    }
    
    static func image(_ icon: Icon) -> UIImage {
        let bundle = Foundation.Bundle(for: JSMenuBundle.self)
        return UIImage(named: "JSMenu.bundle/\(icon.name)", in: bundle, compatibleWith: nil)!
    }
}
