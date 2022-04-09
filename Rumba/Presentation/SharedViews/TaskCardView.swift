//
//  CreatorTaskCardView.swift
//  Rumba
//
//  Created by Vladislav Shchukin on 01.04.2022.
//

import SwiftUI

struct TaskCardView: View {
    let task: Task
    let event: Event
    let manageMode: Bool
    let showAssignButton: Bool
    
    @State var showAssignView: Bool = false
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(task.title)
                    .font(.title)
                Spacer()
                if manageMode {
                    NavigationLink(
                        destination: TaskEditView(
                            viewModel: TaskEditViewModel(
                                relatedEvent: event,
                                editingTask: task
                            )
                        )
                    ) {
                        Text("Edit")
                    }
                }
                if showAssignButton {
                    Button {
                        showAssignView = true
                    } label: {
                        Text("Choose task")
                    }
                }
            }
            TaskDetailSectionView(task: task)
            TaskDescriptionSectionView(task: task)
            TaskMembersSectionView(task: task)
        }
        .sheet(isPresented: $showAssignView) {
            ChooseTaskScreen(viewModel: ChooseTaskViewModel(taskId: task.taskId))
        }
        .padding()
        .background(
            Color.white
                .cornerRadius(5)
                .shadow(radius: 5)
        )
    }
}

struct TaskCardView_Previews: PreviewProvider {
    static var previews: some View {
        TaskCardView(
            task: DummyData.task, event: DummyData.event,
            manageMode: false, showAssignButton: true
        )
    }
}

struct TaskDescriptionSectionView: View {
    @State var showDescription: Bool = false
    var task: Task
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Description")
                    .font(.title2)
                Button {
                    withAnimation {
                        showDescription.toggle()
                    }
                } label: {
                    showDescription ?
                    expandImage(imageName: "arrow.up.to.line") :
                    expandImage(imageName: "arrow.down.to.line")
                }
            }
            if showDescription {
                Text(task.description)
            }
        }
        .frame(
            maxWidth: .infinity,
            alignment: .topLeading
        )
    }
}

struct TaskMembersSectionView: View {
    @State var showDescription: Bool = false
    var task: Task
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Members")
                    .font(.title2)
                Button {
                    withAnimation {
                        showDescription.toggle()
                    }
                } label: {
                    showDescription ?
                    expandImage(imageName: "arrow.up.to.line") :
                    expandImage(imageName: "arrow.down.to.line")
                }
            }
            if showDescription {
                ForEach(task.members, id: \.memberId) { member in
                    Text("First name: \(member.member.firstName)")
                    Text("First name: \(member.member.lastName)")
                    Text("Email: \(member.member.email)")
                    Text("Start date: \(member.startDate)")
                    Text("End date: \(member.endDate)")
                    Divider()
                }
            }
        }
        .frame(
            maxWidth: .infinity,
            alignment: .topLeading
        )
    }
}

struct TaskDetailSectionView: View {
    @State var showDescription: Bool = false
    var task: Task
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Details")
                    .font(.title2)
                Button {
                    withAnimation {
                        showDescription.toggle()
                    }
                } label: {
                    showDescription ?
                    expandImage(imageName: "arrow.up.to.line") :
                    expandImage(imageName: "arrow.down.to.line")
                }
            }
            if showDescription {
                Text("Maximum members: \(task.membersCount)")
                Text("Start date: \(task.startDate)")
                Text("Start date: \(task.endDate)")
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
