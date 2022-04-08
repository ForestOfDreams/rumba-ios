//
//  TaskForm.swift
//  Rumba
//
//  Created by Vladislav Shchukin on 27.03.2022.
//

import Foundation

struct TaskForm: Codable {
    var taskId: Int?
    var title: String
    var description: String
    var membersCount: Int
    var startDate: Date
    var endDate: Date
    
    private enum CodingKeys: CodingKey {
        case title, description, membersCount, startDate, endDate
    }
}
