//
//  MyDateFormatter.swift
//  Rumba
//
//  Created by Vladislav Shchukin on 12.04.2022.
//

import Foundation

struct HumanReadableDateFormatter {
    func localizedDate(_ date: Date) -> String {
        dateFormater.string(from: date)
    }
    
    private var dateFormater: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter
    }
}
