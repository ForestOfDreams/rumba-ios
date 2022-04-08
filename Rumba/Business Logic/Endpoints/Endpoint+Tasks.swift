//
//  Endpoint+Tasks.swift
//  Rumba
//
//  Created by Vladislav Shchukin on 18.03.2022.
//

import Foundation

extension Endpoint {
    static func createTask(eventID: Int) -> Self {
        return Endpoint(
            path: "/api/tasks",
            queryItems: [
                URLQueryItem(name: "event_id", value: String(eventID))
            ]
        )
    }
    
    static func updateTask(id: Int) -> Self {
        return Endpoint(path: "/api/tasks/\(id)")
    }
    
    static func deleteTask(id: Int) -> Self {
        return Endpoint(path: "/api/tasks/\(id)")
    }
    
    static func getMyTask(eventID: Int) -> Self {
        return Endpoint(
            path: "/api/tasks",
            queryItems: [
                URLQueryItem(name: "event_id", value: String(eventID))
            ]
        )
    }
}
