//
//  TaskPickerViewModel.swift
//  Rumba
//
//  Created by Vladislav Shchukin on 31.03.2022.
//

import Foundation
import Combine

class TaskEditViewModel: ObservableObject {
    private var taskService: TaskApiServiceProtocol
    private var cancellableSet: [AnyCancellable] = []
    
    @Published var title: String = ""
    @Published var description: String = ""
    @Published var membersCount: Int = 1
    @Published var startDate: Date = Date()
    @Published var endDate: Date = Date()
    @Published var isFormValid: Bool = true
    
    @Published var isEditMode: Bool = false
    var eventId: Int
    var editingTask: Task?
    
    @Published var shouldCloseView: Bool = false
    
    init(eventId: Int, editingTask: Task? = nil) {
        //        self.objectWillChange.send()
        taskService = TaskAPIService()
        self.eventId = eventId
        if let task = editingTask {
            self.editingTask = editingTask
            self.isEditMode = true
            title = task.title
            description = task.description
            membersCount = task.membersCount
            startDate = task.startDate
            endDate = task.endDate
        }
    }
    
    func updateTask() {
        if let editingTask = editingTask {
            taskService.updateTask(
                taskId: editingTask.taskId,
                task: TaskForm(taskId: editingTask.taskId,
                               title: title,
                               description: description,
                               membersCount: membersCount,
                               startDate: startDate,
                               endDate: endDate)
            )
                .receive(on: RunLoop.main)
                .sink(receiveCompletion: { completion in
                    switch completion {
                    case .failure(let error):
                        let myErrorResult = error as? MyError
                        print(myErrorResult)
                    case .finished: print("Publisher is finished")
                    }
                }, receiveValue: { [weak self] (response:Data) in
                    print(response)
                    self?.shouldCloseView = true
                })
                .store(in: &cancellableSet)
        }
    }
    
    func createTask() {
        taskService.createTask(
            task: TaskForm(title: title,
                           description: description,
                           membersCount: membersCount,
                           startDate: startDate,
                           endDate: endDate
                          ),
            eventId: eventId
        )
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    let myErrorResult = error as? MyError
                    print(myErrorResult)
                case .finished: print("Publisher is finished")
                }
            }, receiveValue: { [weak self] (response:Data) in
                print(response)
                self?.shouldCloseView = true
            })
            .store(in: &cancellableSet)
    }
    
    func onSave() {
        if (isEditMode) {
            updateTask()
        }
        else {
            createTask()
        }
    }
    
    func onRemove() {
        
    }
}
