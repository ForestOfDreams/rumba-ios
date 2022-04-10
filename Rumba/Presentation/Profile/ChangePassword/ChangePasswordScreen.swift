//
//  ChangePasswordScreen.swift
//  Rumba
//
//  Created by Vladislav Shchukin on 10.04.2022.
//

import SwiftUI

struct ChangePasswordScreen: View {
    @StateObject var viewModal: ChangePasswordViewModel = ChangePasswordViewModel()
    @EnvironmentObject var loginViewModel: LoginViewModel
    
    var body: some View {
        NavigationView {
            VStack {
                Form {
                    Section {
                        TextField("Old password", text: $viewModal.oldPassword)
                    }
                    Section {
                        TextField("New password", text: $viewModal.password)
                        TextField("Confirm password", text: $viewModal.confirmPassword)
                    }
                }
                Button {
                    viewModal.onChangePassword(action:  loginViewModel.logOut)
//                    loginViewModel.isAuth = false
                } label: {
                    Text("Save password")
                }
                .disabled(!viewModal.formIsValid)
                .buttonStyle(PrimaryButton(color: .green))
                .padding()
            }
            .navigationTitle("Change Password")
        }
    }
}

struct ChangePasswordScreen_Previews: PreviewProvider {
    static var previews: some View {
        ChangePasswordScreen()
    }
}
