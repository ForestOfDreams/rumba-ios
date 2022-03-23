//
//  File.swift
//  Rumba
//
//  Created by Vladislav Shchukin on 22.03.2022.
//

import Foundation

struct GetParicipatedEventsResponse: Decodable {
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
}
