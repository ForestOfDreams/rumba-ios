//
//  Endpoint+URL.swift
//  Rumba
//
//  Created by Владислав Щукин on 01.02.2022.
//

import Foundation

extension Endpoint {
    var url: URL {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "rumba-app.herokuapp.com"
        components.path = path
        components.queryItems = queryItems
        
        guard let url = components.url else {
            preconditionFailure("Invalid URL components: \(components)")
        }
        
        return url
    }
    
    var headers: [String: Any] {
        return [:
            // "app-id": "YOUR APP ID HERE"
        ]
    }
    
    var authHeaders: [String: Any] {
        return [
            "Authorization": "Bearer \(KeychainStorage.shared.getToken()!.token)"
        ]
    }
}
