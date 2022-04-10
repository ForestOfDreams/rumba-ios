//
//  JoinEventViewModel.swift
//  Rumba
//
//  Created by Vladislav Shchukin on 27.03.2022.
//

import Foundation
import Combine

class JoinEventViewModel: ObservableObject {
    @Published var event: Event?
    
    @Published var shouldCloseView: Bool = false
    
    var eventId: Int
    private var memberService: MemberApiServiceProtocol
    private var eventService: EventApiService
    private var cancellableSet: [AnyCancellable] = []
    
    @Published var alertMessages: [String] = []
    @Published var showAlert: Bool = false
    
    init(eventId:Int) {
        self.eventId = eventId
        memberService = MemberApiService()
        eventService = EventApiService()
        fetchEvent(id: eventId)
    }
    
    func fetchEvent(id: Int) {
        eventService.getEvent(id)
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
            }, receiveValue: { [weak self] response in
                self?.event = response
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
                        if let myErrorResult = error as? MyError {
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
}
