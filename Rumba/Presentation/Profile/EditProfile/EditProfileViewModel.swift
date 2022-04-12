//
//  EditProfileViewModel.swift
//  Rumba
//
//  Created by Vladislav Shchukin on 27.03.2022.
//

import Foundation
import Combine

class EditProfileViewModel: ObservableObject {
    @Published var firstName: String
    @Published var lastName: String
    @Published var email: String
    @Published var formIsValid: Bool = true
    
    @Published var shouldCloseView: Bool = false
    
    @Published var namesErrorMessages: Set<String> = Set<String>()
    @Published var emailErrorMessages: Set<String> = Set<String>()
    
    private var profileService: ProfileApiServiceProtocol
    private var userPublishers: UserPublishers
    private var cancellableSet: [AnyCancellable] = []
    
    @Published var alertMessages: [String] = []
    @Published var showAlert: Bool = false
    
    let initialUser: User
    
    init(user: User) {
        profileService = ProfileApiService()
        userPublishers = UserPublishers()
        initialUser = user
        firstName = user.firstName
        lastName = user.lastName
        email = user.email
        
        setUpValidationSubscribers()
    }
    
    private var isFormValidPublisher: AnyPublisher<Bool, Never> {
        Publishers.CombineLatest3(
            userPublishers.isFirstNameValidPublisher(firstName: $firstName),
            userPublishers.isLastNameValidPublisher(lastName: $lastName),
            userPublishers.isEmailValidPublisher(email: $email)
        )
        .map { $0 && $1 && $2}
        .eraseToAnyPublisher()
    }
    
    func setUpValidationSubscribers() {
        userPublishers.isFirstNameValidPublisher(firstName: $firstName)
            .dropFirst()
            .receive(on: RunLoop.main)
            .sink(receiveValue: { [weak self] isValid in
                if !isValid {
                    self?.namesErrorMessages.insert(UserMainErrorMessage.firstNameTooShort.rawValue)
                }
                else {
                    self?.namesErrorMessages.remove(UserMainErrorMessage.firstNameTooShort.rawValue)
                }
            })
            .store(in: &cancellableSet)
        
        userPublishers.isLastNameValidPublisher(lastName: $lastName)
            .dropFirst()
            .receive(on: RunLoop.main)
            .sink(receiveValue: { [weak self] isValid in
                if !isValid {
                    self?.namesErrorMessages.insert(UserMainErrorMessage.lastNameTooShort.rawValue)
                }
                else {
                    self?.namesErrorMessages.remove(UserMainErrorMessage.lastNameTooShort.rawValue)
                }
            })
            .store(in: &cancellableSet)
        
        userPublishers.isEmailValidPublisher(email: $email)
            .dropFirst()
            .receive(on: RunLoop.main)
            .sink(receiveValue: { [weak self] isValid in
                if !isValid {
                    self?.emailErrorMessages.insert(UserMainErrorMessage.emailNotValid.rawValue)
                }
                else {
                    self?.emailErrorMessages.remove(UserMainErrorMessage.emailNotValid.rawValue)
                }
            })
            .store(in: &cancellableSet)
        
        isFormValidPublisher
            .receive(on: RunLoop.main)
            .sink(receiveValue: { [weak self] isValid in
                self?.formIsValid = isValid
            })
            .store(in: &cancellableSet)
    }
    
    func onClear() {
        firstName = initialUser.firstName
        lastName = initialUser.lastName
        email = initialUser.email
    }
    
    func onChangeUser() {
        profileService.changeProfile(
            form: ChangeUserForm(
                firstName: firstName,
                lastName: lastName,
                email: email
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
        }, receiveValue: { [weak self] response in
            self?.shouldCloseView = true
        })
        .store(in: &cancellableSet)
    }
}
