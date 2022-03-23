//
//  ViewModel.swift
//  Rumba
//
//  Created by Владислав Щукин on 31.01.2022.
//

import Foundation
import Combine

class RegistrViewModel : ObservableObject {
    
    @Published var firstName = ""
    @Published var lastName = ""
    @Published var email = ""
    @Published var password = ""
    @Published var confirmPassword = ""
    
    @Published var usernameMessage = ""
    @Published var passwordMessage = ""
    
    @Published var isValid = false
    
    @Published var showAlert = false
    @Published var alertMessage = ""
    
    
    private var registrService: RegistrServiceProtocol
    
    private var cancellableSet: Set<AnyCancellable> = []
    
    func registrUser() {
        registrService.registrUser(RegistrForm(firstName: firstName, lastName: lastName, email: email, password: password))
            .receive(on: RunLoop.main)
            .sink( receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    let myErrorResult = error as! MyError
                    
                    self.alertMessage = myErrorResult.messages[0]
                    self.showAlert = true
                
                    case .finished: print("Publisher is finished")
                }
            }, receiveValue: { [weak self] response in
                
            })
            .store(in: &cancellableSet)
    }
    
    private var isFormValidPublisher: AnyPublisher<Bool, Never> {
        Publishers.CombineLatest4(
            isFirstNameValidPublisher,
            isLastNameValidPublisher,
            isEmailValidPublisher,
            isPasswordValidPublisher
        )
            .map { firstNameIsValid, lastNameIsValid, emailIsValid, passwordIsValid in
                return firstNameIsValid &&
                lastNameIsValid &&
                emailIsValid &&
                (passwordIsValid == .valid)
            }
            .eraseToAnyPublisher()
    }
    
    
    private var isFirstNameValidPublisher: AnyPublisher<Bool, Never> {
        $firstName
            .debounce(for: 0.8, scheduler: RunLoop.main)
            .removeDuplicates()
            .map { firstName in
                return firstName.count >= 3
            }
            .eraseToAnyPublisher()
    }
    
    private var isLastNameValidPublisher: AnyPublisher<Bool, Never> {
        $lastName
            .debounce(for: 0.8, scheduler: RunLoop.main)
            .removeDuplicates()
            .map { lastName in
                return lastName.count >= 3
            }
            .eraseToAnyPublisher()
    }
    
    private var isEmailValidPublisher: AnyPublisher<Bool, Never> {
        $email
            .debounce(for: 0.8, scheduler: RunLoop.main)
            .removeDuplicates()
            .map { email in
                return email.count >= 3
            }
            .eraseToAnyPublisher()
    }
    
    private var isPasswordEmptyPublisher: AnyPublisher<Bool, Never> {
        $password
            .debounce(for: 0.8, scheduler: RunLoop.main)
            .removeDuplicates()
            .map { password in
                return password == ""
            }
            .eraseToAnyPublisher()
    }
    
    private var arePasswordsEqualPublisher: AnyPublisher<Bool, Never> {
        Publishers.CombineLatest($password, $confirmPassword)
            .debounce(for: 0.8, scheduler: RunLoop.main)
            .map { password, confirmPassword in
                return password == confirmPassword
            }
            .eraseToAnyPublisher()
    }
    
    private var passwordStrengthPublisher: AnyPublisher<Strenght, Never> {
        $password
            .debounce(for: 0.2, scheduler: RunLoop.main)
            .removeDuplicates()
            .map { input in
                switch input.count {
                case 1...5:
                    return .bad
                case 6...:
                    return .strong
                default:
                    return .bad
                }
            }
            .eraseToAnyPublisher()
    }
    
    private var isPasswordStrongEnoughPublisher: AnyPublisher<Bool, Never> {
        passwordStrengthPublisher
            .map { strenght in
                switch strenght {
                case .bad:
                    return false
                case .strong:
                    return true
                default:
                    return false
                }
            }
            .eraseToAnyPublisher()
    }
    
    private var isPasswordValidPublisher: AnyPublisher<passwordCheck, Never> {
        Publishers.CombineLatest3(isPasswordEmptyPublisher, arePasswordsEqualPublisher, isPasswordStrongEnoughPublisher)
            .map { isEmpty, areEqual, isStrong in
                if isEmpty {
                    return .empty
                } else if !areEqual {
                    return .noMatch
                } else if !isStrong {
                    return .notStrongEnough
                }
                return .valid
            }
            .eraseToAnyPublisher()
    }
    
    init(registrService: RegistrServiceProtocol = RegistrService()) {
        
        self.registrService = registrService
        
        isFirstNameValidPublisher
            .dropFirst()
            .receive(on: RunLoop.main)
            .map { valid in
                valid ? "" : "Username must at least have 3 character"
            }
            .assign(to: \.usernameMessage, on: self)
            .store(in: &cancellableSet)
        
        isPasswordValidPublisher
            .dropFirst()
            .receive(on: RunLoop.main)
            .map { passwordCheck in
                switch passwordCheck {
                case .empty:
                    return "Must not be empty"
                case .noMatch:
                    return "Do not match"
                case .notStrongEnough:
                    return "Not strong"
                case .valid:
                    return ""
                }
            }
            .assign(to: \.passwordMessage, on: self)
            .store(in: &cancellableSet)
        
        isFormValidPublisher
            .receive(on: RunLoop.main)
            .assign(to: \.isValid, on:self)
            .store(in: &cancellableSet)
    }
    
    
    
    enum passwordCheck {
        case valid
        case empty
        case noMatch
        case notStrongEnough
    }
    
    enum Strenght {
        case bad
        case reasonable
        case strong
        case veryStrong
    }
}
