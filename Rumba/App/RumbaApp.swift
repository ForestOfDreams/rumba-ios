//
//  RumbaApp.swift
//  Rumba
//
//  Created by Владислав Щукин on 30.12.2021.
//

import SwiftUI

@main
struct RumbaApp: App {
    @StateObject var authentication = AuthenticatinViewModel()
    var body: some Scene {
        WindowGroup {
            if authentication.isAuth {
                TabBarView()
                    .environmentObject(authentication)
            }
            else {
                LoginScreen(
                    viewModel: LoginViewModel(
                        login: authentication.login,
                        logout: authentication.logOut
                    )
                )
            }
        }
    }
}
