//
//  CreatorEventDetailView.swift
//  Rumba
//
//  Created by Vladislav Shchukin on 04.04.2022.
//

import SwiftUI

struct CreatorEventDetailView: View {
    @State var selection: Int? = nil
    
    let event: Event
    let image: UIImage
    let onShare: () -> ()
    
    var body: some View {
        ScrollView {
            VStack {
                EventDetailView(
                    event: event,
                    image: image,
                    shareAction: onShare
                )
                TitleView(text: "Tasks")
                TasksListView(
                    tasks: event.tasks ?? [],
                    event: event,
                    showEdit: true,
                    showAssignButton: false
                )
                NavigationLink(
                    destination: TaskEditScreen(
                        viewModal: TaskEditViewModel(
                            relatedEvent: event
                        )
                    ),
                    tag: 1,
                    selection: $selection
                ) {
                    Button("Add new task") {
                        self.selection = 1
                    }
                    .buttonStyle(PrimaryButton(color: .green))
                }
            }
            .padding()
        }
    }
}

struct CreatorEventDetailView_Previews: PreviewProvider {
    static var previews: some View {
        CreatorEventDetailView(
            event: DummyData.event,
            image: UIImage(systemName: "qrcode")!,
            onShare: {}
        )
    }
}
