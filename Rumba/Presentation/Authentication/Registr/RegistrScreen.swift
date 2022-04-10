//
//  ContentView.swift
//  Rumba
//
//  Created by Владислав Щукин on 30.12.2021.
//

import SwiftUI

struct RegistrScreen: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject var viewModel: RegistrViewModel = RegistrViewModel()
    
    @State var presentAlert = false
    
    var body: some View {
        VStack {
            Form {
                Section() {
                    TextField("First name", text:$viewModel.firstName)
                        .autocapitalization(.none)
                    TextField("Last name", text:$viewModel.lastName)
                        .autocapitalization(.none)
                    TextField("Email", text:$viewModel.email)
                } footer: {
                    FormErrorMesagesView(messages: viewModel.mainErrorMessages)
                }
                
                Section {
                    SecureField("Password", text:$viewModel.password)
                    SecureField("Confirm password", text: $viewModel.confirmPassword)
                } footer: {
                    switch viewModel.passwordStrength {
                    case .bad:
                        ProgressView(value: 1, total: 4)
                            .tint(.red)
                    case .reasonable:
                        ProgressView(value: 2, total: 4)
                            .tint(.yellow)
                    case .strong:
                        ProgressView(value: 3, total: 4)
                            .tint(.green)
                    case .veryStrong:
                        ProgressView(value: 4, total: 4)
                            .tint(.green)
                    }
                    FormErrorMesagesView(messages: viewModel.passwordErrorMessages)
                }
            }
            if viewModel.showProgressView {
                ProgressView()
                    .padding(20)
            } else {
                Button("Sign up") {
                    viewModel.registrUser()
                }
                .buttonStyle(PrimaryButton(color: .blue))
                .padding(20)
                .disabled(!viewModel.formIsValid)
            }
        }
        .onChange(of: viewModel.shouldCloseView) { newValue in
            if newValue {
                presentationMode.wrappedValue.dismiss()
            }
        }
        .navigationTitle("Create Account")
    }
    func signUp() {
        viewModel.registrUser()
        self.presentAlert = true
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        RegistrScreen()
    }
}
