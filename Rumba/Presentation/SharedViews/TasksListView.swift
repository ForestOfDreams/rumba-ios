//
//  TaskEditListView.swift
//  Rumba
//
//  Created by Vladislav Shchukin on 01.04.2022.
//

import SwiftUI

struct TasksListView: View {
    var tasks: [Task]
    var event: Event
    var showEdit: Bool
    
    var body: some View {
        VStack {
            Text("Tasks")
                .font(.title)
                .padding(.bottom, -10)
        }
        .frame(
            maxWidth: .infinity,
            alignment: .topLeading
        )
        ForEach(tasks, id: \.taskId) { task in
            TaskCardView(task: task, event: event, showEdit: showEdit)
        }
    }
}

struct TaskEditListView_Previews: PreviewProvider {
    static var previews: some View {
        TasksListView(
            tasks: [DummyData.task],
            event: Event(
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
            ),
            showEdit: true
        )
    }
}
