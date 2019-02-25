//
//  AuthViewController.swift
//  Test-HH
//
//  Created by Alexander Batalov on 2/25/19.
//  Copyright © 2019 Alexander Batalov. All rights reserved.
//

import UIKit

class AuthViewController: UIViewController {

    @IBOutlet weak var containerViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var containerViewBottomConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // remove "Back" text from nav bar back button
        self.navigationController?.navigationBar.topItem?.title = " "
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc private func keyboardWillShow() {
        // define new values
        let offset = navigationController?.navigationBar.frame.height ?? 0
        containerViewTopConstraint.constant = 146 + offset
        print(offset)
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
