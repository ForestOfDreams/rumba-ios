//
//  Task.swift
//  Rumba
//
//  Created by Vladislav Shchukin on 26.03.2022.
//

import Foundation

struct Task: Decodable {
    let taskId: Int
    let title: String
    let description: String
    let membersCount: Int
    let startDate: Date
    let endDate: Date
    let members: [Member]
}

struct Member: Decodable {
    let memberId: Int
    let member: User
    let startDate: Date
    let endDate: Date
}
