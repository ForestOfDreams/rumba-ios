//
//  GetEventResponse.swift
//  Rumba
//
//  Created by Vladislav Shchukin on 22.03.2022.
//

import Foundation

struct Event: Codable {
    var eventId: Int?
    var title: String
    var description: String
    var isOnline: Bool
    var isCancelled: Bool?
    var isRescheduled: Bool?
    var latitude: Double?
    var longitude: Double?
    var startDate: Date
    var endDate: Date
    var tasks: [Task]?
    var creator: Creator?
}

struct Creator: Codable {
    var accountId: Int
    var firstName: String
    var lastName: String
    var email: String
}
