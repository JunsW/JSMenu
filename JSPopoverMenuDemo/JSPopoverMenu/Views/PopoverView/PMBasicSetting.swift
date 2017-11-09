//
//  PopoverMenuViewSetting.swift
//  JSPopoverMenu
//
//  Created by 王俊硕 on 2017/11/4.
//  Copyright © 2017年 王俊硕. All rights reserved.
//

import UIKit

extension JSPopoverMenuView {
    
    internal func setupResponder() {
        removalResponder = UIControl(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: UIScreen.main.bounds.size))
        removalResponder.addTarget(self, action: #selector(offDuty), for: .allEvents)
    }
    internal func setupTextField() {
        textField = JSModalTextField(frame: CGRect(x: 0, y: 60, width: 230, height: 120))
        textField.center = CGPoint(x: screenWidth/2, y: screenHeight/2-90)
        textField.confirmed = { value in
            if let tag = value {
                self.dynamicData.insert(tag, at: self.deleteButtonIndex)
                print(self.dynamicData)
                self.menuCollection.insertItems(at: [IndexPath.ofRow(self.deleteButtonIndex-1)])
                self.delegate.popoverMenu(self, newTag: tag)
            }
        }
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
    /// 设置 顶部视图
    internal func setupHeaderView() {
        headerView = UIView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 30))
        headerView.tag = 10015
        headerView.backgroundColor = baseColor
        
        // 类别/取消 按钮
        let leftButton = JSHeaderButton(originX: 10, state: JSButtonState.group)
        leftButton.addTarget(self, action: #selector(self.leftHeaderButtonTapped), for: .touchUpInside)
        leftButton.tag = 10012
        // 编辑 按钮
        let rightButton = JSHeaderButton(originX: screenWidth-50, state: JSButtonState.edit)
        rightButton.addTarget(self, action: #selector(self.rightHeaderButtonTapped), for: .touchUpInside)
        rightButton.tag = 10013


        headerView.addSubview(leftButton)
        headerView.addSubview(rightButton)
    }
    
    @objc func leftHeaderButtonTapped(sender leftButton: JSHeaderButton) {
        if leftButton.currentState == JSButtonState.reset {
            resetMenu(forEdting: true)
        }
    }
    @objc func rightHeaderButtonTapped(sender rightButton: JSHeaderButton) {        
        let leftButton = headerView.viewWithTag(10012) as! JSHeaderButton
        if rightButton.currentState == JSButtonState.done {// 退出编辑 Edit Done
            rightButton.switchTo(state: .edit)
            leftButton.switchTo(state: .group)
            finishEditing() // 完成编辑 保存
        } else { // 进入编辑 Edit Start
            rightButton.switchTo(state: .done)
            leftButton.switchTo(state: .reset)
            startEditing() // 开始编辑
        }
    }
    
    /// 开始编辑调用 添加拖动手势 Called when editing started. Add drag gesture.
    private func startEditing() {
        panGesture = UIPanGestureRecognizer(target: self, action: #selector(self.gestureHandler(gesture:)))
        menuCollection.addGestureRecognizer(panGesture)
        dynamicData.append(contentsOf: ["delete", "add"])
        menuCollection.insertItems(at: [IndexPath(row: dynamicData.count-2, section: 0), IndexPath(row: dynamicData.count-1, section:0)])
        isCollectionViewEditing = true
    }
    /// 完成编辑 保存编辑结果 Save editing result
    private func finishEditing() {

        // 删除拖动手势 Remove dragging gesture
        menuCollection.removeGestureRecognizer(panGesture)
        // 更新数据源 删除删除按钮和添加按钮 Update dynamic data sdource
        for _ in 1...deletedCells.count+2 {
            dynamicData.removeLast()
            menuCollection.deleteItems(at: [IndexPath(row: dynamicData.count, section: 0)]) // 因为已经removeLast()所以不用-1
        }
        // 更新静态数据源 Update static data source
        data = dynamicData
        // 通知控制器 inform the delegate
//        editCompleted()
        delegate.popoverMenu(self, updatedData: data)
        // 重置寄存器 reset variables
        deletedCells = []
        isCollectionViewEditing = false
        menuCollection.allowsSelection = true
    }
    /// 取消编辑 丢弃内容 结束编辑 Cancel editing. Abandon editing content. End editing
    private func cancelEdting() {
        if dynamicData.count != data.count+2 {
            //alert
            print("gonna discard what you've already done")
        }
        resetMenu(forEdting: false)
    }
    
    //FIXME: 没有恢复交换过但没有删除的Cell 只对特殊按钮后面的待删除项进行还原
    
    /// 重置编辑数据 恢复至编辑开始的状态 Reset data to the beginning.
    private func resetMenu(forEdting: Bool) {

        if forEdting {
            resetCells()
        } else {
            // 直接丢弃 从cancel调用
            dynamicData = data
            menuCollection.reloadData()
        }
        deletedCells = []

    }
    /// 复原cell动画 Animatable reset
    private func resetCells() {
        var indexes = getOrignialIndexes(of: dynamicData)
        deletedCells = []
        var staticIndexes = indexes
        for _ in 1...staticIndexes.count {
            if let last = staticIndexes.popLast(), last != 99 { // last 是原始序号
                let lastItem = dynamicData.popLast()!
                let p = findPosition(of: last, in: indexes)
                print("Gonna move last: \(last) to new position: \(p)")
                indexes.insert(last, at: p) // 同步更新
                dynamicData.insert(lastItem, at: p) // 更新数据源
                menuCollection.moveItem(at: IndexPath.ofRow(dynamicData.count-1), to: IndexPath.ofRow(p)) // 更新CollectionView 每次更新都是dynamicData的最后一项
                dischargeCell(at: IndexPath.ofRow(p))
            } else {
                break //return
            }
        }
        
    }
    private func findPosition(of item: Int, in array: [Int] ) -> Int {
        for (key, element) in array.enumerated() { if item < element { return key } }
        return array.count-1-2 // 最大一个 除掉两个特殊按钮
    }
    /// 找到最初的序号以排序恢复 Find the original position of `dynamicData` item in `data`.
    private func getOrignialIndexes(of array: [String]) -> [Int] {
        return array.map(){ self.data.index(of: $0) ?? 99 } // 使特殊按钮的值尽可能大，这样不会移动到它们后面去 Set the special button a large Int to prevent them from being move to the end when sort by the index
    }
    /// 恢复cell样式 Reset the cell's style
    private func dischargeCell(at indexPath: IndexPath) {
        let cell = menuCollection.cellForItem(at: indexPath) as! JSMenuCell
        cell.discharged()
    }
    /// 恢复单个被删除的Cell 响应点击事件 Recover a cell. Called when user tap single cell in about to delete area
    internal func recoverCell(from index: IndexPath) {
        
        let cell = menuCollection.cellForItem(at: index) as! JSMenuCell
        let toIndex = IndexPath(row: data.index(of: cell.label!.text!)!, section: 0)
        // 更新数据源 update data source
        let element = dynamicData[index.row]
        dynamicData.remove(at: index.row)
        dynamicData.insert(element, at: toIndex.row)
        
        print("move: \(index), to index: \(toIndex), dynamicData: \(dynamicData)")
        menuCollection.moveItem(at: index, to: toIndex)
        
    }
}
