//
//  AuthViewController.swift
//  Test-HH
//
//  Created by Alexander Batalov on 2/25/19.
//  Copyright © 2019 Alexander Batalov. All rights reserved.
//

import UIKit
import TextFieldEffects
import MBProgressHUD
import Alamofire
import Keys

class AuthViewController: UIViewController {

    @IBOutlet weak var containerViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var passwordTextField: HoshiTextField!
    @IBOutlet weak var emailTextField: HoshiTextField!
    @IBOutlet weak var containerView: UIView!
    
    private var password = String()
    
    // MARK: – View Controller life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        setupUI()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: – Helper functions
    
    private func setupUI() {
        // remove "Back" text from nav bar back button
        navigationController?.navigationBar.topItem?.title = String()
        containerViewBottomConstraint.constant = view.frame.maxY / 2 - containerView.frame.height / 2
        view.layoutIfNeeded()
        let navigationTitleFont = UIFont(name: "SFUIText-Medium", size: 17)!
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: navigationTitleFont]
    }
    
    private func getWeather() {
        MBProgressHUD.showAdded(to: view, animated: true)
        
        DispatchQueue.global().async { [weak self] in
            guard let self = self else { return }
            // request current weather in Paris
            let keys = TestHHKeys()
            AF.request("https://api.darksky.net/forecast/\(keys.darkSkyAPIKey)/48.80750193926096,2.561346336611407/?exclude=%5Bminutely,hourly,daily,alerts,flags%5D").responseData { response in
                
                switch response.result {
                case .success(let value):
                    do {
                        let weather = try JSONDecoder().decode(Weather.self, from: value)
                        DispatchQueue.main.async {
                            MBProgressHUD.hide(for: self.view, animated: true)
                            self.showAlert(withMessage: "It is \(weather.currently.summary) at \(weather.currently.temperatureC)°C in Paris. ", success: true)
                        }
                    } catch {
                        print(error.localizedDescription)
                    }
                case .failure(let error):
                    DispatchQueue.main.async {
                        MBProgressHUD.hide(for: self.view, animated: true)
                        self.showAlert(withMessage: error.localizedDescription)
                    }
                }
            }
            
        }
        
    }
    
    private func showAlert(withMessage message: String?, success: Bool = false ) {
        let alert = UIAlertController(title: success ? "Успех" : "Ошибка", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: – Action Handlers
    
    @IBAction func fogotPasswordButtonTApped(_ sender: Any) {
        showAlert(withMessage: "Пожалуй мы должны дать пользователю возможность восстановить пароль.")
    }
    
    @IBAction func signInButtonTapped(_ sender: Any) {
        // check if email is correct
        guard let text = emailTextField.text, text.isValidEmail else {
            showAlert(withMessage: "Пожалуйста веедите корректный адрес почты")
            return
        }
        // check if password is correct
        guard password.isValidHHPassword else {
            showAlert(withMessage: "Пожалуйста убедитесь что пароль содержит минимум 6 символов, минимум 1 строчную букву, 1 заглавную, и 1 цифру.")
            return
        }
        getWeather()
    }
    
    @IBAction func signUpButtonTapped(_ sender: Any) {
        showAlert(withMessage: "Наверное должен появиться экран регистрации нового пользователя.")
    }
    
    
    @IBAction func tapGestureDidRecognied(_ sender: Any) {
        // dismiss keyboard
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
            // replace default bulletts with *
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
