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
                    let myErrorResult = error as? MyError
                    print(myErrorResult)
                case .finished: print("Publisher is finished")
                }
            }, receiveValue: { [weak self] response in
                self?.user = response
            })
            .store(in: &cancellableSet)
    }
}
