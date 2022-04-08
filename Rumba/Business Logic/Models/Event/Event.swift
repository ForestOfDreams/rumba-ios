//
//  GetEventResponse.swift
//  Rumba
//
//  Created by Vladislav Shchukin on 22.03.2022.
//

import Foundation

struct Event: Decodable {
    let eventId: Int
    let title: String
    let description: String
    let isOnline: Bool
    let isCancelled: Bool
    let isRescheduled: Bool
    let isActionsRequired: Bool?
    let placeName: String?
    let latitude: Double?
    let longitude: Double?
    let startDate: Date
    let endDate: Date
    let tasks: [Task]?
    let members: [User]?
    let creator: Creator?
}

struct Creator: Decodable {
    let accountId: Int
    let firstName: String
    let lastName: String
    let email: String
}
