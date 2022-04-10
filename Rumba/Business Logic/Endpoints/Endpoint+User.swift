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
    
    static var changeProfile: Self {
        return Endpoint(path: "/api/users")
    }
    
    static var changePassword: Self {
        return Endpoint(path: "/api/users/password")
    }
}
