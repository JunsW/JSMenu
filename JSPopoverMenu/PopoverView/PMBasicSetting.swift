//
//  PopoverMenuViewSetting.swift
//  JSPopoverMenu
//
//  Created by 王俊硕 on 2017/11/4.
//  Copyright © 2017年 王俊硕. All rights reserved.
//

import UIKit

extension PopoverMenuView {
    
    internal func setupResponder() {
        removalResponder = UIControl(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: UIScreen.main.bounds.size))
        removalResponder.addTarget(self, action: #selector(offDuty), for: .allEvents)
    }
    
    internal func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.headerReferenceSize = CGSize(width: 0, height: 0)
        layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        menuCollection = UICollectionView(frame: CGRect(x: 0, y: 35, width: screenWidth, height: 150)
            , collectionViewLayout: layout)
        menuCollection.register(JSMenuCell.self, forCellWithReuseIdentifier: "Cell")
        menuCollection.backgroundColor = baseColor
        menuCollection.delegate = self
        menuCollection.dataSource = self
        menuCollection.tag = 10011
    }
    /// 返回 顶部视图 可以重写
    open func setupHeaderView() {
        headerView = UIView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 30))
        headerView.tag = 10015
        headerView.backgroundColor = baseColor
        
        // 类别/取消 按钮
        let leftButton = JSHeaderButton(originX: 10, state: JSButtonState.group)
        leftButton.addTarget(self, action: #selector(self.leftHeaderButtonTapped), for: .touchUpInside)
        leftButton.tag = 10012
        // 编辑 按钮
        let rightButton = JSHeaderButton(originX: screenWidth-40, state: JSButtonState.edit)
        rightButton.addTarget(self, action: #selector(self.rightHeaderButtonTapped), for: .touchUpInside)
        rightButton.tag = 10013


        headerView.addSubview(leftButton)
        headerView.addSubview(rightButton)
    }
    
    @objc func leftHeaderButtonTapped(sender leftButton: JSHeaderButton) {
        print("Left Button Tapped")
        if leftButton.currentState == JSButtonState.reset {
            resetMenu(forEdting: true)
        }
    }
    @objc func rightHeaderButtonTapped(sender rightButton: JSHeaderButton) {
        print("Mayday! Mayday! It's the right button of the header")
        
        let leftButton = headerView.viewWithTag(10012) as! JSHeaderButton
        if rightButton.currentState == JSButtonState.done {// 退出编辑
            rightButton.switchTo(state: .edit)
            leftButton.switchTo(state: .group)
            finishEditing() // 完成编辑 保存
        } else { // 进入编辑
            rightButton.switchTo(state: .done)
            leftButton.switchTo(state: .reset)
//            menuCollection.allowsSelection = false
            startEditing() // 开始编辑
        }
    }
    private func swiftLeftButton(_ button: UIButton) {
        if button.isEnabled {
            button.isEnabled = false
            button.setAttributedTitle(NSAttributedString(string: "类别", attributes: [NSAttributedStringKey.foregroundColor:  defaultTextColor, NSAttributedStringKey.font: UIFont.systemFont(ofSize: 12)]), for: .normal)
        } else {
            button.isEnabled = true
            button.setAttributedTitle(NSAttributedString(string: "复原", attributes: [NSAttributedStringKey.foregroundColor: selectedTextColor, NSAttributedStringKey.font: UIFont.systemFont(ofSize: 12)]), for: .normal)
        }
    }
    /// 开始编辑调用 添加拖动手势
    private func startEditing() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(self.gestureHandler(gesture:)))
        menuCollection.addGestureRecognizer(panGesture)
        dynamicData.append(contentsOf: ["delete", "add"])
        menuCollection.insertItems(at: [IndexPath(row: dynamicData.count-2, section: 0), IndexPath(row: dynamicData.count-1, section:0)])
        isCollectionViewEditing = true
    }
    /// 完成编辑 保存编辑结果
    private func finishEditing() {
        for (offset, index) in deletedCells.enumerated() {
            print("offset: \(offset), index: \(index)")
            dynamicData.remove(at: index-offset)
            menuCollection.deleteItems(at: [IndexPath(row: index-offset, section: 0)])
        }
        
        // 更新数据源 删除删除按钮和添加按钮
        for _ in 1...2 {
            dynamicData.removeLast()
            menuCollection.deleteItems(at: [IndexPath(row: dynamicData.count, section: 0)]) // 因为已经removeLast()所以不用-1
        }
        // 更新静态数据源
        data = dynamicData
        // 通知控制器
//        editCompleted()
//        delegate.popoverMenu?(self, dataUpdated: data)
        // 重置寄存器
        deletedCells = []
        isCollectionViewEditing = false
        menuCollection.allowsSelection = true
    }
    /// 取消编辑 丢弃内容 结束编辑
    private func cancelEdting() {
        if dynamicData.count != data.count+2 {
            //alert
            print("gonna discard what you've already done")
        }
        resetMenu(forEdting: false)
    }
    
    //FIXME: 恢复之后删除可能无法进行
    //TODO: 使用动画形式还原 暂时只实现了待删除项的恢复动画
    
    /// 重置编辑数据 恢复至编辑开始的状态
    private func resetMenu(forEdting: Bool) {

        if forEdting {
//            dynamicData = data // 动画形式不需要
//            dynamicData.append(contentsOf: ["delete", "add"])
//            menuCollection.reloadData()// no need
            resetCells()
        } else {
            // 直接丢弃 从cancel调用
            dynamicData = data
            menuCollection.reloadData()
        }
        deletedCells = []

    }
    /// 复原cell动画
    private func resetCells() {
        deletedCells.enumerated().reversed().forEach() {
            let fromIndex = IndexPath(row: $1, section: 0)
            let title = (self.menuCollection.cellForItem(at: fromIndex) as! JSMenuCell).label!.text
            let toIndex = IndexPath(row: (self.data.index(of: title!))!, section: 0)
            // 交换数据源
            let tmp = dynamicData[fromIndex.row]
            dynamicData[fromIndex.row] = dynamicData[toIndex.row]
            dynamicData[toIndex.row] = tmp
            //改变样式
            dischargeCell(at: fromIndex)
            // 交换cell
            menuCollection.moveItem(at: fromIndex, to: toIndex )
        }
    }
    private func dischargeCell(at indexPath: IndexPath) {
        let cell = menuCollection.cellForItem(at: indexPath) as! JSMenuCell
        cell.discharged()
    }
}
