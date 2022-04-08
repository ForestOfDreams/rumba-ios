//
//  EventsListView.swift
//  Rumba
//
//  Created by Vladislav Shchukin on 23.03.2022.
//

import SwiftUI

struct ParticipatedListView: View {
    let events: [Event]
    let fetchParticipatedEvents: () -> ()
    
    var body: some View {
        List {
            ForEach(events, id: \.eventId) { event in
                NavigationLink {
                    ParticipatorEventDetailScreen(
                        viewModel: CreatorEventDetailViewModel(
                            eventId: event.eventId)
                    )
                } label: {
                    HStack {
                        Text(event.title)
                        Spacer()
                        if (event.isActionsRequired ?? false) {
                            Image(systemName: "exclamationmark.square")
                                .resizable()
                                .scaledToFill()
                                .frame(width: 15)
                                .foregroundColor(.yellow)
                                .padding(.horizontal)
                        }
                    }
                }
                
            }
        }
        .refreshable {
            fetchParticipatedEvents()
        }
    }
}

//struct ParticipatedListView_Previews: PreviewProvider {
//    static var previews: some View {
//        EventsListView(
//            events:
//                [Event(
//                    eventId: 1,
//                    title: "Уборка пляжа",
//                    description: "Очень увлекательна",
//                    isOnline: false,
//                    isCancelled: true,
//                    isRescheduled: false,
//                    latitude: 50,
//                    longitude: 40,
//                    startDate: Date.now,
//                    endDate: Date.now
//                ),
//                 Event(
//                    eventId: 2,
//                    title: "Уборка пляжа",
//                    description: "Очень увлекательна",
//                    isOnline: false,
//                    isCancelled: true,
//                    isRescheduled: false,
//                    latitude: 50,
//                    longitude: 40,
//                    startDate: Date.now,
//                    endDate: Date.now
//                 )],
//            fetchParticipatedEvents: {}
//        )
//    }
//}
