//
//  Endpoint+Events.swift
//  Rumba
//
//  Created by Vladislav Shchukin on 18.03.2022.
//

import Foundation

extension Endpoint {
    static var createEvent: Self {
        return Endpoint(path: "/api/events")
    }
    
    static var getCreatedEvents: Self {
        return Endpoint(path: "/api/events/created")
    }
    
    static var getParicipatedEvents: Self {
        return Endpoint(path: "/api/events/participated")
    }
    
    static func getEvent(id: Int) -> Self {
        return Endpoint(path: "/api/events/\(id)")
    }
    
    static func updateEvent(id: Int) -> Self {
        return Endpoint(path: "/api/events/\(id)")
    }
}
