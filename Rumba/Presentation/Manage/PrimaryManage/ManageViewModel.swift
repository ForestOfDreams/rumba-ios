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
    @Published var filterType: FilterType = .all
    
    @Published var alertMessages: [String] = []
    @Published var showAlert: Bool = false
    
    func fetchCreatedEvents() {
        eventService.getCreatedEvents()
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
                self?.events = response
                self?.filteredEvents = response
            })
            .store(in: &cancellableSet)
    }
    
    init() {
        eventService = EventApiService()
        fetchCreatedEvents()
        
        Publishers.CombineLatest($searchText, $filterType)
            .receive(on: RunLoop.main)
            .sink {[weak self] searchText, filterType  in
                guard let self = self else { return }
                if !searchText.isEmpty {
                    self.filteredEvents = self.events.filter({
                        $0.title.lowercased().contains(searchText.lowercased())
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
    
    func refreshFilters() {
        filterType = .all
        searchText = ""
    }
}
