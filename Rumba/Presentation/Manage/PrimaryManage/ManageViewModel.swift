//
//  ManageViewModel.swift
//  Rumba
//
//  Created by Vladislav Shchukin on 24.03.2022.
//

import Foundation
import Combine

class ManageViewModel : ObservableObject {
    private var eventService: EventApiServiceProtocol
    private var cancellableSet: [AnyCancellable] = []
    
    var events: [Event] = []
    
    @Published var filteredEvents: [Event] = []
    
    @Published var searchText: String = ""
    // Зависиимость с другого пакета
    @Published var filterType: FilterType = .all
    
    
    // Если после фильтрации вызвать эту функцию, то фильтрация теряется ????
    func fetchCreatedEvents() {
        eventService.getCreatedEvents()
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    let myErrorResult = error as? MyError
                    print(myErrorResult)
                case .finished: print("Publisher is finished")
                }
            }, receiveValue: { [weak self] response in
                self?.events = response
                self?.filteredEvents = response
            })
            .store(in: &cancellableSet)
    }
    
    init() {
        eventService = EventApiService()
        fetchCreatedEvents()
        
        // Можно вынести ???
        Publishers.CombineLatest($searchText, $filterType)
            .receive(on: RunLoop.main)
            .sink {[weak self] searchText, filterType  in
                guard let self = self else { return }
                if !searchText.isEmpty {
                    self.filteredEvents = self.events.filter({ event in
                        return event.title.contains(searchText.lowercased())
                    })
                }
                else {
                    self.filteredEvents = self.events
                }
                switch filterType {
                case .all:
                    self.filteredEvents = self.filteredEvents
                case .past:
                    self.filteredEvents = self.filteredEvents.filter {$0.startDate <= Date.now}
                case .future:
                    self.filteredEvents = self.filteredEvents.filter {$0.startDate > Date.now}
                }
            }
            .store(in: &cancellableSet)
    }
}
