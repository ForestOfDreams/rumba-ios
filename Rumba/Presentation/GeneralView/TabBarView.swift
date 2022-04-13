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
                    Label("participation-title", systemImage: "globe.europe.africa")
                }
            
            ManageTabScreen()
                .tabItem {
                    Label("manage-title", systemImage: "list.bullet.rectangle")
                }
            ProfileTabScreen()
                .tabItem {
                    Label("profile-title", systemImage: "person.crop.circle")
                }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct TabBarView_Previews: PreviewProvider {
    static var previews: some View {
        TabBarView()
    }
}
