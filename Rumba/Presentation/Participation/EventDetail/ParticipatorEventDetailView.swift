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
                VStack {
                    Text("My task")
                        .font(.title)
                        .padding(.top, 10)
                }
                .frame(
                    maxWidth: .infinity,
                    alignment: .topLeading
                )
                if let myTask = myTask {
                    TaskCardView(
                        task: myTask,
                        event: event,
                        manageMode: false
                    )
                }
                else {
                    Text("You need to select a task.")
                        .frame(
                            maxWidth: .infinity,
                            alignment: .topLeading
                        )
                }
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
                    showEdit: false
                )
//                Button(myTask == nil ? "Choose task" : "Choose another task") {
//                    onLeaveEvent()
//                }
//                .buttonStyle(PrimaryButton())
//                .padding()
                
                Button("Leave event") {
                    onLeaveEvent()
                }
                .buttonStyle(PrimaryButton())
                .padding()

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
