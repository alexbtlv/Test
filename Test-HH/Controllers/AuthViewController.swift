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

    @IBOutlet weak var containerViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var containerViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var passwordTextField: HoshiTextField!
    
    private var password = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // remove "Back" text from nav bar back button
        self.navigationController?.navigationBar.topItem?.title = String()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: – Action Handlers
    
    @IBAction func tapGestureDidRecognied(_ sender: Any) {
        view.endEditing(true)
    }
    
    @objc private func keyboardWillShow() {
        // define new values
        let offset = navigationController?.navigationBar.frame.height ?? 0
        containerViewTopConstraint.constant = 146 + offset
        UIView.animate(withDuration: 1, delay: 0, options: .curveEaseOut, animations: { [weak self] in
            guard let self = self else { return }
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    @objc private func keyboardWillHide() {
        // set contsrains back to initial values
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
