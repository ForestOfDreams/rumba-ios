//
//  ChooseTaskViewModel.swift
//  Rumba
//
//  Created by Vladislav Shchukin on 28.03.2022.
//

import Foundation
import Combine

class ChooseTaskViewModel: ObservableObject {
    var task: Task
    
    @Published var startDate: Date = Date()
    @Published var endDate: Date = Date()
    @Published var resultMessage: String = ""
    @Published var isFormValid: Bool = false
    
    @Published var shouldCloseView: Bool = false
    
    @Published var alertMessages: [String] = []
    @Published var showAlert: Bool = false
    
    private var cancellableSet: [AnyCancellable] = []
    
    private var memberService: MemberApiServiceProtocol
    
    var localizedStartDate: String {
        dateFormater.string(from: task.startDate)
    }
    
    var localizedEndDate: String {
        dateFormater.string(from: task.endDate)
    }
    
    private var dateFormater: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter
    }
    
    init(task: Task) {
        memberService = MemberApiService()
        self.task = task
        
        Publishers.CombineLatest($startDate, $endDate)
            .receive(on: RunLoop.main)
            .sink { [weak self] startDate, endDate in
                self?.tryAssign()
            }
            .store(in: &cancellableSet)
        
        $isFormValid
            .receive(on: RunLoop.main)
            .dropFirst()
            .sink { [weak self] isFormValid in
                self?.resultMessage = isFormValid ? "choose-task-success-status" :
                "choose-task-success-status"
            }
            .store(in: &cancellableSet)
    }
    
    func tryAssign() {
        memberService.tryAssignMemberToTask(
            taskID: task.taskId,
            form: AssignMemberToTaskForm(
                startDate: startDate,
                endDate: endDate
            )
        )
        .receive(on: RunLoop.main)
        .sink(receiveCompletion: { completion in
            switch completion {
            case .failure(let error):
                if let myErrorResult = error as? ApiError {
                    self.alertMessages = myErrorResult.messages
                    self.showAlert = true
                }
            default: break
            }
        }, receiveValue: { [weak self] response in
            self?.isFormValid = response
        })
        .store(in: &cancellableSet)
    }
    
    func assign() {
        memberService.assignMemberToTask(
            taskID: task.taskId,
            form: AssignMemberToTaskForm(
                startDate: startDate,
                endDate: endDate
            )
        )
        .receive(on: RunLoop.main)
        .sink(receiveCompletion: { completion in
            switch completion {
            case .failure(let error):
                if let myErrorResult = error as? ApiError {
                    self.alertMessages = myErrorResult.messages
                    self.showAlert = true
                }
            default: break
            }
        }, receiveValue: { [weak self] response in
            self?.shouldCloseView = true
        })
        .store(in: &cancellableSet)
    }
}
