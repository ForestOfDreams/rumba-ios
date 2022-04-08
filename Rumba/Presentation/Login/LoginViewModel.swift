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
        loginService = LoginApiService()
        setUpTimer()
        setUpValidationSubscribers()
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

extension LoginViewModel {
    func setUpValidationSubscribers() {
        isEmailValidPublisher
            .dropFirst()
            .receive(on: RunLoop.main)
            .sink(receiveValue: { [weak self] isValid in
                if !isValid {
                    self?.loginErrorMessages.insert(LoginErrorMessage.emailNotValid.rawValue)
                }
                else {
                    self?.loginErrorMessages.remove(LoginErrorMessage.emailNotValid.rawValue)
                }
            })
            .store(in: &cancellableSet)
        
        isPasswordValidPublisher
            .dropFirst()
            .receive(on: RunLoop.main)
            .sink(receiveValue: { [weak self] isValid in
                if !isValid {
                    self?.loginErrorMessages.insert(LoginErrorMessage.passwordNotValid.rawValue)
                }
                else {
                    self?.loginErrorMessages.remove(LoginErrorMessage.passwordNotValid.rawValue)
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
    
    private var isEmailValidPublisher: AnyPublisher<Bool, Never> {
        $email
            .dropFirst()
            .debounce(for: 0.8, scheduler: RunLoop.main)
            .removeDuplicates()
            .map {email in
                print(email)
                return LoginViewModel.checkEmail(email)
            }
            .eraseToAnyPublisher()
    }
    
    private var isPasswordValidPublisher: AnyPublisher<Bool, Never> {
        $password
            .dropFirst()
            .debounce(for: 0.8, scheduler: RunLoop.main)
            .removeDuplicates()
            .map { password in
                return password.count > 0
            }
            .eraseToAnyPublisher()
    }
    
    private var isFormValidPublisher: AnyPublisher<Bool, Never> {
        Publishers.CombineLatest(isPasswordValidPublisher, isEmailValidPublisher)
            .map { isPasswordValid, isEmailValid in
                return isPasswordValid && isEmailValid
            }
            .eraseToAnyPublisher()
    }
    
    static func checkEmail(_ string: String) -> Bool {
        if string.count > 100 {
            return false
        }
        let emailFormat = "(?:[\\p{L}0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[\\p{L}0-9!#$%\\&'*+/=?\\^_`{|}" + "~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\" + "x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[\\p{L}0-9](?:[a-" + "z0-9-]*[\\p{L}0-9])?\\.)+[\\p{L}0-9](?:[\\p{L}0-9-]*[\\p{L}0-9])?|\\[(?:(?:25[0-5" + "]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-" + "9][0-9]?|[\\p{L}0-9-]*[\\p{L}0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21" + "-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
        return emailPredicate.evaluate(with: string)
    }
}

enum LoginErrorMessage: String {
    case passwordNotValid = "The password cannot be empty."
    case emailNotValid = "Enter valid email."
}

