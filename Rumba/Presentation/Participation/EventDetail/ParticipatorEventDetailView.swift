//
//  ParticipatorEventDetailView.swift
//  Rumba
//
//  Created by Vladislav Shchukin on 04.04.2022.
//

import SwiftUI

struct ParticipatorEventDetailView: View {
    let event: Event
    let myTask: Task?
    let image: UIImage
    let onShare: () -> ()
    let onLeaveEvent: () -> ()
    
    var body: some View {
        ScrollView {
            VStack {
                EventDetailView(
                    event: event,
                    image: image,
                    shareAction: onShare
                )
                TitleView(text: "My task")
                if let myTask = myTask {
                    TaskCardView(
                        task: myTask,
                        event: event,
                        manageMode: false,
                        showAssignButton: false
                    )
                }
                else {
                    Text("You need to select a task.")
                        .foregroundColor(.yellow)
                        .frame(
                            maxWidth: .infinity,
                            alignment: .topLeading
                        )
                }
                TitleView(text: "All tasks")
                TasksListView(
                    tasks: event.tasks ?? [],
                    event: event,
                    showEdit: false,
                    showAssignButton: true
                )
                Button("Leave event") {
                    onLeaveEvent()
                }
                .buttonStyle(PrimaryButton(color: .red))
            }
            .padding()
        }
    }
}

struct ParticipatorEventDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ParticipatorEventDetailView(
            event: DummyData.event,
            myTask: DummyData.task,
            image: UIImage(systemName: "qrcode")!,
            onShare: {},
            onLeaveEvent: {}
        )
    }
}
