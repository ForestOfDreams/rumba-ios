//
//  Endpoint+User.swift
//  Rumba
//
//  Created by Vladislav Shchukin on 30.03.2022.
//

import Foundation

extension Endpoint {
    static var getCurrentUser: Self {
        return Endpoint(path: "/api/users")
    }
}
