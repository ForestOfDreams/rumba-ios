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
    let searchText: Binding<String>
    var filterType: Binding<FilterType>
    
    var body: some View {
        VStack {
            Picker("Event type", selection: filterType) {
                ForEach(FilterType.allCases, id: \.self) {
                    Text(LocalizedStringKey($0.rawValue))
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
                    ) {
                        ParticipatorEventCardView(event: event)
                    }
                }
            }
            .refreshable {
                onRefresh()
            }
        }
        .searchable(text: searchText, prompt: "search-placeholder")
    }
}

struct ParticipatedListView_Previews: PreviewProvider {
    @State static var searchText = ""
    @State static var filterType = FilterType.all
    static var previews: some View {
        ParticipatorEventsListView(
            events: [DummyData.event],
            onRefresh: {},
            searchText: $searchText,
            filterType: $filterType
        )
    }
}
