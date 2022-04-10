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
    @Published var dateErrorMessages: Set<String> = Set<String>()
    @Published var mainErrorMessages: Set<String> = Set<String>()
    
    @Published var isEditMode: Bool = false
    @Published var relatedEvent: Event
    
    @Published var alertMessages: [String] = []
    @Published var showAlert: Bool = false
    
    var editingTask: Task?
    
    @Published var shouldCloseView: Bool = false
    
    private var task: TaskForm {
        return TaskForm(
            title: title,
            description: description,
            membersCount: membersCount,
            startDate: startDate,
            endDate: endDate
        )
    }
    
    init(relatedEvent: Event, editingTask: Task? = nil) {
        //        self.objectWillChange.send()
        taskService = TaskAPIService()
        self.relatedEvent = relatedEvent
        
        if let task = editingTask {
            self.editingTask = editingTask
            self.isEditMode = true
            title = task.title
            description = task.description
            membersCount = task.membersCount
            startDate = task.startDate
            endDate = task.endDate
        }
        setUpSubscribers()
    }
    
    func updateTask() {
        if let editingTask = editingTask {
            taskService.updateTask(
                taskId: editingTask.taskId,
                task: task
            )
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    if let myErrorResult = error as? MyError {
                        self.alertMessages = myErrorResult.messages
                        self.showAlert = true
                    }
                default: break
                }
            }, receiveValue: { [weak self] (response:Data) in
                self?.shouldCloseView = true
            })
            .store(in: &cancellableSet)
        }
    }
    
    func createTask() {
        taskService.createTask(
            task: task,
            eventId: relatedEvent.eventId
        )
        .receive(on: RunLoop.main)
        .sink(receiveCompletion: { completion in
            switch completion {
            case .failure(let error):
                if let myErrorResult = error as? MyError {
                    self.alertMessages = myErrorResult.messages
                    self.showAlert = true
                }
            default: break
            }
        }, receiveValue: { [weak self] (response:Data) in
            self?.shouldCloseView = true
        })
        .store(in: &cancellableSet)
    }
    
    func deleteTask() {
        if let id = editingTask?.taskId {
            taskService.deleteTask(taskId: id)
                .receive(on: RunLoop.main)
                .sink(receiveCompletion: { completion in
                    switch completion {
                    case .failure(let error):
                        if let myErrorResult = error as? MyError {
                            self.alertMessages = myErrorResult.messages
                            self.showAlert = true
                        }
                    default: break
                    }
                }, receiveValue: { [weak self] (response:Data) in
                    self?.shouldCloseView = true
                })
                .store(in: &cancellableSet)
        }
    }
    
    func onSave() {
        isEditMode ? updateTask() : createTask()
    }
}


extension TaskEditViewModel {
    private var isTitleLongEnoughPublisher: AnyPublisher<Bool, Never> {
        $title
            .debounce(for: 0.8, scheduler: RunLoop.main)
            .removeDuplicates()
            .map { title in
                return title.count >= 4
            }
            .eraseToAnyPublisher()
    }
    
    private var isTitleShortEnoughPublisher: AnyPublisher<Bool, Never> {
        $title
            .debounce(for: 0.8, scheduler: RunLoop.main)
            .removeDuplicates()
            .map { title in
                return title.count < 40
            }
            .eraseToAnyPublisher()
    }
    
    private var isDescriptionLongEnoughPublisher: AnyPublisher<Bool, Never> {
        $description
            .debounce(for: 0.8, scheduler: RunLoop.main)
            .removeDuplicates()
            .map { description in
                return description.count >= 3
            }
            .eraseToAnyPublisher()
    }
    
    private var isStartDateNotPastPublisher: AnyPublisher<Bool, Never> {
        $startDate
            .debounce(for: 0.8, scheduler: RunLoop.main)
            .map { startDate in
                return startDate > Date.now
            }
            .eraseToAnyPublisher()
    }
    
    private var isEndDateNotPastPublisher: AnyPublisher<Bool, Never> {
        $endDate
            .debounce(for: 0.8, scheduler: RunLoop.main)
            .map { endDate in
                return endDate > Date.now
            }
            .eraseToAnyPublisher()
    }
    
    private var isEndDateBiggerThanStartDatePublisher: AnyPublisher<Bool, Never> {
        Publishers.CombineLatest($endDate, $startDate)
            .debounce(for: 0.8, scheduler: RunLoop.main)
            .map { endDate, startDate in
                return endDate > startDate
            }
            .eraseToAnyPublisher()
    }
    // ???
    private var isStartDateNotEarlierEventStartDatePublisher: AnyPublisher<Bool, Never> {
        $startDate
            .debounce(for: 0.8, scheduler: RunLoop.main)
            .map { startDate in
                return startDate > self.relatedEvent.startDate
            }
            .eraseToAnyPublisher()
    }
    // ???
    private var isEndDateNotAfterEventEndDatePublisher: AnyPublisher<Bool, Never> {
        Publishers.CombineLatest($endDate, $relatedEvent)
            .debounce(for: 0.8, scheduler: RunLoop.main)
            .map { endDate, relatedEvent in
                return endDate < relatedEvent.endDate
            }
            .eraseToAnyPublisher()
    }
    
    private var isTitleValidPublisher: AnyPublisher<Bool, Never> {
        Publishers.CombineLatest(isTitleLongEnoughPublisher, isTitleShortEnoughPublisher)
            .debounce(for: 0.8, scheduler: RunLoop.main)
            .map { isTitleLongEnough, isTitleShortEnough in
                return isTitleLongEnough && isTitleShortEnough
            }
            .eraseToAnyPublisher()
    }
    
    private var isStartDateValidPublisher: AnyPublisher<Bool, Never> {
        Publishers.CombineLatest(isStartDateNotPastPublisher,
                                 isStartDateNotEarlierEventStartDatePublisher
        )
        .debounce(for: 0.8, scheduler: RunLoop.main)
        .map { isStartDateNotPast, isStartDateNotEarlierEventStartDate in
            return isStartDateNotPast && isStartDateNotEarlierEventStartDate
        }
        .eraseToAnyPublisher()
    }
    
    private var isEndDateValidPublisher: AnyPublisher<Bool, Never> {
        Publishers.CombineLatest(isStartDateNotPastPublisher,
                                 isStartDateNotEarlierEventStartDatePublisher
        )
        .debounce(for: 0.8, scheduler: RunLoop.main)
        .map { isStartDateNotPast, isStartDateNotEarlierEventStartDate in
            return isStartDateNotPast && isStartDateNotEarlierEventStartDate
        }
        .eraseToAnyPublisher()
    }
    
    private var isDateValidPublisher: AnyPublisher<Bool, Never> {
        Publishers.CombineLatest(isStartDateValidPublisher,
                                 isEndDateValidPublisher
        )
        .debounce(for: 0.8, scheduler: RunLoop.main)
        .map { isStartDateValid, isEndDateValid in
            return isStartDateValid && isEndDateValid
        }
        .eraseToAnyPublisher()
    }
    
    private var isFormValidPublisher: AnyPublisher<Bool, Never> {
        Publishers.CombineLatest3(isTitleValidPublisher, isDescriptionLongEnoughPublisher, isDateValidPublisher)
            .map { isTitleValid, isDescriptionValid, isDateValid in
                return isTitleValid && isDescriptionValid && isDateValid
            }
            .eraseToAnyPublisher()
    }
    
    func setUpSubscribers() {
        isFormValidPublisher
            .receive(on: RunLoop.main)
            .assign(to: \.isFormValid, on:self)
            .store(in: &cancellableSet)
        
        isTitleLongEnoughPublisher
            .dropFirst()
            .receive(on: RunLoop.main)
            .sink(receiveValue: { isValid in
                if !isValid {
                    self.mainErrorMessages.insert(TaskMainErrorMessage.titleTooShort.rawValue)
                }
                else {
                    self.mainErrorMessages.remove(TaskMainErrorMessage.titleTooShort.rawValue)
                }
            })
            .store(in: &cancellableSet)
        
        isTitleShortEnoughPublisher
            .dropFirst()
            .receive(on: RunLoop.main)
            .sink(receiveValue: { isValid in
                if !isValid {
                    self.mainErrorMessages.insert(TaskMainErrorMessage.titleTooLong.rawValue)
                }
                else {
                    self.mainErrorMessages.remove(TaskMainErrorMessage.titleTooLong.rawValue)
                }
            })
            .store(in: &cancellableSet)
        
        isDescriptionLongEnoughPublisher
            .dropFirst()
            .receive(on: RunLoop.main)
            .sink(receiveValue: { isValid in
                if !isValid {
                    self.mainErrorMessages.insert(TaskMainErrorMessage.descriptionTooShort.rawValue)
                }
                else {
                    self.mainErrorMessages.remove(TaskMainErrorMessage.descriptionTooShort.rawValue)
                }
            })
            .store(in: &cancellableSet)
        
        isStartDateNotPastPublisher
            .dropFirst()
            .receive(on: RunLoop.main)
            .sink(receiveValue: { isValid in
                if !isValid {
                    self.dateErrorMessages.insert(TaskDateErrorMessage.startDateInPast.rawValue)
                }
                else {
                    self.dateErrorMessages.remove(TaskDateErrorMessage.startDateInPast.rawValue)
                }
            })
            .store(in: &cancellableSet)
        
        isEndDateNotPastPublisher
            .dropFirst()
            .receive(on: RunLoop.main)
            .sink(receiveValue: { isValid in
                if !isValid {
                    self.dateErrorMessages.insert(TaskDateErrorMessage.endDateInPast.rawValue)
                }
                else {
                    self.dateErrorMessages.remove(TaskDateErrorMessage.endDateInPast.rawValue)
                }
            })
            .store(in: &cancellableSet)
        
        isEndDateBiggerThanStartDatePublisher
            .dropFirst()
            .receive(on: RunLoop.main)
            .sink(receiveValue: { isValid in
                if !isValid {
                    self.dateErrorMessages.insert(TaskDateErrorMessage.endDateEarlierThanStartDate.rawValue)
                }
                else {
                    self.dateErrorMessages.remove(TaskDateErrorMessage.endDateEarlierThanStartDate.rawValue)
                }
            })
            .store(in: &cancellableSet)
        
        isStartDateNotEarlierEventStartDatePublisher
            .dropFirst()
            .receive(on: RunLoop.main)
            .sink(receiveValue: { isValid in
                if !isValid {
                    self.dateErrorMessages.insert(TaskDateErrorMessage.startDateEarlierThanEventStartDate.rawValue)
                }
                else {
                    self.dateErrorMessages.remove(TaskDateErrorMessage.startDateInPast.rawValue)
                }
            })
            .store(in: &cancellableSet)
        
        isEndDateNotAfterEventEndDatePublisher
            .dropFirst()
            .receive(on: RunLoop.main)
            .sink(receiveValue: { isValid in
                if !isValid {
                    self.dateErrorMessages.insert(TaskDateErrorMessage.endDateLaterThanEventEndDate.rawValue)
                }
                else {
                    self.dateErrorMessages.remove(TaskDateErrorMessage.endDateLaterThanEventEndDate.rawValue)
                }
            })
            .store(in: &cancellableSet)
    }
}

enum TaskDateErrorMessage: String {
    case startDateInPast = "The start time cannot be in the past."
    case endDateInPast = "The end time cannot be in the past."
    case endDateEarlierThanStartDate = "The end time cannot be earlier than the start time."
    case startDateEarlierThanEventStartDate = "The start time cannot be earlier than the start time of the event."
    case endDateLaterThanEventEndDate = "The end time cannot be later than the end time of the event."
}

enum TaskMainErrorMessage: String {
    case titleTooShort = "Title must contain at least 4 characters."
    case titleTooLong = "Title must be less than 40 characters."
    case descriptionTooShort = "Description must contain at least 4 characters."
}
