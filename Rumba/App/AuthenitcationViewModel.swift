//
//  AuthenitcationViewModel.swift
//  Rumba
//
//  Created by Vladislav Shchukin on 14.04.2022.
//

import Foundation

class AuthenticatinViewModel: ObservableObject {
    @Published var isAuth: Bool = false
    
    func logOut() {
        isAuth = false
        KeychainStorage.shared.removeToken()
    }
    
    func login(token: LoginResponse) {
        self.isAuth = true
        KeychainStorage.shared.saveToken(token)
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
    
    init() {
        setUpTimer()
    }
}
