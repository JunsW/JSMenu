//
//  JSTag.swift
//  JSPopoverMenu
//
//  Created by Junshuo on 2019/8/22.
//  Copyright © 2019 王俊硕. All rights reserved.
//

import UIKit

protocol JSTag {
    var title: String { get set }
    var id: Int { get set }
}

class JSDefaultTag: JSTag {
    
    var title: String
    var id: Int
    
    init(id: Int, title: String) {
        self.id = id
        self.title = title
    }
}
class JSImageTag: JSDefaultTag {
    
    var image: UIImage?
    
    init(id: Int, image name: String) {
        image = UIImage(named: name)
        super.init(id: id, title: "")
    }
    
    static var addButton: JSImageTag {
        return JSImageTag(id: Int.max-2, image: "cross")
    }
    
    static var deleteButton: JSImageTag {
        return JSImageTag(id: Int.max-1, image: "dustbin")
    }
}
func ==(lhs: JSTag, rhs: JSTag) -> Bool {
    return lhs.id == rhs.id
}
