//
//  PMGestureHandler.swift
//  JSPopoverMenu
//
//  Created by 王俊硕 on 2017/11/5.
//  Copyright © 2017年 王俊硕. All rights reserved.
//

import UIKit

extension JSPopoverMenuView {
    @objc internal func gestureHandler(gesture: UIPanGestureRecognizer) {
        switch gesture.state {
        case .began: panBegan(gesture: gesture)
        case .changed: panChanged(gesture: gesture)
        case .ended: panEnded(gesture: gesture)
        default:
            break
        }
    }
    private func panBegan(gesture: UIPanGestureRecognizer)  {
        guard let selectedIndexPath = menuCollection.indexPathForItem(at: gesture.location(in: menuCollection)),
            (selectedIndexPath.row < deleteButtonIndex) else { return }
        selectedIndex = selectedIndexPath
        (menuCollection.cellForItem(at: selectedIndexPath) as! JSMenuCell).detained()

        let snapView = menuCollection.cellForItem(at: selectedIndexPath)!.snapshotView(afterScreenUpdates: false)
        animationCell = snapView
        animationCell!.isHidden = true
        menuCollection.addSubview(animationCell!)
    }
    private func panChanged(gesture: UIPanGestureRecognizer)  {
        guard let beginningIndex = selectedIndex else { return }
        // 1. 添加AnimationCell
        let point = gesture.location(in: menuCollection)
        animationCell?.center = point
        animationCell?.isHidden = false
        // 2. 获取当前坐标对应的cell
        guard let index = menuCollection.indexPathForItem(at: point) else { return }
//                print("Move at index: \(index), seletedIndex: \(selectedIndex), endingIndex: \(panEndingIndex)")
        // 3. 如果Cell.index是自身或者上一个交换的cell 则不执行 否则会一直交换
        guard index != selectedIndex, index != panEndingIndex ?? nil else { return }
        needDelete = false
        panEndingIndex = index
        // 4. 如果是添加按钮 或者 删除按钮 则不移动
        if index.row != deleteButtonIndex && index.row != addButtonIndex {

            // 交换Cell 交换之后 indexPath也会更新 所以数据原也要更新
            let tmp = dynamicData[beginningIndex.row]
            dynamicData[beginningIndex.row] = dynamicData[index.row]
            dynamicData[index.row] = tmp
            menuCollection.moveItem(at: beginningIndex, to: index)
            
            selectedIndex = index
        } else {
            // 标记为待删除
            needDelete = true
        }
    }
    private func panEnded(gesture: UIPanGestureRecognizer)  {
        guard animationCell != nil else { return }
        let cell = menuCollection.cellForItem(at: selectedIndex!) as! JSMenuCell
        
        if needDelete ?? false { // 首次拖动到空的地方为空
            // 添加撤销操作
            guard (menuCollection.cellForItem(at: selectedIndex!) != nil) else { return }
//            let button = cell.viewWithTag(100012) as! UIButton
//            button.isEnabled = true
            //
            // 移至队尾
            menuCollection.moveItem(at: selectedIndex!, to: IndexPath(row: dynamicData.count - 1, section: 0)) // 移动cell
            let tmp = dynamicData[selectedIndex!.row] // 移动数据源
            dynamicData.remove(at: selectedIndex!.row)
            dynamicData.append(tmp)
            deletedCells.append(dynamicData.count - 1) // 添加至待删除
//            (menuCollection.cellForItem(at: IndexPath(row:  dynamicData.count - 1, section: 0)) as! JSMenuCell).detained() // 每次新删除的项目肯定在最后
        } else { cell.discharged() }

        // 如果中间发生过一次交换， 那么selectedIndex记录的值还是原来的值， 但是实际对应的cell已经是交换过去的cell了
        // 重置参数
        needDelete = false
        
        UIView.animate(withDuration: 0.3) {
            self.animationCell?.center = (self.menuCollection.cellForItem(at: self.panEndingIndex ?? self.selectedIndex!)?.center)! //如果没有结束index说明没有交换过，那么久居中到起始cell
            self.animationCell?.removeFromSuperview()
            self.animationCell = nil
            self.selectedIndex = nil

            self.panEndingIndex = nil
            
        }
    }
}
