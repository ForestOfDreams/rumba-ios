//
//  User.swift
//  Rumba
//
//  Created by Vladislav Shchukin on 30.03.2022.
//

import Foundation

struct User: Decodable {
    let email: String
    let firstName: String
    let lastName: String
    let hoursInEvents: Int
}
