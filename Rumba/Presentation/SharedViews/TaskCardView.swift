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
    let showEdit: Bool
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(task.title)
                    .font(.title)
                Spacer()
                if showEdit {
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
            }
            TaskDetailSectionView(task: task)
            TaskDescriptionSectionView(task: task)
            TaskMembersSectionView(task: task)
            
        }
        .padding()
        .background(
            Color.white
                .cornerRadius(5)
                .shadow(radius: 5)
        )
    }
}

struct CreatorTaskCardView_Previews: PreviewProvider {
    static var previews: some View {
        CreatorTaskCardView(
            task: DummyData.task, event: Event(
                eventId: 1,
                title: "Уборка пляжа",
                description: "Необходимо очистить от мусора пляж лазурного озера",
                isOnline: false,
                isCancelled: false,
                isRescheduled: false,
                placeName: "Лазурное озеро",
                latitude: 60.886490560469504,
                longitude: 29.54654745624353,
                startDate: Date.now,
                endDate: Date.now,
                tasks: [],
                members: [],
                creator: Creator(
                    accountId: 1,
                    firstName: "Петр",
                    lastName: "Енотов",
                    email: "touch@gmail.com")
            )
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
