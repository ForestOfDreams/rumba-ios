//
//  JoinEventView.swift
//  Rumba
//
//  Created by Vladislav Shchukin on 10.04.2022.
//

import SwiftUI

struct JoinEventView: View {
    let event: Event
    let onJoinEvent: () -> ()
    
    var body: some View {
        ScrollView {
            VStack {
                EventDetailView(
                    event: event,
                    image: nil,
                    shareAction: {}
                )
                TitleView(text: "Tasks")
                TasksListView(
                    tasks: event.tasks ?? [],
                    event: event,
                    showEdit: false,
                    showAssignButton: false
                )
                Button {
                    onJoinEvent()
                } label: {
                    Text("join-event-btn")
                }
                .buttonStyle(PrimaryButton(color: .blue))
            }
            .padding()
        }
    }
}

struct JoinEventView_Previews: PreviewProvider {
    static var previews: some View {
        JoinEventView(
            event: DummyData.event,
            onJoinEvent: {}
        )
    }
}
