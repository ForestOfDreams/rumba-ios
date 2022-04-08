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
                VStack {
                    Text("Other tasks")
                        .font(.title)
                        .padding(.top, 10)
                }
                .frame(
                    maxWidth: .infinity,
                    alignment: .topLeading
                )
                TasksListView(
                    tasks: event.tasks ?? [],
                    event: event,
                    showEdit: true
                )
                NavigationLink(
                    destination: TaskEditView(
                        viewModel: TaskEditViewModel(
                            relatedEvent: event
                        )
                    ),
                    tag: 1,
                    selection: $selection
                ) {
                    Button("Add new task") {
                        self.selection = 1
                    }
                    .buttonStyle(PrimaryButton())
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
