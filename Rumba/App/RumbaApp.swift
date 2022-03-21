//
//  RumbaApp.swift
//  Rumba
//
//  Created by Владислав Щукин on 30.12.2021.
//

import SwiftUI

@main
struct RumbaApp: App {
    @StateObject var authentication = LoginViewModel()
    var body: some Scene {
        WindowGroup {
            if authentication.isAuth {
                TabBarView()
                    .environmentObject(authentication)
            }
            else {
                LoginView()
                    .environmentObject(authentication)
            }
        }
        
    }
}
