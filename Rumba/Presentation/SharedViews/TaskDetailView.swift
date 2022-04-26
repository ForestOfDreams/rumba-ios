//
//  CreatorTaskCardView.swift
//  Rumba
//
//  Created by Vladislav Shchukin on 01.04.2022.
//

import SwiftUI

struct TaskDetailView: View {
    @Environment(\.colorScheme) var colorScheme
    
    let task: Task
    let event: Event
    let manageMode: Bool
    let showAssignButton: Bool
    
    @State var showAssignView: Bool = false
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                VStack(alignment: .leading) {
                    Text(task.title)
                        .font(.title)
                    Text("task-required-member-counts \(task.membersCount)")
                }
                Spacer()
                if manageMode {
                    NavigationLink(
                        destination:
                            TaskEditScreen(
                                viewModal: TaskEditViewModel(
                                    relatedEvent: event,
                                    editingTask: task
                                ), editMode: true
                            )
                    ) {
                        Text("edit-button")
                    }
                }
                if showAssignButton {
                    Button {
                        showAssignView = true
                    } label: {
                        Text("choose-task-btn")
                    }
                }
            }
            Divider()
            TaskDescriptionSectionView(description: task.description)
            Divider()
            TaskTimeSectionView(task: task)
            Divider()
            TaskMembersSectionView(task: task)
        }
        .sheet(isPresented: $showAssignView) {
            ChooseTaskScreen(viewModel: ChooseTaskViewModel(task: task))
        }
        .padding()
        .background(
            (colorScheme == .light ?
             Color.white : Color(red: 40/255, green: 40/255, blue: 40/255))
            .cornerRadius(10)
            .shadow(radius: 4)
        )
    }
}

struct TaskCardView_Previews: PreviewProvider {
    static var previews: some View {
        TaskDetailView(
            task: DummyData().task, event: DummyData().event,
            manageMode: false, showAssignButton: true
        )
        .padding()
    }
}

struct TaskDescriptionSectionView: View {
    let description: String
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("description-title")
                    .font(.title2)
            }
            Text(description)
        }
        .frame(
            maxWidth: .infinity,
            alignment: .topLeading
        )
    }
}

struct TaskTimeSectionView: View {
    var task: Task
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("task-period-title")
                    .font(.title2)
            }
            Text("task-start-time \(HumanReadableDateFormatter().localizedDate(task.startDate))")
            Text("task-end-time \(HumanReadableDateFormatter().localizedDate(task.endDate))")
        }
        .frame(
            maxWidth: .infinity,
            alignment: .topLeading
        )
    }
}

struct TaskMembersSectionView: View {
    @State var showMembers: Bool = false
    var task: Task
    
    var body: some View {
        VStack(alignment: .leading) {
            VStack(alignment: .leading) {
                Text("members-title")
                    .font(.title2)
                HStack {
                    switch task.members.count {
                    case 0: Text("task-members-count-zero")
                    case 1: Text("task-members-count-one")
                    default: Text("task-members-count-lot \(task.members.count)")
                    }
                    if !task.members.isEmpty {
                        Button {
                            withAnimation {
                                showMembers.toggle()
                            }
                        } label: {
                            showMembers ?
                            Text("hide-members-btn") :
                            Text("show-members-btn")
                        }
                    }
                }
            }
            if showMembers {
                ForEach(task.members, id: \.memberId) { member in
                    Divider()
                    Text("\(member.member.firstName) \(member.member.lastName)")
                    Text("task-contact-email \(member.member.email)")
                    Text("task-contact-activity-time \(HumanReadableDateFormatter().localizedDate(member.startDate)) \(HumanReadableDateFormatter().localizedDate(member.endDate))")
                }
                .padding(.leading)
            }
        }
        .frame(
            maxWidth: .infinity,
            alignment: .topLeading
        )
    }
}

private func expandImage(imageName: String) -> some View {
    return Image(systemName: imageName)
        .resizable()
        .scaledToFit()
        .frame(width: 12)
}
