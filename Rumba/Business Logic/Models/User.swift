//
//  User.swift
//  Rumba
//
//  Created by Vladislav Shchukin on 30.03.2022.
//

import Foundation

struct User: Decodable {
    let accountId: Int
    let firstName: String
    let lastName: String
    let email: String
}
