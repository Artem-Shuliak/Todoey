//
//  AlertView.swift
//  Todoey
//
//  Created by Artem Shuliak  on 3/12/21.
//  Copyright © 2021 App Brewery. All rights reserved.
//

import UIKit

class AlertView: UIView {

    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var alertView: UIView!
    @IBOutlet weak var alertTitle: UILabel!
    @IBOutlet weak var alertTextField: UITextField!
    @IBOutlet var alertButtons: [UIButton]!
    @IBOutlet var colorButtons: [UIButton]!
    @IBOutlet weak var colorStackView: UIStackView!
    
    // saves selected color in the alert and passes to the view controller
    var selectedColor: UIColor?
    
    // MARK: - Pass Back Closures
    var cancelButtonClicked: (() -> ())?
    var addButtonClicked: (() -> ())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        animateIn()
        setupContent()
        alertTextField.delegate = self
        hideKeyboardWhenTappedAround()
    
        //listen for keyboard events
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    deinit {
        // stop listening for the keyboard show/hide events
        NotificationCenter.default.removeObserver(self)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if let superview = superview {
            self.frame = superview.bounds
        }
    }
    
    func loadFromNib() -> UIView {
        return Bundle.main.loadNibNamed("AlertView", owner: nil, options: nil)?.first as! AlertView
    }

    func setupContent() {
        backgroundView.alpha = 0.2
        alertView.layer.cornerRadius = alertView.frame.size.height / 10
        colorButtons.forEach { (button) in
            button.layer.cornerRadius = button.frame.size.height / 2
        }
        alertButtons.forEach { (button) in
            button.layer.cornerRadius = button.frame.size.height / 5
        }
    }
    
    func set(title: String, leftButtonTitle: String, rightButtonTitle: String, showColorOptions: Bool) {
        self.alertTitle.text = title
        self.alertButtons[0].setTitle(leftButtonTitle, for: .normal)
        self.alertButtons[1].setTitle(rightButtonTitle, for: .normal)
        
        if showColorOptions == false {
            colorStackView.removeFromSuperview()
        }
    }
        
  
// MARK: - Button Actions
    
    @IBAction func colorButtonClicked(_ sender: UIButton) {
        colorButtons.forEach { (button) in
            button.layer.borderWidth = 0
        }
        sender.layer.borderWidth = 2
        sender.layer.borderColor = UIColor.black.cgColor
        selectedColor = sender.backgroundColor
    }
    
    @IBAction func cancelButtonAction(_ sender: UIButton) {
        cancelButtonClicked?()
        sender.highlight()
        alertTextField.endEditing(true)
    }
    
    @IBAction func addButtonAction(_ sender: UIButton) {
        addButtonClicked?()
        sender.highlight()
        alertTextField.endEditing(true)
    }
        
    
}

// MARK: - Custom Button Highlight
extension UIButton {
    func highlight() {
        if isHighlighted {
            alpha = 0.5
        }
    }
}


// MARK: - Animations

extension AlertView {
    
    func animateIn() {
        alertView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        alertView.alpha = 0
        backgroundView.alpha = 0
        
        UIView.animate(withDuration: 0.3) {
            self.backgroundView.alpha = 0.4
            self.alertView.alpha = 1
            self.alertView.transform = CGAffineTransform.identity
        }
    }
    
    func animateOut() {
        UIView.animate(withDuration: 0.3) {
            self.backgroundView.alpha = 0
            self.alertView.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            self.alertView.alpha = 0
        } completion: { (_) in
            self.removeFromSuperview()
        }
    }
}


// MARK: - Keyboard Properties

extension AlertView: UITextFieldDelegate {
    
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        backgroundView.addGestureRecognizer(tap)
    }
    
   @objc func dismissKeyboard() {
        alertTextField.endEditing(true)
    }
    
    @objc func keyboardWillChange(notification: Notification) {
        
        guard let keyboardRect = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
            
        if notification.name == UIResponder.keyboardWillShowNotification  ||  notification.name == UIResponder.keyboardWillChangeFrameNotification{
            UIView.animate(withDuration: 0.2) {
                self.alertView.transform = CGAffineTransform(translationX: 0, y: -(keyboardRect.height/3))
            }
        } else {
            UIView.animate(withDuration: 0.2) {
                self.alertView.transform = CGAffineTransform.identity
            }
        }
        
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        alertTextField.endEditing(true)
        return true
    }
    
}

