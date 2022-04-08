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
        ForEach(tasks, id: \.taskId) { task in
            TaskCardView(task: task, event: event, manageMode: showEdit)
                .padding(.bottom)
        }
    }
}

struct TaskEditListView_Previews: PreviewProvider {
    static var previews: some View {
        TasksListView(
            tasks: [DummyData.task],
            event: DummyData.event,
            showEdit: true
        )
    }
}
