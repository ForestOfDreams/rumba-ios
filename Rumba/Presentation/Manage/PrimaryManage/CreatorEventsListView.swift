//
//  CreatorEventsListView.swift
//  Rumba
//
//  Created by Vladislav Shchukin on 31.03.2022.
//

import SwiftUI

struct CreatorEventsListView: View {
    @Binding var events: [Event]
    var onRefresh: () -> ()
    
    var body: some View {
        List {
            ForEach($events, id: \.eventId) { $event in
                NavigationLink(destination: CreatorEventDetailView(event: $event)) {
                        CreatorEventCardView(event: event)
                }
            }
        }
        .refreshable {
            onRefresh()
        }
    }
}

//struct CreatorEventsListView_Previews: PreviewProvider {
//    static var previews: some View {
//        CreatorEventsListView()
//    }
//}
