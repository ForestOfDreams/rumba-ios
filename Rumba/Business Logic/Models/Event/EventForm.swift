//
//  EventForm.swift
//  Rumba
//
//  Created by Vladislav Shchukin on 27.03.2022.
//

import Foundation

struct EventForm: Codable {
    var title: String
    var description: String
    var isOnline: Bool
    var isCancelled: Bool?
    var isRescheduled: Bool?
    var latitude: Double?
    var longitude: Double?
    var placeName: String?
    var startDate: Date
    var endDate: Date
}
