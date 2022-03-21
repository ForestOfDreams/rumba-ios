//
//  LoginResponse.swift
//  Rumba
//
//  Created by Vladislav Shchukin on 24.02.2022.
//

import Foundation

struct LoginResponse: Codable {
    let expires_at: Date
    let created_at: Date
    let token: String
}
