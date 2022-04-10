//
//  ChangePasswordViewModel.swift
//  Rumba
//
//  Created by Vladislav Shchukin on 10.04.2022.
//

import Foundation
import Combine

class ChangePasswordViewModel: ObservableObject {
    @Published var oldPassword = ""
    @Published var password = ""
    @Published var confirmPassword = ""
    @Published var passwordStrength: UserPublishers.PasswordStrenght = .bad
    
    @Published var formIsValid: Bool = true
    
    @Published var shouldCloseView: Bool = false
    
    @Published var passwordErrorMessages: Set<String> = Set<String>()
    
    @Published var alertMessages: [String] = []
    @Published var showAlert: Bool = false
    
    private var profileService: ProfileApiServiceProtocol
    private var userPublishers: UserPublishers
    private var cancellableSet: [AnyCancellable] = []
    
    init() {
        profileService = ProfileApiService()
        userPublishers = UserPublishers()
        
        setUpValidationSubscribers()
    }
    
    private var isFormValidPublisher: AnyPublisher<Bool, Never> {
        Publishers.CombineLatest3(
            userPublishers.isPasswordEmptyPublisher(password: $password),
            userPublishers.arePasswordsEqualPublisher(first: $password, second: $confirmPassword),
            userPublishers.isPasswordStrongEnoughPublisher(password: $password)
        )
        .map { isEmpty, areEqual, isStrong in
            return !isEmpty && areEqual && isStrong
        }
        .eraseToAnyPublisher()
    }
    
    func setUpValidationSubscribers() {
        userPublishers.isPasswordEmptyPublisher(password: $password)
            .dropFirst()
            .receive(on: RunLoop.main)
            .sink(receiveValue: { [weak self] isEmpty in
                if isEmpty {
                    self?.passwordErrorMessages.insert(UserPasswordErrorMessage.passwordEmpty.rawValue)
                }
                else {
                    self?.passwordErrorMessages.remove(UserPasswordErrorMessage.passwordEmpty.rawValue)
                }
            })
            .store(in: &cancellableSet)
        
        userPublishers.isPasswordStrongEnoughPublisher(password: $password)
            .dropFirst()
            .receive(on: RunLoop.main)
            .sink(receiveValue: { [weak self] isStrong in
                if !isStrong {
                    self?.passwordErrorMessages.insert(UserPasswordErrorMessage.passwordNotStrong.rawValue)
                }
                else {
                    self?.passwordErrorMessages.remove(UserPasswordErrorMessage.passwordNotStrong.rawValue)
                }
            })
            .store(in: &cancellableSet)
        
        userPublishers.arePasswordsEqualPublisher(first: $password, second: $confirmPassword)
            .dropFirst()
            .receive(on: RunLoop.main)
            .sink(receiveValue: { [weak self] areEqual in
                if !areEqual {
                    self?.passwordErrorMessages.insert(UserPasswordErrorMessage.passwordsNotMatch.rawValue)
                }
                else {
                    self?.passwordErrorMessages.remove(UserPasswordErrorMessage.passwordsNotMatch.rawValue)
                }
            })
            .store(in: &cancellableSet)
        
        userPublishers.passwordStrengthPublisher(password: $password)
            .receive(on: RunLoop.main)
            .sink(receiveValue: { [weak self] strenght in
                self?.passwordStrength = strenght
            })
            .store(in: &cancellableSet)
        
        isFormValidPublisher
            .receive(on: RunLoop.main)
            .sink(receiveValue: { [weak self] isValid in
                self?.formIsValid = isValid
            })
            .store(in: &cancellableSet)
        
        
        isFormValidPublisher
            .receive(on: RunLoop.main)
            .sink(receiveValue: { [weak self] isValid in
                self?.formIsValid = isValid
            })
            .store(in: &cancellableSet)
    }
    
    func onChangePassword(action: @escaping () -> ()) {
        profileService.changePassword(
            form: ChangePasswordForm(
                oldPassword: oldPassword,
                newPassword: password
            )
        )
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
        }, receiveValue: { _ in
            action()
        })
        .store(in: &cancellableSet)
    }
}
