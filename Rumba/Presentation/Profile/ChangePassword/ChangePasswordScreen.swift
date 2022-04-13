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
                        TextField("old-password-placeholder", text: $viewModal.oldPassword)
                    } footer: {
                        VStack {
                            Text("edit-password-old-footer")
                            FormErrorMesagesView(messages: viewModal.oldPasswordErrorMessages)
                        }
                    }
                    Section {
                        TextField("new-password-placeholder", text: $viewModal.password)
                        TextField("confirm-password-placeholder", text: $viewModal.confirmPassword)
                    } footer: {
                        VStack(alignment: .leading) {
                            PasswordStrengthBarView(passwordStrength: viewModal.passwordStrength)
                            Text("edit-password-new-footer")
                            FormErrorMesagesView(messages: viewModal.passwordErrorMessages)
                        }
                    }
                }
                Button {
                    viewModal.onChangePassword(action:  loginViewModel.logOut)
                } label: {
                    Text("save-profile-btn")
                }
                .disabled(!viewModal.formIsValid)
                .buttonStyle(PrimaryButton(color: .green))
                .padding()
            }
            .navigationTitle("change-password-title")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct ChangePasswordScreen_Previews: PreviewProvider {
    static var previews: some View {
        ChangePasswordScreen()
    }
}
