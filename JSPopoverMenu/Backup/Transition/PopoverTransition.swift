//
//  PopoverTransition.swift
//  JSPopoverMenu
//
//  Created by 王俊硕 on 2017/11/3.
//  Copyright © 2017年 王俊硕. All rights reserved.
//

import UIKit

class PopoverTransion: NSObject, UIViewControllerAnimatedTransitioning {
    var duration = 0.5
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration // 动画时长
    }
    func animationEnded(_ transitionCompleted: Bool) {
        print("Done")
    }
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let toViewController = transitionContext.viewController(forKey: .to) as! PopoverViewController
        let fromViewController = transitionContext.viewController(forKey: .from) as! UINavigationController
        let toView = toViewController.view!
        let fromView = fromViewController.view!
        
        let container = transitionContext.containerView
        toView.frame = toView.frame.scale(x: 1, y: 0.33).move(x: 0, y: -200)
        
        let mask = maskView(frame: fromView.frame)
        mask.addGestureRecognizer(UITapGestureRecognizer(target: toViewController, action: #selector(toViewController.dismiss(animated:completion:))))

        container.addSubview(mask)
        container.addSubview(toView)
        print(fromView.description)
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
//            mask?.alpha = 0
            toView.frame = toView.frame.move(x: 0, y: 200+64)
        }) { (_) in
//            mask?.removeFromSuperview()
            transitionContext.completeTransition(true)


        
        }
        
    }
    func maskView(frame: CGRect) -> UIView {
        let view = UIView(frame: frame)
        view.backgroundColor =  .black
        view.alpha = 0
        view.tag = 10001
        return view
    }
}
    



extension CGRect {
        func scale(x: CGFloat ,y: CGFloat) -> CGRect {
            return CGRect(origin: origin, size: CGSize(width: width*x, height: height*y))
        }
        func move(x: CGFloat, y: CGFloat) -> CGRect {
            return CGRect(x: origin.x + x, y: origin.y + y, width: width, height: height)
        }
}
