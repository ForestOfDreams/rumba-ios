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
    
    @Published var isFormValid: Bool = false
    @Published var loginErrorMessages: Set<String> = Set<String>()
    
    @Published var showProgressView = false
    @Published var showAlert = false
    @Published var alertMessage = ""
    
    private var loginService: LoginApiServiceProtocol
    private var userPublishers: UserPublishers
    
    private var cancellableSet: Set<AnyCancellable> = []
    
    func loginUser() {
        showProgressView = true
        loginService.loginUser(LoginForm(email: self.email, password: self.password))
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { completion in
                self.showProgressView = false
                switch completion {
                case .failure(let error):
                    if let myErrorResult = error as? ApiError {
                        self.alertMessage = myErrorResult.messages[0]
                        self.showAlert = true
                    }
                default: break
                }
            }, receiveValue: { [weak self] response in
                self?.setUpTimer()
            })
            .store(in: &cancellableSet)
    }
    
    func logOut() {
        isAuth = false
        KeychainStorage.shared.removeToken()
    }
    
    init() {
        loginService = LoginApiService()
        userPublishers = UserPublishers()
        setUpTimer()
        setUpValidationSubscribers()
    }
    
    private func setUpTimer() {
        if let token = KeychainStorage.shared.getToken(), token.expires_at > Date.now {
            isAuth = true
            let timer = Timer(
                fire: token.expires_at,
                interval: 0,
                repeats: false
            ) { [weak self] _ in
                self?.isAuth = false
                KeychainStorage.shared.removeToken()
            }
            RunLoop.main.add(timer, forMode: .common)
        }
    }
}

extension LoginViewModel {
    func setUpValidationSubscribers() {
        userPublishers.isEmailValidPublisher(email: $email)
            .dropFirst()
            .receive(on: RunLoop.main)
            .sink(receiveValue: { [weak self] isValid in
                if !isValid {
                    self?.loginErrorMessages.insert(UserMainErrorMessage.emailNotValid.rawValue)
                }
                else {
                    self?.loginErrorMessages.remove(UserMainErrorMessage.emailNotValid.rawValue)
                }
            })
            .store(in: &cancellableSet)
        
        userPublishers.isPasswordEmptyPublisher(password: $password)
            .dropFirst()
            .receive(on: RunLoop.main)
            .sink(receiveValue: { [weak self] isEmpty in
                if isEmpty {
                    self?.loginErrorMessages.insert(UserPasswordErrorMessage.passwordEmpty.rawValue)
                }
                else {
                    self?.loginErrorMessages.remove(UserPasswordErrorMessage.passwordEmpty.rawValue)
                }
            })
            .store(in: &cancellableSet)
        
        isFormValidPublisher
            .receive(on: RunLoop.main)
            .sink(receiveValue: {[weak self] isValid in
                self?.isFormValid = isValid
            })
            .store(in: &cancellableSet)
    }
    
    private var isFormValidPublisher: AnyPublisher<Bool, Never> {
        Publishers.CombineLatest(
            userPublishers.isPasswordEmptyPublisher(password: $password),
            userPublishers.isEmailValidPublisher(email: $email)
        )
        .map { !$0 && $1 }
        .eraseToAnyPublisher()
    }
}
