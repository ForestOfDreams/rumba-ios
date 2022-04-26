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
    
    
    /// Get token from keychain
    /// - Returns: Optional token
    func getToken() -> LoginResponse? {
        if let myTokenString = KeychainWrapper.standard.string(forKey: key) {
            return decode(myTokenString)
        }
        return nil
    }
    
    
    /// Save token to keychain storage
    /// - Parameter token: saving toke
    func saveToken(_ token: LoginResponse) {
        if let utfToken = encode(data: token) {
            KeychainWrapper.standard.set(utfToken, forKey: key)
        }
    }
    
    
    /// Remove token from keychain storage
    func removeToken() {
        KeychainWrapper.standard.removeObject(forKey: key)
    }
    
    private init() {}
    
    
    /// Encode token data to utf 8 string
    /// - Parameter data: conding token
    /// - Returns: utf 8 string
    private func encode(data: LoginResponse) -> String? {
        let encoder = JSONEncoder()
        if let data = try? encoder.encode(data) {
            return String(data: data, encoding: .utf8)
        }
        return nil
    }
    
    
    /// Decode token from utf 8 string
    /// - Parameter data: utf 8 string with token data
    /// - Returns: token struct
    private func decode(_ data: String) -> LoginResponse? {
        let decoder = JSONDecoder()
        let jsonData = data.data(using: .utf8)
        return try? decoder.decode(LoginResponse.self, from: jsonData!)
    }
}
