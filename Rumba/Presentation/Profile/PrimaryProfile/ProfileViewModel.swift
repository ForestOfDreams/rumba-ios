//
//  ProfileViewModel.swift
//  Rumba
//
//  Created by Vladislav Shchukin on 25.03.2022.
//

import Foundation
import Combine

class ProfileViewModel: ObservableObject {
    @Published var user: User?
    
    private var profileService: ProfileApiServiceProtocol
    private var cancellableSet: [AnyCancellable] = []
    
    @Published var alertMessages: [String] = []
    @Published var showAlert: Bool = false
    
    init() {
        profileService = ProfileApiService()
        getCurrentUser()
    }
    
    func getCurrentUser() {
        profileService.getCurrentUser()
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
                self?.user = response
            })
            .store(in: &cancellableSet)
    }
}
