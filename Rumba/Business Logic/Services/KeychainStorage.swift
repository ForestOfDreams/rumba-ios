//
//  KeychainStorage.swift
//  Rumba
//
//  Created by Vladislav Shchukin on 20.03.2022.
//

import Foundation
import SwiftKeychainWrapper

class KeychainStorage {
    private let key = "token"
    static let shared = KeychainStorage()
    
    func getToken() -> LoginResponse? {
        if let myTokenString = KeychainWrapper.standard.string(forKey: key) {
            return decode(myTokenString)
        }
        return nil
    }
    
    func saveToken(_ token: LoginResponse) -> Bool {
        KeychainWrapper.standard.set(encode(data: token), forKey: key)
    }
    
    func removeToken() {
        KeychainWrapper.standard.removeObject(forKey: key)
    }
    
    private init() {}
    
    private func encode(data: LoginResponse) -> String {
        let encoder = JSONEncoder()
        let data = try! encoder.encode(data)
        return String(data: data, encoding: .utf8)!
    }
    
    private func decode(_ data: String) -> LoginResponse {
        let decoder = JSONDecoder()
        let jsonData = data.data(using: .utf8)
        return try! decoder.decode(LoginResponse.self, from: jsonData!)
    }
}
