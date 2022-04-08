//
//  EventsListView.swift
//  Rumba
//
//  Created by Vladislav Shchukin on 23.03.2022.
//

import SwiftUI

struct ParticipatorEventsListView: View {
    let events: [Event]
    let onRefresh: () -> ()
    let onEventDisappear: () -> ()
    let searchText: Binding<String>
    var filterType: Binding<FilterType>

    
    var body: some View {
        VStack {
            Picker("Event type", selection: filterType) {
                ForEach([FilterType.all, FilterType.past, FilterType.future], id: \.self) {
                    Text($0.rawValue)
                }
            }
            .padding(.horizontal)
            .pickerStyle(.segmented)
            List {
                ForEach(events, id: \.eventId) { event in
                    NavigationLink(
                        destination: ParticipatorEventDetailScreen(
                            viewModel: ParticipatorEventDetailViewModel(
                                eventId: event.eventId
                            )
                        )
                        .onDisappear(perform: onEventDisappear)
                    ) {
                        ParticipatorEventCardView(event: event)
                    }
                }
            }
            .refreshable {
                onRefresh()
            }
        }
        .searchable(text: searchText, prompt: "Filter events")
    }
}

struct ParticipatedListView_Previews: PreviewProvider {
    @State static var searchText = ""
    @State static var filterType = FilterType.all
    static var previews: some View {
        ParticipatorEventsListView(
            events: [DummyData.event],
            onRefresh: {},
            onEventDisappear: {},
            searchText: $searchText,
            filterType: $filterType
        )
    }
}
