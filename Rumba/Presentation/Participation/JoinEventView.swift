//
//  JoinEventView.swift
//  Rumba
//
//  Created by Vladislav Shchukin on 23.03.2022.
//

import SwiftUI

struct JoinEventView: View {
    let title: String
    let description: String
    let isOnline: Bool
    let isCancelled: Bool
    let isRescheduled: Bool
    let latitude: Double
    let longitude: Double
    let startDate: Date
    let endDate: Date
    let joinEvent: () -> Void
    
    var body: some View {
        VStack {
            DetailEventView(
                title: title,
                description: description,
                isOnline: isOnline,
                isCancelled: isCancelled,
                isRescheduled: isRescheduled,
                latitude: latitude,
                longitude: longitude,
                startDate: startDate,
                endDate: endDate
            )
            Button {
                joinEvent()
            } label: {
                Text("Join")
            }
            
        }
    }
}

struct JoinEventView_Previews: PreviewProvider {
    static var previews: some View {
        JoinEventView(
            title: "Уборка пляжа",
            description: "Увлекательная уборка пляжа",
            isOnline: false, isCancelled: false,
            isRescheduled: false, latitude: 45.4,
            longitude: 43.3, startDate: Date.now,
            endDate: Date.now + TimeInterval(1),
            joinEvent: {}
        )
    }
}
