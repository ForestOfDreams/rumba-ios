//
//  ProfileView.swift
//  Rumba
//
//  Created by Vladislav Shchukin on 21.03.2022.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var loginViewModel: LoginViewModel
    var body: some View {
        NavigationView {
            Text("Tab bar view")
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Log out!") {
                            loginViewModel.logOut()
                        }
                    }
                }
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
