//
//  RumbaApp.swift
//  Rumba
//
//  Created by Владислав Щукин on 30.12.2021.
//

import SwiftUI

@main
struct RumbaApp: App {
//    @AppStorage("her") private var lol = "her"
    var body: some Scene {
        WindowGroup {
            RegistrView().environmentObject(RegistrViewModel())
        }
    }
}
