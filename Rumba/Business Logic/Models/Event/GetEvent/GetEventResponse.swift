//
//  GetEventResponse.swift
//  Rumba
//
//  Created by Vladislav Shchukin on 22.03.2022.
//

import Foundation


struct GetEventResponse: Decodable {
    let eventId: Int
    let title: String
    let description: String
    let isOnline: Bool
    let isCancelled: Bool
    let isRescheduled: Bool
    let latitude: Double
    let longitude: Double
    let startDate: Date
    let endDate: Date
    let tasks: [Task]
    let creator: Creator
}

struct Task: Decodable {
    let taskId: Int
    let title: String
    let description: String
    let startDate: Date
    let endDate: Date
}

struct Creator: Decodable {
    let accountId: Int
    let firstName: String
    let lastName: String
    let email: String
}
