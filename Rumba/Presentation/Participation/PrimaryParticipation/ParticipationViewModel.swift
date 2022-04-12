//
//  ParticipationViewModel.swift
//  Rumba
//
//  Created by Vladislav Shchukin on 22.03.2022.
//

import Foundation
import CodeScanner
import Combine
import UIKit

class ParticipationViewModel: ObservableObject {
    private var eventService: EventApiServiceProtocol
    private var linkService: LinkServiceProtocol
    private var cancellableSet: Set<AnyCancellable> = []
    
    @Published var isPresentingScanner: Bool = false
    @Published var isPresentingJoin: Bool = false
    @Published var events: [Event] = []
    @Published var filteredEvents: [Event] = []
    
    @Published var searchText: String = ""
    @Published var filterType: FilterType = .all
    
    @Published var alertMessages: [String] = []
    @Published var showAlert: Bool = false
    
    var scanResult: String = ""
    var joinEventId: Int?
    
    init() {
        eventService = EventApiService()
        linkService = LinkService()
        
        fetchParticipatedEvents()
        
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
    
    func handleScan(result: Result<ScanResult, ScanError>) {
        isPresentingScanner = false
        switch result {
        case .success(let result):
            self.scanResult = result.string
            if let url = URL(string: result.string) {
                UIApplication.shared.open(url)
            }
            
        case .failure(let error):
            self.scanResult = error.localizedDescription
        }
    }
    
    func fetchParticipatedEvents() {
        eventService.getParicipatedEvents()
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
            }, receiveValue: { [weak self] (response:[Event]) in
                self?.events = response
                self?.filteredEvents = response
            })
            .store(in: &cancellableSet)
    }
    
    func refreshFilters() {
        filterType = .all
        searchText = ""
    }
    
    func openDeepLink(url: URL) {
        if let id = linkService.parseUrl(url: url) {
            joinEventId = id
            self.isPresentingJoin = true
        }
    }
}

enum FilterType: String, CaseIterable {
    case all = "filter-all-button"
    case past = "filter-past-button"
    case future = "filter-future-button"
}
