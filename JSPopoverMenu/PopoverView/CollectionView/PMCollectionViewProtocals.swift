//
//  PMCollectionView.swift
//  JSPopoverMenu
//
//  Created by 王俊硕 on 2017/11/4.
//  Copyright © 2017年 王俊硕. All rights reserved.
//

import UIKit

extension PopoverMenuView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 63, height: 30)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        let limitation = dynamicData.count - 1 - deletedCells.count
        return indexPath.row < limitation ? false : true
    }
    /// 只有待删除的cell才会调用这个事件
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("I've been chosen! Help : \(indexPath)")
        let cell = collectionView.cellForItem(at: indexPath) as! JSMenuCell
        if (cell.label != nil) {
            cell.discharged()
            recoverCell(from: indexPath)
            deletedCells.remove(at: 7 - indexPath.row)
        } else {
            // Add
        }
       
//        delegate.popoverMenu(self, didSelectedAt: indexPath)
    }
    func recoverCell(from index: IndexPath) {
        let cell = menuCollection.cellForItem(at: index) as! JSMenuCell
        let toIndex = IndexPath(row: data.index(of: cell.label!.text!)!, section: 0)
        menuCollection.moveItem(at: index, to: toIndex)
    }
}

extension PopoverMenuView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dynamicData.count
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! JSMenuCell
        
        if dynamicData[indexPath.row] == "add" {
            cell.setupImage(name: "cross")
//            button.setImage(UIImage(named: "cross"), for: .normal)
//            button.layer.borderColor = UIColor.from(hex: selectedTextColor).cgColor
//            button.layer.borderWidth = 1.5
//            button.label.isHidden = true
        } else if dynamicData[indexPath.row] == "delete" {
            cell.setupImage(name: "dustbin")
//            button.setImage(UIImage(named: "dustbin2"), for: .normal)
//            button.imageView?.contentMode = .scaleAspectFit
//            button.isEnabled = false
//            button.label.isHidden = true
        } else {
            cell.setup(title: dynamicData[indexPath.row])
        }
        return cell
    }
    
}
extension PopoverMenuView: UICollectionViewDelegateFlowLayout {
    
}
