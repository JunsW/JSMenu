//
//  PopoverMenuViewSetting.swift
//  JSPopoverMenu
//
//  Created by 王俊硕 on 2017/11/4.
//  Copyright © 2017年 王俊硕. All rights reserved.
//

import UIKit

extension JSPopoverMenuView {
    
    // MARK: - UI Setup
    internal func setupResponder() {
        removalResponder = UIControl(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: UIScreen.main.bounds.size))
        removalResponder.addTarget(self, action: #selector(offDuty), for: .allEvents)
    }
    internal func setupTextField() {
        textField = JSModalTextField(frame: CGRect(x: 0, y: 60, width: 230, height: 120))
        textField.center = CGPoint(x: screenWidth/2, y: screenHeight/2-90)
        textField.confirmed = { [weak self] value in
            guard let self = self else { return }
            if let tagRaw = value {
                let tag = JSDefaultTag(id: self.deleteButtonIndex, title: tagRaw)
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
        menuCollection = UICollectionView(frame: CGRect(x: 0, y: headerHeight + menuTopOffset, width: screenWidth, height: menuHeight)
            , collectionViewLayout: layout)
        menuCollection.register(JSMenuCell.self, forCellWithReuseIdentifier: "Cell")
        menuCollection.backgroundColor = baseColor
        menuCollection.delegate = self
        menuCollection.dataSource = self
        menuCollection.tag = 10011
    }
    /// 设置 顶部视图
    internal func setupHeaderView() {
        headerView = UIView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: headerHeight))
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
    // MARK: Button Events
    /// Reset Button Tapped
    @objc func leftHeaderButtonTapped(sender leftButton: JSHeaderButton) {
        if leftButton.currentState == JSButtonState.reset {
            resetMenu(forEdting: true)
        }
    }
    /// Edit/Done Button Tapped
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
    // MARK: - Editing
    /// 开始编辑调用 添加拖动手势 Called when editing started. Add drag gesture.
    private func startEditing() {
        panGesture = UIPanGestureRecognizer(target: self, action: #selector(self.gestureHandler(gesture:)))
        menuCollection.addGestureRecognizer(panGesture)
        dynamicData.append(contentsOf: [JSImageTag.deleteButton, JSImageTag.addButton])
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
            menuCollection.deleteItems(at: [IndexPath(row: dynamicData.count, section: 0)])
        }
        // 更新静态数据源 Update static data source
        data = dynamicData
        // 通知控制器 inform the delegate
        delegate.popoverMenu(self, updatedData: data)
        // 重置变量 reset variables
        deletedCells = []
        isCollectionViewEditing = false
        menuCollection.allowsSelection = true
    }
    /// 取消编辑 丢弃内容 结束编辑 Cancel editing. Discard editing content. End editing
    private func cancelEdting() {
        if dynamicData.count != data.count+2 {
            //alert
            print("gonna discard what you've already done")
        }
        resetMenu(forEdting: false)
    }
    // MARK: - Reset
    /// 重置编辑数据 恢复至编辑开始的状态 Reset data to the beginning.
    private func resetMenu(forEdting: Bool) {

        if forEdting {
            resetCellsStatus()
        } else {
            // 直接丢弃 从cancel调用
            dynamicData = data
            menuCollection.reloadData()
        }
        deletedCells = []

    }
    /// Reset all cells to the begining status of the editing
    private func resetCellsStatus() {
        deletedCells = []
        dynamicData = data
        dynamicData.append(contentsOf: [JSImageTag.deleteButton, JSImageTag.addButton])
        menuCollection.reloadSections([0])
    }
    /// 复原cell动画 Animatable resets. This function is buggy. It's not used in current version.
    private func resetCells() {
        var originIndexes = getOrignialIndexes(of: dynamicData)
        deletedCells = []
        let c = originIndexes.count
        print(originIndexes)
        func reorder() {
            var needContinue = false
            for ri in 1...c {
                let i = c-ri
                let last = originIndexes[i]
                if last <= Int.max-2, last != i { // Int.max-2 is the id of Delete button
                    let lastItem = dynamicData.remove(at: i)
                    originIndexes.remove(at: i)
                    originIndexes.insert(last, at: last) // 同步更新
                    dynamicData.insert(lastItem, at: last) // 更新数据源
                    menuCollection.moveItem(at: IndexPath.ofRow(i), to: IndexPath.ofRow(last)) // 更新CollectionView 每次更新都是dynamicData的最后一项
                    dischargeCell(at: IndexPath.ofRow(last))
                    needContinue = true
                    break
                }
            }
            if needContinue { reorder() }
        }
        reorder()
        
    }
    // MARK: - Helper
    /// 找到最初的序号以排序恢复 Find the original position of `dynamicData` item in `data`.
    private func getOrignialIndexes(of tags: [JSTag]) -> [Int] {
        return tags.map(){ tag in self.data.firstIndex() { tag == $0 } ?? Int.max }
        // 使特殊按钮的值尽可能大，这样不会移动到它们后面去 Set the special button a large Int to prevent them from being move to the end when sort by the index
    }
    /// 恢复cell样式 Reset the cell's style
    private func dischargeCell(at indexPath: IndexPath) {
        let cell = menuCollection.cellForItem(at: indexPath) as! JSMenuCell
        cell.discharged()
    }
    /// 恢复单个被删除的Cell 响应点击事件 Recover a cell. Called when user tap single cell in about to delete area
    internal func recoverCell(from index: IndexPath) {
        
        let staticTag = dynamicData[index.row]
        guard let originIndex = data.firstIndex(where: { (tag) -> Bool in
            tag.id == staticTag.id
        }) else { return }
        
        let toIndex = IndexPath(row: originIndex, section: 0)
        // 更新数据源 update data source
        let element = dynamicData[index.row]
        dynamicData.remove(at: index.row)
        dynamicData.insert(element, at: toIndex.row)
        
//        print("move: \(index), to index: \(toIndex), dynamicData: \(dynamicData)")
        menuCollection.moveItem(at: index, to: toIndex)
        
    }
}
