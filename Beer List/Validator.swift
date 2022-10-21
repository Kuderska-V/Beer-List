//
//  Validator.swift
//  Beer List
//
//  Created by Svyat Zubyak on 21.10.2022.
//

import Foundation

protocol ValidatorProtocol {
    func isValid(email: String) -> Bool
    func isValid(password: String) -> Bool
}

struct Validator: ValidatorProtocol {
    
    func isValid(email: String) -> Bool {
        let reqularExpression = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let predicate = NSPredicate(format: "SELF MATCHES %@", reqularExpression)
        return predicate.evaluate(with: email)
    }
    
    func isValid(password: String) -> Bool {
        guard password.count > 4 else { return false }
        return containsDigit(password)
    }
    
    private func containsDigit(_ value: String) -> Bool {
        let reqularExpression = ".*[0-9]+.*"
        let predicate = NSPredicate(format: "SELF MATCHES %@", reqularExpression)
        return predicate.evaluate(with: value)
    }
}
