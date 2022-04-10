//
//  UserMessageErrors.swift
//  Rumba
//
//  Created by Vladislav Shchukin on 10.04.2022.
//

import Foundation

enum UserMainErrorMessage: String {
    case firstNameTooShort = "First name must contain at least 2 characters."
    case lastNameTooShort = "Last name must contain at least 2 characters."
    case emailNotValid = "You must enter a valid email."
}

enum UserPasswordErrorMessage: String {
    case passwordEmpty = "Password cannot be empty."
    case passwordNotStrong = "Password is not strong enough."
    case passwordsNotMatch = "Password do not match."
}
