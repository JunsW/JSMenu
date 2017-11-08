//
//  JSModalTextField.swift
//  JSPopupInputView
//
//  Created by 王俊硕 on 2017/11/8.
//  Copyright © 2017年 王俊硕. All rights reserved.
//

import UIKit

class JSModalTextField: UIView {
    
    fileprivate var backMask: UIView!
    fileprivate var textField: UITextField!
    fileprivate var infoLabel: UILabel!
    fileprivate var confirmButton: UIButton!

    fileprivate var isEditing = false
    
    public var maxInputLength = 4
    
    /// Called when user tapped the "done" button on the keyboard
    public var editingCompleted: ((UITextField) -> Void)?
    /// Called in textField's shouldBeginEditing method. Use default rule if not set.
    public var shouldChangeCharacters: ((UITextField) -> Bool)?
    /// Called when dismiss animation completed.
    public var dismissCompleted: (()->Void)?
    /// Called when confirmedButton tapped. The parameter is the input text.
    public var confirmed: ((String?)->Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame) // >=50
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        alpha = 0
        backgroundColor = .white
        layer.cornerRadius = 3
        
        setupBackMask()
        setupInfoLabel()
        setupTextField()
        setupButton()
        
        addSubview(infoLabel)
        addSubview(textField)
        addSubview(confirmButton)
        
    }
    @objc internal func responderTapped() {
        
        if isEditing {
            print("Shut keyboard down")
            textField.resignFirstResponder()
            isEditing = false
        } else {
            print("Dismiss")
            dismissA(completion: nil)
        }
    }
    
    
}
// Mrak: - BasicSetting
extension JSModalTextField {
    
    fileprivate func setupBackMask() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(responderTapped))
        backMask = UIView(frame: CGRect(origin: CGPoint.zero, size: UIScreen.main.bounds.size))
        backMask.addGestureRecognizer(tapGesture)
        backMask.backgroundColor = .black
        backMask.alpha = 0
    }
    fileprivate func setupInfoLabel() {
        infoLabel = UILabel(frame: CGRect(x: 10, y: 15, width: self.bounds.width-20, height: 20))
        infoLabel.attributedText = NSAttributedString(string: "新的标签", attributes: [NSAttributedStringKey.font : UIFont.systemFont(ofSize: 13), NSAttributedStringKey.foregroundColor : UIColor.black])
        infoLabel.numberOfLines = 1
        infoLabel.textAlignment = .center
    }
    fileprivate func setupTextField() {
        textField = UITextField(frame: CGRect(x: 0, y: 40, width: self.bounds.width*0.8, height: 30))
        textField.center.x = bounds.width/2
        
        textField.delegate = self
        textField.backgroundColor = UIColor.from(hex: 0xE2E3E7)
        textField.layer.borderColor = UIColor.from(hex: 0xE2E3E7).cgColor
        textField.layer.cornerRadius = 2
        textField.placeholder = "Label"
        textField.clearButtonMode = .whileEditing
        textField.autocorrectionType = .no
        textField.keyboardAppearance = .default
        textField.keyboardType = .default
        textField.returnKeyType = .done
        textField.leftViewMode = .always
        textField.font = UIFont.systemFont(ofSize: 13)
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 30))
    }
    fileprivate func setupButton() {
        confirmButton = UIButton(frame: CGRect(x: 0, y: 80, width: self.bounds.width*0.9, height: 30))
        confirmButton.center.x = bounds.width / 2
        confirmButton.addTarget(self, action: #selector(confirmButtonTouchDown), for: .touchDown)
        confirmButton.addTarget(self, action: #selector(confirmButtonTouchUp), for: .touchUpInside)
        confirmButton.setAttributedTitle(NSAttributedString(string: "添 加", attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 13), NSAttributedStringKey.foregroundColor: UIColor.white]), for: .normal)
        confirmButton.backgroundColor = .from(hex: 0xFD8B15)
    }
    @objc fileprivate func confirmButtonTouchDown() {
        confirmButton.backgroundColor = .from(hex: 0xffffff)
    }
    @objc fileprivate func confirmButtonTouchUp() {
        confirmButton.backgroundColor = .from(hex: 0xFD8B15)
        textField.resignFirstResponder()
        dismissA() { self.confirmed?(self.textField.text ?? "") }
    }
}
// Mark: - Presentation
extension JSModalTextField {
    public func show(onView view: UIView, completion: (()->Void)?) {
        view.addSubview(backMask)
        view.addSubview(self)
        self.textField.text = ""
        UIView.animate(withDuration: 0.2, animations: {
            self.backMask.alpha = 0.6
            self.alpha = 1
        }) { (_) in
            completion?()
        }
    }
    @objc public func dismissA(completion: (()->Void)?) {
        UIView.animate(withDuration: 0.3, animations: {
            self.backMask.alpha = 0
            self.alpha = 0
        }) { (_) in
            self.backMask.removeFromSuperview()
            self.removeFromSuperview()
            if let closure = completion {
                closure()
            } else {
                self.dismissCompleted?()
            }
        }
    }
}
extension JSModalTextField: UITextFieldDelegate {
    internal func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        isEditing = true
        return true
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let closure = shouldChangeCharacters {
            return closure(textField)
        } else {
            if textField.text?.count ?? 0 > maxInputLength {
                return false
            } else {
                return true
            }
        }
    }
    internal func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        isEditing = false
        
        editingCompleted?(textField)
        textField.resignFirstResponder() //
        return true
    }
}
