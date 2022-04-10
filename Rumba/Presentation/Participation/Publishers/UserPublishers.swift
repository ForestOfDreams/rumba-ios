//
//  UserPublishers.swift
//  Rumba
//
//  Created by Vladislav Shchukin on 10.04.2022.
//

import Foundation
import Combine

struct UserPublishers {
    typealias Action = (String) -> (Bool)
    
    private func stringPublisher(string: Published<String>.Publisher, formStringMap: @escaping Action) -> AnyPublisher<Bool, Never> {
        string
            .debounce(for: 0.8, scheduler: RunLoop.main)
            .removeDuplicates()
            .map {
                formStringMap($0)
            }
            .eraseToAnyPublisher()
    }
    
    func isFirstNameValidPublisher(firstName: Published<String>.Publisher) -> AnyPublisher<Bool, Never> {
        stringPublisher(string: firstName, formStringMap: {$0.count >= 3})
    }
    
    func isLastNameValidPublisher(lastName: Published<String>.Publisher) -> AnyPublisher<Bool, Never> {
        stringPublisher(string: lastName, formStringMap: {$0.count >= 3})
    }
    
    func isEmailValidPublisher(email: Published<String>.Publisher) -> AnyPublisher<Bool, Never> {
        stringPublisher(string: email, formStringMap: {checkEmail($0)})
    }
    
    func isPasswordEmptyPublisher(password: Published<String>.Publisher) -> AnyPublisher<Bool, Never> {
        stringPublisher(string: password, formStringMap: {$0.isEmpty})
    }
    
    func arePasswordsEqualPublisher(first: Published<String>.Publisher, second: Published<String>.Publisher) -> AnyPublisher<Bool, Never> {
        Publishers.CombineLatest(first, second)
            .debounce(for: 0.8, scheduler: RunLoop.main)
            .map { password, confirmPassword in
                return password == confirmPassword
            }
            .eraseToAnyPublisher()
    }
    
    func passwordStrengthPublisher(password: Published<String>.Publisher) -> AnyPublisher<PasswordStrenght, Never> {
        password
            .debounce(for: 0.2, scheduler: RunLoop.main)
            .removeDuplicates()
            .map { input in
                switch input.count {
                case 0...2:
                    return .bad
                case 2...4:
                    return .reasonable
                case 4...6:
                    return .strong
                default:
                    return .veryStrong
                }
            }
            .eraseToAnyPublisher()
    }
    
    func isPasswordStrongEnoughPublisher(password: Published<String>.Publisher) -> AnyPublisher<Bool, Never> {
        passwordStrengthPublisher(password: password)
            .map { strenght in
                switch strenght {
                case .bad:
                    return false
                default:
                    return true
                }
            }
            .eraseToAnyPublisher()
    }
    
    private func checkEmail(_ string: String) -> Bool {
        if string.count > 100 {
            return false
        }
        let emailFormat = "(?:[\\p{L}0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[\\p{L}0-9!#$%\\&'*+/=?\\^_`{|}" + "~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\" + "x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[\\p{L}0-9](?:[a-" + "z0-9-]*[\\p{L}0-9])?\\.)+[\\p{L}0-9](?:[\\p{L}0-9-]*[\\p{L}0-9])?|\\[(?:(?:25[0-5" + "]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-" + "9][0-9]?|[\\p{L}0-9-]*[\\p{L}0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21" + "-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
        return emailPredicate.evaluate(with: string)
    }
    
    enum PasswordStrenght {
        case bad
        case reasonable
        case strong
        case veryStrong
    }
}
