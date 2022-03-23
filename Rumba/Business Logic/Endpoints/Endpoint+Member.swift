//
//  Endpoint+Member.swift
//  Rumba
//
//  Created by Vladislav Shchukin on 18.03.2022.
//

import Foundation

extension Endpoint {
    static func member(eventID: Int) -> Self {
        return Endpoint(path: "/api/members",
                        queryItems: [
                            URLQueryItem(name: "event_id", value: String(eventID))
                        ])
    }
}
