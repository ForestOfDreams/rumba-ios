//
//  Endpoint+User.swift
//  Rumba
//
//  Created by Владислав Щукин on 01.02.2022.
//

import Foundation

extension Endpoint {    
    static var registr: Self {
        return Endpoint(path: "/auth/register")
    }
}

