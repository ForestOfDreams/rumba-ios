//
//  Endpoint+Member.swift
//  Rumba
//
//  Created by Vladislav Shchukin on 18.03.2022.
//

import Foundation

extension Endpoint {
    static func member(eventID: Int) -> Self {
        return Endpoint(
            path: "/api/members",
            queryItems: [
                URLQueryItem(name: "event_id", value: String(eventID))
            ]
        )
    }
    
    static func leaveEvent(id: Int) -> Self {
        return Endpoint(
            path: "/api/members",
            queryItems: [
                URLQueryItem(name: "event_id", value: String(id))
            ]
        )
    }
    
    static func tryAssignMemberToTask(id: Int) -> Self {
        return Endpoint(
            path: "/api/members/try/assign",
            queryItems: [
                URLQueryItem(name: "task_id", value: String(id))
            ]
        )
    }
    
    static func assignMemberToTask(id: Int) -> Self {
        return Endpoint(
            path: "/api/members/assign",
            queryItems: [
                URLQueryItem(name: "task_id", value: String(id))
            ]
        )
    }
}
