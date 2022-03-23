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
    private var eventService: EventServiceProtocol
    private var memberService: MemberServiceProtocol
    private var cancellableSet: Set<AnyCancellable> = []
    
    @Published var isPresentingScanner: Bool = false
    @Published var isPresentingJoin: Bool = false
    @Published var events: [GetParicipatedEventsResponse] = []
    @Published var event: GetEventResponse?
    @Published var result: String = ""
    
    init() {
        eventService = EventService()
        memberService = MemberService()
    }
    
    func handleScan(result: Result<ScanResult, ScanError>) {
        isPresentingScanner = false
        switch result {
        case .success(let result):
            self.result = result.string
            if let url = URL(string: result.string) {
                UIApplication.shared.open(url)
            }
            
        case .failure(let error):
            self.result = error.localizedDescription
        }
    }
    
    func fetchParticipatedEvents() {
        eventService.getParicipationEvents()
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    let myErrorResult = error as? MyError
                    print(error)
                    
                case .finished: print("Publisher is finished")
                }
            }, receiveValue: { [weak self] response in
                self?.events = response
                print(self?.events)
            })
            .store(in: &cancellableSet)
    }
    
    func showJoinMenu(id: Int) {
        eventService.getEvent(id)
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    let myErrorResult = error as? MyError
                    print(error)
                    
                case .finished: print("Publisher is finished")
                }
            }, receiveValue: { [weak self] response in
                self?.event = response
                self?.isPresentingJoin = true
                
            })
            .store(in: &cancellableSet)
    }
    
    func joinEvent() {
        if let id = event?.eventId {
            memberService.addMember(to: id)
                .receive(on: RunLoop.main)
                .sink(receiveCompletion: { completion in
                    switch completion {
                    case .failure(let error):
                        let myErrorResult = error as? MyError
                        print(error)
                        
                    case .finished: print("Publisher is finished")
                    }
                }, receiveValue: { [weak self] response in
                    print("success")
                    self?.isPresentingJoin = false
                })
                .store(in: &cancellableSet)
        }
    }
}
