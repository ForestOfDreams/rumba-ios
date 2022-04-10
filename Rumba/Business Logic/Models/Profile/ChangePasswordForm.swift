//
//  ChangePassword.swift
//  Rumba
//
//  Created by Vladislav Shchukin on 11.04.2022.
//

import Foundation

struct ChangePasswordForm: Codable {
    let oldPassword: String
    let newPassword: String
}
