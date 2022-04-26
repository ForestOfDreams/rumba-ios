//
//  ProfileView.swift
//  Rumba
//
//  Created by Vladislav Shchukin on 21.03.2022.
//

import SwiftUI

struct ProfileTabScreen: View {
    @StateObject var viewModel: ProfileViewModel = ProfileViewModel()
    @EnvironmentObject var authenticatiomViewModel: AuthenticatinViewModel
    
    var body: some View {
        NavigationView {
            VStack {
                if let user = viewModel.user {
                    AsyncImage(url: URL(string: "https://i.ibb.co/fYdw5p7/Screenshot-2022-04-26-at-03-04-04.png")) {
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
                    if let hours = user.hoursInEvents {
                        Text("volunteer-hours-title \(hours)")
                            .font(.footnote)
                    }
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
