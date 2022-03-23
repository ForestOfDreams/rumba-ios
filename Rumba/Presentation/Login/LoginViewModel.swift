//
//  LoginViewModel.swift
//  Rumba
//
//  Created by Vladislav Shchukin on 24.02.2022.
//

import SwiftUI
import Combine

class LoginViewModel : ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published var isAuth = false
    
    @Published var showProgressView = false
    @Published var showAlert = false
    @Published var alertMessage = ""
    
    private var loginService: LoginServiceProtocol
    
    private var cancellableSet: Set<AnyCancellable> = []
    
    func loginUser() {
        showProgressView = true
        loginService.loginUser(LoginForm(email: self.email, password: self.password))
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { completion in
                self.showProgressView = false
                switch completion {
                case .failure(let error):
                    let myErrorResult = error as! MyError
                    self.alertMessage = myErrorResult.messages[0]
                    self.showAlert = true
                    
                case .finished: print("Publisher is finished")
                }
            }, receiveValue: { [weak self] response in
                print(KeychainStorage.shared.saveToken(response))
                self?.setUpTimer()
        
            })
            .store(in: &cancellableSet)
    }
    
    func logOut() {
        isAuth = false
        KeychainStorage.shared.removeToken()
    }
    
    init() {
        loginService = LoginService()
        setUpTimer()
    }
    
    private func setUpTimer() {
        if let token = KeychainStorage.shared.getToken(), token.expires_at > Date.now {
            isAuth = true
            let timer = Timer(fire: token.expires_at, interval: 0, repeats: false) { [weak self] _ in
                self?.isAuth = false
                KeychainStorage.shared.removeToken()
            }
            RunLoop.main.add(timer, forMode: .common)
        }
    }
    
}
