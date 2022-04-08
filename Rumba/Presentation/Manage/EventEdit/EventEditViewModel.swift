//
//  CreateEventViewModel.swift
//  Rumba
//
//  Created by Vladislav Shchukin on 26.03.2022.
//

import Foundation
import Combine

class EventEditViewModel: ObservableObject {
    private var eventService: EventApiServiceProtocol
    private var cancellableSet: Set<AnyCancellable> = []
    
    @Published var isFormValid: Bool = false
    @Published var dateErrorMessages: Set<String> = Set<String>()
    @Published var mainErrorMessages: Set<String> = Set<String>()
    @Published var locationErrorMessages: Set<String> = Set<String>()
    
    @Published var shouldCloseView: Bool = false
    @Published var isEditMode: Bool = false
    
    @Published var title: String = ""
    @Published var description: String = ""
    @Published var type: EventType = .offline
    @Published var isCancelled: Bool?
    @Published var isRescheduled: Bool?
    @Published var latitude: Double?
    @Published var longitude: Double?
    @Published var placeName: String?
    @Published var startDate: Date = Date()
    @Published var endDate: Date = Date()
    
    var editingEventId: Int?
    
    private var event: EventForm {
        return EventForm(
            title: title,
            description: description,
            isOnline: type == EventType.online ? true : false,
            isCancelled: isCancelled,
            isRescheduled: isRescheduled,
            latitude: latitude,
            longitude: longitude,
            placeName: placeName,
            startDate: startDate,
            endDate: endDate
        )
    }
    
    init(editingEventId: Int? = nil) {
        //        self.objectWillChange.send()
        eventService = EventApiService()
        if let editingEventId = editingEventId {
            self.isEditMode = true
            self.editingEventId = editingEventId
            fetchEditingEvent()
        }
        setUpSubscribers()
    }
    
    deinit {
        print("DEINIT")
    }
    
    private func setUpSubscribers() {
        isFormValidPublisher
            .receive(on: RunLoop.main)
            .sink(receiveValue: { [weak self] isValid in
                self?.isFormValid = isValid
            })
            .store(in: &cancellableSet)
        
        isTitleLongEnoughPublisher
            .dropFirst()
            .receive(on: RunLoop.main)
            .sink(receiveValue: { [weak self] isValid in
                if !isValid {
                    self?.mainErrorMessages.insert(EventMainErrorMessage.titleTooShort.rawValue)
                }
                else {
                    self?.mainErrorMessages.remove(EventMainErrorMessage.titleTooShort.rawValue)
                }
            })
            .store(in: &cancellableSet)
        
        isTitleShortEnoughPublisher
            .dropFirst()
            .receive(on: RunLoop.main)
            .sink(receiveValue: { [weak self] isValid in
                if !isValid {
                    self?.mainErrorMessages.insert(EventMainErrorMessage.titleTooLong.rawValue)
                }
                else {
                    self?.mainErrorMessages.remove(EventMainErrorMessage.titleTooLong.rawValue)
                }
            })
            .store(in: &cancellableSet)
        
        isDescriptionLongEnoughPublisher
            .dropFirst()
            .receive(on: RunLoop.main)
            .sink(receiveValue: { [weak self] isValid in
                if !isValid {
                    self?.mainErrorMessages.insert(EventMainErrorMessage.descriptionTooShort.rawValue)
                }
                else {
                    self?.mainErrorMessages.remove(EventMainErrorMessage.descriptionTooShort.rawValue)
                }
            })
            .store(in: &cancellableSet)
        
        isLocationValidPublisher
            .dropFirst()
            .receive(on: RunLoop.main)
            .sink(receiveValue: { [weak self] isValid in
                if !isValid {
                    self?.locationErrorMessages.insert(EventLocationErrorMessage.locationIsEmpty.rawValue)
                }
                else {
                    self?.locationErrorMessages.remove(EventLocationErrorMessage.locationIsEmpty.rawValue)
                }
            })
            .store(in: &cancellableSet)
        
        isStartDateNotPastPublisher
            .dropFirst()
            .receive(on: RunLoop.main)
            .sink(receiveValue: { [weak self] isValid in
                if !isValid {
                    self?.dateErrorMessages.insert(EventDateErrorMessage.startDateInPast.rawValue)
                }
                else {
                    self?.dateErrorMessages.remove(EventDateErrorMessage.startDateInPast.rawValue)
                }
            })
            .store(in: &cancellableSet)
        
        isEndDateNotPastPublisher
            .dropFirst()
            .receive(on: RunLoop.main)
            .sink(receiveValue: { [weak self] isValid in
                if !isValid {
                    self?.dateErrorMessages.insert(EventDateErrorMessage.endDateInPast.rawValue)
                }
                else {
                    self?.dateErrorMessages.remove(EventDateErrorMessage.endDateInPast.rawValue)
                }
            })
            .store(in: &cancellableSet)
        
        isEndDateBiggerThanStartDatePublisher
            .dropFirst()
            .receive(on: RunLoop.main)
            .sink(receiveValue: { [weak self] isValid in
                if !isValid {
                    self?.dateErrorMessages.insert(EventDateErrorMessage.endDateEarlierThanStartDate.rawValue)
                }
                else {
                    self?.dateErrorMessages.remove(EventDateErrorMessage.endDateEarlierThanStartDate.rawValue)
                }
            })
            .store(in: &cancellableSet)
    }
    
    func fetchEditingEvent() {
        eventService.getEvent(editingEventId!)
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    let myErrorResult = error as? MyError
                    print(error)
                case .finished: print("Publisher is finished")
                }
            }, receiveValue: { [weak self] response in
                self?.title = response.title
                self?.description = response.description
                self?.type = response.isOnline ? .online : .offline
                self?.isCancelled = response.isCancelled
                self?.isRescheduled = response.isRescheduled
                self?.placeName = response.placeName
                self?.latitude = response.latitude
                self?.longitude = response.longitude
                self?.startDate = response.startDate
                self?.endDate = response.endDate
            })
            .store(in: &cancellableSet)
    }
    
    func updateEvent() {
        eventService.updateEvent(eventId: editingEventId!, event: event)
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    let myErrorResult = error as? MyError
                    print(myErrorResult)
                case .finished: print("Publisher is finished")
                }
            }, receiveValue: { [weak self] (response:Data) in
                self?.shouldCloseView = true
            })
            .store(in: &cancellableSet)
    }
    
    func createEvent() {
        eventService.createEvent(event)
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
        isEditMode ? updateEvent() : createEvent()
    }
}

extension EventEditViewModel {
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
    
    private var isLocationValidPublisher: AnyPublisher<Bool, Never> {
        Publishers.CombineLatest3($type.removeDuplicates(), $latitude.removeDuplicates(), $longitude.removeDuplicates())
            .debounce(for: 0.8, scheduler: RunLoop.main)
            .map { type, latitude, longitude in
                return type == .online || ((latitude != nil) && (longitude != nil))
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
    
    private var isTitleValidPublisher: AnyPublisher<Bool, Never> {
        Publishers.CombineLatest(isTitleLongEnoughPublisher,
                                 isTitleShortEnoughPublisher
        )
        .debounce(for: 0.8, scheduler: RunLoop.main)
        .map { isTitleLongEnough, isTitleShortEnough in
            return isTitleLongEnough && isTitleShortEnough
        }
        .eraseToAnyPublisher()
    }
    
    private var isDateValidPublisher: AnyPublisher<Bool, Never> {
        Publishers.CombineLatest3(isStartDateNotPastPublisher,
                                  isEndDateNotPastPublisher,
                                  isEndDateBiggerThanStartDatePublisher
        )
        .debounce(for: 0.8, scheduler: RunLoop.main)
        .map { isStartDateValid, isEndDateValid, isEndDateBiggerThanStartDate in
            return isEndDateValid && isEndDateValid && isEndDateBiggerThanStartDate
        }
        .eraseToAnyPublisher()
    }
    
    private var isFormValidPublisher: AnyPublisher<Bool, Never> {
        Publishers.CombineLatest4(isTitleValidPublisher,
                                  isDescriptionLongEnoughPublisher,
                                  isLocationValidPublisher,
                                  isDateValidPublisher
        )
        .map { isTitleValid, isDescriptionValid, isLocationValid, isDateValid in
            return isTitleValid && isDescriptionValid && isLocationValid && isDateValid
        }
        .eraseToAnyPublisher()
    }
}

extension EventEditViewModel {
    enum EventType: String {
        case online = "Online"
        case offline = "Offline"
    }
}


extension EventEditViewModel {
    enum EventDateErrorMessage: String {
        case startDateInPast = "Start time cannot be in the past."
        case endDateInPast = "End time cannot be in the past."
        case endDateEarlierThanStartDate = "The end time cannot be earlier than the start time."
    }

    enum EventMainErrorMessage: String {
        case titleTooShort = "Title must contain at least 4 characters."
        case titleTooLong = "Title must be less than 40 characters."
        case descriptionTooShort = "Description must contain at least 4 characters."
    }

    enum EventLocationErrorMessage: String {
        case locationIsEmpty = "Location must not be empty for offline event."
    }
}
