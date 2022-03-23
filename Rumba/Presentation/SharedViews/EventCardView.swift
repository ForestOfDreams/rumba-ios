//
//  EventCardView.swift
//  Rumba
//
//  Created by Vladislav Shchukin on 23.03.2022.
//

import SwiftUI

struct EventCardView: View {
    let event: GetParicipatedEventsResponse
    
    var body: some View {
        HStack {
            Text(event.title)
        }
    }
}

struct EventCardView_Previews: PreviewProvider {
    static var previews: some View {
        EventCardView(
            event: GetParicipatedEventsResponse(
                eventId: 1,
                title: "Уборка пляжа",
                description: "Очень увлекательная",
                isOnline: false,
                isCancelled: true,
                isRescheduled: false,
                latitude: 50,
                longitude: 40,
                startDate: Date.now,
                endDate: Date.now
            )
        )
    }
}
