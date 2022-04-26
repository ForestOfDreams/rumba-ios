//
//  EventDetailtViewModel.swift
//  Rumba
//
//  Created by Vladislav Shchukin on 01.04.2022.
//

import Foundation
import Combine
import SwiftUI

class CreatorEventDetailViewModel : ObservableObject {
    private var linkService: LinkServiceProtocol
    private var eventService: EventApiServiceProtocol
    private var cancellableSet: [AnyCancellable] = []
    
    @Published var alertMessages: [String] = []
    @Published var showAlert: Bool = false
    
    @Published var image: UIImage = UIImage(systemName: "xmark")!
    
    @Published var event: Event?
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
    
    func generateQR(link: String) {
        self.image = linkService.generateQRCode(from: link) ?? UIImage(systemName: "xmark")!
    }
    
    func onShareInvitation() {
        guard let urlShare = URL(string: "rumba-app.herokuapp.com://join?id=1") else { return }
        
        let activityViewController = UIActivityViewController(activityItems: [image as AnyObject, urlShare as AnyObject], applicationActivities: nil)
        
        UIApplication.shared.keyWindow?.rootViewController?.present(activityViewController, animated: true, completion: nil)
    }
    
    
    init(eventId: Int) {
        linkService = LinkService()
        eventService = EventApiService()
        self.eventId = eventId
        generateQR(link: "rumba-app.herokuapp.com://join?id=\(eventId)")
    }
}


public extension UIApplication {
    var keyWindow: UIWindow? {
        return UIApplication.shared.connectedScenes
            .filter { $0.activationState == .foregroundActive }
            .first(where: { $0 is UIWindowScene })
            .flatMap({ $0 as? UIWindowScene })?.windows
            .first(where: \.isKeyWindow)
    }
}
