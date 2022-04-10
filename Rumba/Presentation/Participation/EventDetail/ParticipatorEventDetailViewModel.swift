//
//  EventDetailtViewModel.swift
//  Rumba
//
//  Created by Vladislav Shchukin on 01.04.2022.
//

import Foundation
import Combine
import SwiftUI

class ParticipatorEventDetailViewModel : ObservableObject {
    private var linkService: LinkServiceProtocol
    private var eventService: EventApiServiceProtocol
    private var taskService: TaskApiServiceProtocol
    private var memberService: MemberApiServiceProtocol
    private var cancellableSet: [AnyCancellable] = []
    
    @Published var image: UIImage = UIImage(systemName: "xmark")!
    
    @Published var event: Event?
    @Published var myTask: Task?
    
    @Published var shouldCloseView: Bool = false
    
    @Published var alertMessages: [String] = []
    @Published var showAlert: Bool = false
    
    let eventId: Int
    
    func fetchEvent() {
        eventService.getEvent(eventId)
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
                self?.event = response
            })
            .store(in: &cancellableSet)
    }
    
    func fetchMyTask() {
        taskService.getMyTask(eventId: eventId)
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
                self?.myTask = response
            })
            .store(in: &cancellableSet)
    }
    
    func leaveEvent() {
        memberService.leaveEvent(eventId)
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
    
    func generateQR(link: String) {
        self.image = linkService.generateQRCode(from: link) ?? UIImage(systemName: "xmark")!
    }
    
    init(eventId: Int) {
        linkService = LinkService()
        eventService = EventApiService()
        taskService = TaskAPIService()
        memberService = MemberApiService()
        self.eventId = eventId
        generateQR(link: "rumba-app.herokuapp.com://join?id=\(eventId)")
    }
}
