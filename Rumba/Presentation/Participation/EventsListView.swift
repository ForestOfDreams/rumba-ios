//
//  EventsListView.swift
//  Rumba
//
//  Created by Vladislav Shchukin on 23.03.2022.
//

import SwiftUI

struct EventsListView: View {
    let events: [GetParicipatedEventsResponse]
    
    var body: some View {
        NavigationView {
            List {
                ForEach(events, id: \.eventId) {
                    EventCardView(event: $0)
                }
            }
            .refreshable {
                print("Do your refresh work here")
            }
        }
    }
}

struct EventsListView_Previews: PreviewProvider {
    static var previews: some View {
        EventsListView(
            events:
                [GetParicipatedEventsResponse(
                    eventId: 1,
                    title: "Уборка пляжа",
                    description: "Очень увлекательна",
                    isOnline: false,
                    isCancelled: true,
                    isRescheduled: false,
                    latitude: 50,
                    longitude: 40,
                    startDate: Date.now,
                    endDate: Date.now
                ),
                 GetParicipatedEventsResponse(
                    eventId: 2,
                    title: "Уборка пляжа",
                    description: "Очень увлекательна",
                    isOnline: false,
                    isCancelled: true,
                    isRescheduled: false,
                    latitude: 50,
                    longitude: 40,
                    startDate: Date.now,
                    endDate: Date.now
                 )])
    }
}
