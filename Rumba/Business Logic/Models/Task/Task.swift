//
//  Task.swift
//  Rumba
//
//  Created by Vladislav Shchukin on 26.03.2022.
//

import Foundation

struct Task: Encodable {
    let taskId: Int
    let title: String
    let description: String
    let membersCount: Int
    let startDate: Date
    let endDate: Date
}
