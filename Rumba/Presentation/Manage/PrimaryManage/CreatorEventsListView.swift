//
//  CreatorEventsListView.swift
//  Rumba
//
//  Created by Vladislav Shchukin on 31.03.2022.
//

import SwiftUI

struct CreatorEventsListView: View {
    let events: [Event]
    let onRefresh: () -> ()
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
                        destination: CreatorEventDetailScreen(
                            viewModel:
                                CreatorEventDetailViewModel(
                                    eventId: event.eventId
                                )
                        )
//                        .onDisappear(perform: onEventDisappear)
                    ) {
                        CreatorEventCardView(event: event)
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

//struct CreatorEventsListView_Previews: PreviewProvider {
//    static var previews: some View {
//        CreatorEventsListView()
//    }
//}
