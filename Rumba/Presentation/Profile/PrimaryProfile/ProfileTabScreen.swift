//
//  ProfileView.swift
//  Rumba
//
//  Created by Vladislav Shchukin on 21.03.2022.
//

import SwiftUI

struct ProfileTabScreen: View {
    @StateObject var viewModel: ProfileViewModel = ProfileViewModel()
//    @EnvironmentObject var loginViewModel: LoginViewModel
    @EnvironmentObject var authenticatiomViewModel: AuthenticatinViewModel
    
    var body: some View {
        NavigationView {
            VStack {
                if let user = viewModel.user {
                    AsyncImage(url: URL(string: "https://i0.wp.com/3.bp.blogspot.com/-xp5VzwYRB3E/XDmHGpWlBFI/AAAAAAAAEsY/IkRPJbHMDyc2wJsOcYiaccbqIUlfc_H5wCHMYCw/s1600/ian-ramnarine-thinglink.jpg")) {
                        $0
                            .resizable()
                            .frame(width: 100, height: 100)
                            .clipShape(Circle())
                            .shadow(radius: 10)
                            .overlay(Circle().stroke(Color.red, lineWidth: 5))
                    } placeholder: {
                        ProgressView()
                    }
                    Text("\(user.firstName) \(user.lastName)")
                        .font(.largeTitle)
                    Text(user.email)
                        .font(.footnote)
                    Text("volunteer-hours-title \(user.hoursInEvents)")
                        .font(.footnote)
                    Spacer()
                    .toolbar {
                        ToolbarItem(placement: .automatic) {
                            NavigationLink(destination: {
                                EditProfileScreen(
                                    viewModal: EditProfileViewModel(
                                        user: user
                                    )
                                )
                            }, label: {
                                Text("edit-button")
                            })
                        }
                    }
                }
                else {
                    ProgressView()
                }
            }
            .onAppear(perform: viewModel.getCurrentUser)
            .navigationTitle("profile-title")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button {
                        authenticatiomViewModel.logOut()
                    } label: {
                        Image(systemName: "rectangle.portrait.and.arrow.right")
                    }
                }
            }
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileTabScreen()
    }
}
