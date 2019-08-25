//
//  JSTag.swift
//  JSPopoverMenu
//
//  Created by Junshuo on 2019/8/22.
//  Copyright © 2019 王俊硕. All rights reserved.
//

import UIKit

public protocol JSTag {
    var title: String { get set }
    var id: Int { get set }
}

open class JSDefaultTag: JSTag {
    
    public var title: String
    public var id: Int
    
    init(id: Int, title: String) {
        self.id = id
        self.title = title
    }
}
open class JSImageTag: JSDefaultTag {
    
    var image: UIImage?
    
    convenience init(id: Int, name: String) {
        self.init(id: id, image: UIImage(named: name))
    }
    init(id: Int, image: UIImage?) {
        self.image = image
        super.init(id: id, title: "")
    }
    static var addButton: JSImageTag {
        return JSImageTag(id: Int.max-2, image: JSMenuBundle.image(.add))
    }
    
    static var deleteButton: JSImageTag {
        return JSImageTag(id: Int.max-1, image: JSMenuBundle.image(.dustbin))
    }
}
public func ==(lhs: JSTag, rhs: JSTag) -> Bool {
    return lhs.id == rhs.id
}
