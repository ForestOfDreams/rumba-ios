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
    let QRImage: UIImage
    let onShare: () -> ()
    let onLeaveEvent: () -> ()
    
    var body: some View {
        ScrollView {
            VStack {
                EventDetailView(
                    event: event,
                    image: QRImage,
                    shareAction: onShare
                )
                OrganizerSectionView(organizer: event.creator!)
                MyTaskSectionView(myTask: myTask, event: event)
                AllTasksSectionView(event: event)
                Button("leave-event-btn") {
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
            event: DummyData().event,
            myTask: DummyData().task,
            QRImage: UIImage(systemName: "qrcode")!,
            onShare: {},
            onLeaveEvent: {}
        )
    }
}

struct MyTaskSectionView: View {
    let myTask: Task?
    let event: Event
    
    var body: some View {
        VStack {
            TitleView(text: "event-my-task-title")
            if let myTask = myTask {
                TaskDetailView(
                    task: myTask,
                    event: event,
                    manageMode: false,
                    showAssignButton: false
                )
            }
            else {
                Text("task-choose-required")
                    .foregroundColor(.yellow)
                    .frame(
                        maxWidth: .infinity,
                        alignment: .topLeading
                    )
            }
        }
    }
}

struct AllTasksSectionView: View {
    let event: Event
    
    var body: some View {
        VStack {
            TitleView(text: "all-tasks-title")
            if let tasks = event.tasks, tasks.count > 0 {
                TasksListView(
                    tasks: tasks,
                    event: event,
                    showEdit: false,
                    showAssignButton: true
                )
            }
            else {
                HStack {
                    Text("tasks-empty")
                        .foregroundColor(.yellow)
                    Spacer()
                }
                
            }
        }
    }
}

struct OrganizerSectionView: View {
    let organizer: Creator
    
    var body: some View {
        VStack {
            TitleView(text: "event-organizer-title")
            OrganizerDetailView(organizer: organizer)
        }
    }
}
