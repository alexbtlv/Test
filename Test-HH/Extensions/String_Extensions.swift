//
//  String_Extensions.swift
//  Test-HH
//
//  Created by Alexander Batalov on 2/26/19.
//  Copyright © 2019 Alexander Batalov. All rights reserved.
//

import Foundation

extension String {
    var isValidEmail: Bool {
        let regex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        return NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: self)
    }
    
    var isValidHHPassword: Bool {
        let regex = "^(?=.*?[A-Z]|[А-Я])(?=.*?[a-z]|[а-я])(?=.*?[0-9]).{6,}$"
        return NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: self)
    }
}
