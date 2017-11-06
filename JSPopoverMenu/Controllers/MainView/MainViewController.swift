//
//  ViewController.swift
//  JSPopoverMenu
//
//  Created by 王俊硕 on 2017/11/3.
//  Copyright © 2017年 王俊硕. All rights reserved.
//

import UIKit

class MainViewController: UIViewController  {

    lazy var midButton = UIButton(type:  .system)
    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height
    let defaultData = ["一二", "三四", "五六", "七八", "九十", "溢出"]
    
    var popoverView: PopoverMenuView!
    var displayerLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        view.backgroundColor = .white
        setupMidButton()
        
        setupDisplayer()
        view.addSubview(displayerLabel)
        popoverView = PopoverMenuView(height: 120, data: defaultData)
        popoverView.delegate = self
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupDisplayer() {
        displayerLabel = UILabel(frame: CGRect(x: 0, y: 300, width: screenWidth, height: 30))
        displayerLabel.text = reduceArray(defaultData)
        displayerLabel.numberOfLines = 1
        displayerLabel.textAlignment = .center
    }
    // Mark: - Button in the middle of header
    
    func setupMidButton() {
        navigationController?.navigationBar.isTranslucent = false
        midButton.frame = CGRect(x: 0, y: 0, width: 60, height: 30)
        midButton.addTarget(self, action: #selector(self.midButtonTapped), for: .touchUpInside)
        midButton.setAttributedTitle(NSAttributedString(string: "Test", attributes: [.font: UIFont.systemFont(ofSize: 15), .foregroundColor: UIColor.black]), for: UIControlState.normal)
        navigationItem.titleView = midButton
    }
    @objc func midButtonTapped() {
        popoverView.quickSwitch()
    }
    internal func reduceArray(_ array: Array<String>) -> String{
        return String(array.reduce(into:"") { $0 += $1 + ", " }.dropLast(2))
    }
}

