//
//  Consts.swift
//  Beer List
//
//  Created by Svyat Zubyak on 21.10.2022.
//

import Foundation

enum UserDefaultsKeys: String {
    case loggedInUserEmail = "loggedInUserEmail"
}

enum Storyboards: String {
    case main = "Main"
}

enum ViewControllers: String {
    case tabbar = "TabBarController"
    case detail = "Detail"
    case signUp = "SignUpViewController"
    case edit = "EditViewController"
    case favorite = "FavoriteViewController"
}

enum AlertController: String {
    case fieldsEmpty = "Please, fill all the required fields"
    case invalidEmail = "Email is invalid"
    case invalidPassword = "Password must contain at least 5 characters, including numbers"
    case matchPasswords = "Passwords do not match"
    case incorrectPassword = "Password incorrect"
    case userNotFound = "User not found"
    case somethingWentWrong = "Something went wrong"
}
