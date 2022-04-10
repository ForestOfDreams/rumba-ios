//
//  SwiftUIView.swift
//  Rumba
//
//  Created by Vladislav Shchukin on 24.02.2022.
//

import SwiftUI

struct TabBarView: View {
    @EnvironmentObject var loginViewModel: LoginViewModel
    
    var body: some View {
        
        TabView {
            ParticipationTabScreen()
                .tabItem {
                    Label("Events", systemImage: "globe.europe.africa")
                }
            
            ManageTabScreen()
                .tabItem {
                    Label("Manage", systemImage: "list.bullet.rectangle")
                }
            ProfileTabScreen()
                .tabItem {
                    Label("Profile", systemImage: "person.crop.circle")
                }
        }
    }
}

struct TabBarView_Previews: PreviewProvider {
    static var previews: some View {
        TabBarView()
    }
}
