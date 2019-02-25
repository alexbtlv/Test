//
//  AuthViewController.swift
//  Test-HH
//
//  Created by Alexander Batalov on 2/25/19.
//  Copyright © 2019 Alexander Batalov. All rights reserved.
//

import UIKit
import TextFieldEffects

class AuthViewController: UIViewController {

    @IBOutlet weak var containerViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var passwordTextField: HoshiTextField!
    @IBOutlet weak var containerView: UIView!
    
    private var password = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        setupUI()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    private func setupUI() {
        // remove "Back" text from nav bar back button
        navigationController?.navigationBar.topItem?.title = String()
        containerViewBottomConstraint.constant = view.frame.maxY / 2 - containerView.frame.height / 2
        view.layoutIfNeeded()
    }
    
    // MARK: – Action Handlers
    
    @IBAction func tapGestureDidRecognied(_ sender: Any) {
        view.endEditing(true)
    }
    
    @objc private func keyboardWillShow(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            // define new values
            let endFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
            let endFrameY = endFrame?.origin.y ?? 0
            containerViewBottomConstraint.constant = view.frame.maxY - endFrameY
            
            // animate
            UIView.animate(withDuration: 1, delay: 0, options: .curveEaseOut, animations: { [weak self] in
                guard let self = self else { return }
                self.view.layoutIfNeeded()
            }, completion: nil)
        }
    }
    
    @objc private func keyboardWillHide() {
        // set contsrains back to initial values
        containerViewBottomConstraint.constant = view.frame.maxY / 2 - containerView.frame.height / 2
        
        UIView.animate(withDuration: 1, delay: 0, options: .curveEaseOut, animations: { [weak self] in
            guard let self = self else { return }
            self.view.layoutIfNeeded()
            }, completion: nil)
    }
}


extension AuthViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == passwordTextField {
            
            let  char = string.cString(using: String.Encoding.utf8)!
            let isBackSpace = strcmp(char, "\\b")
            
            if (isBackSpace == -92) {
                password.removeLast()
            } else {
                password += string
            }
            
            guard var passwordText = textField.text else { return true }
            var hashPassword = String()
            let newChar = string.first
            let offsetToUpdate = passwordText.index(passwordText.startIndex, offsetBy: range.location)
            
            if string == "" {
                passwordText.remove(at: offsetToUpdate)
                return true
            } else {
                passwordText.insert(newChar!, at: offsetToUpdate)
            }
            
            for _ in 1...passwordText.count {  hashPassword += "*" }
            textField.text = hashPassword
            return false
        }
        return true
    }
    
}
