//
//  UserMessageErrors.swift
//  Rumba
//
//  Created by Vladislav Shchukin on 10.04.2022.
//

import Foundation

enum UserMainErrorMessage: String {
    case firstNameTooShort = "first-name-too-short"
    case lastNameTooShort = "last-name-too-short"
    case emailNotValid = "email-not-valid"
}

enum UserPasswordErrorMessage: String {
    case passwordEmpty = "password-empty."
    case passwordNotStrong = "password-not-strong"
    case passwordsNotMatch = "passwords-not-match"
}
