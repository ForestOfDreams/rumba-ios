//
//  ProfileView.swift
//  Rumba
//
//  Created by Vladislav Shchukin on 21.03.2022.
//

import SwiftUI

struct ProfileTabView: View {
    @EnvironmentObject var loginViewModel: LoginViewModel
    @StateObject var viewModel: ProfileViewModel = ProfileViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                if let user = viewModel.user {
                    Form {
                        Text(user.email)
                        Text(user.firstName)
                        Text(user.lastName)
                    }
                }
                else {
                    ProgressView()
                }
            }
            .navigationTitle("Profile")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button {
                        loginViewModel.logOut()
                    } label: {
                        Image(systemName: "rectangle.portrait.and.arrow.right")
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .automatic) {
                    NavigationLink(destination: {
                        EditProfileView()
                    }, label: {
                        Text("Edit")
                    })
                }
            }
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileTabView()
    }
}
