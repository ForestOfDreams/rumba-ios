//
//  ViewModel.swift
//  Rumba
//
//  Created by Владислав Щукин on 31.01.2022.
//

import Foundation
import Combine
import UIKit

class RegistrViewModel: ObservableObject {
    
    @Published var firstName = ""
    @Published var lastName = ""
    @Published var email = ""
    @Published var password = ""
    @Published var confirmPassword = ""
    
    @Published var passwordStrength: UserPublishers.PasswordStrenght = .bad
    
    @Published var mainErrorMessages: Set<String> = Set<String>()
    @Published var passwordErrorMessages: Set<String> = Set<String>()
    
    @Published var formIsValid = false
    
    @Published var showProgressView = false
    @Published var showAlert = false
    @Published var alertMessages = []
    
    @Published var showMailAlert = false
    
    private var registrService: RegistrApiServiceProtocol
    
    private var cancellableSet: Set<AnyCancellable> = []
    
    private var userPublishers: UserPublishers
    
    func registrUser() {
        showProgressView = true
        registrService.registrUser(
            RegistrForm(
                firstName: firstName,
                lastName: lastName,
                email: email,
                password: password
            )
        )
        .receive(on: RunLoop.main)
        .sink( receiveCompletion: {[weak self] completion in
            self?.showProgressView = false
            switch completion {
            case .failure(let error):
                if let myErrorResult = error as? ApiError {
                    self?.alertMessages = myErrorResult.messages
                    self?.showAlert = true
                }
            default: break
            }
        }, receiveValue: { [weak self] response in
            self?.showMailAlert = true
        })
        .store(in: &cancellableSet)
    }
    
    private var isFormValidPublisher: AnyPublisher<Bool, Never> {
        Publishers.CombineLatest4(
            userPublishers.isFirstNameValidPublisher(firstName: $firstName),
            userPublishers.isLastNameValidPublisher(lastName: $lastName),
            userPublishers.isEmailValidPublisher(email: $email),
            isPasswordValidPublisher
        )
        .map { $0 && $1 && $2 && $3}
        .eraseToAnyPublisher()
    }
    
    
    private var isPasswordValidPublisher: AnyPublisher<Bool, Never> {
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
    
    init() {
        self.registrService = RegistrApiService()
        self.userPublishers = UserPublishers()
        
        userPublishers.isFirstNameValidPublisher(firstName: $firstName)
            .dropFirst()
            .receive(on: RunLoop.main)
            .sink(receiveValue: { [weak self] isValid in
                if !isValid {
                    self?.mainErrorMessages.insert(UserMainErrorMessage.firstNameTooShort.rawValue)
                }
                else {
                    self?.mainErrorMessages.remove(UserMainErrorMessage.firstNameTooShort.rawValue)
                }
            })
            .store(in: &cancellableSet)
        
        userPublishers.isLastNameValidPublisher(lastName: $lastName)
            .dropFirst()
            .receive(on: RunLoop.main)
            .sink(receiveValue: { [weak self] isValid in
                if !isValid {
                    self?.mainErrorMessages.insert(UserMainErrorMessage.lastNameTooShort.rawValue)
                }
                else {
                    self?.mainErrorMessages.remove(UserMainErrorMessage.lastNameTooShort.rawValue)
                }
            })
            .store(in: &cancellableSet)
        
        userPublishers.isEmailValidPublisher(email: $email)
            .dropFirst()
            .receive(on: RunLoop.main)
            .sink(receiveValue: { [weak self] isValid in
                if !isValid {
                    self?.mainErrorMessages.insert(UserMainErrorMessage.emailNotValid.rawValue)
                }
                else {
                    self?.mainErrorMessages.remove(UserMainErrorMessage.emailNotValid.rawValue)
                }
            })
            .store(in: &cancellableSet)
        
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
    }
}
