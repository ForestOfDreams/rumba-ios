//
//  ContentView.swift
//  Rumba
//
//  Created by Владислав Щукин on 30.12.2021.
//

import SwiftUI

struct RegistrScreen: View {
    @StateObject var viewModel: RegistrViewModel = RegistrViewModel()
    
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.openURL) var openURL
    
    @State var presentAlert = false
    
    var body: some View {
        VStack {
            Form {
                Section() {
                    TextField("first-name-placeholder", text:$viewModel.firstName)
                        .autocapitalization(.none)
                    TextField("last-name-placeholder", text:$viewModel.lastName)
                        .autocapitalization(.none)
                    TextField("email-placeholder", text:$viewModel.email)
                } footer: {
                    FormErrorMesagesView(messages: viewModel.mainErrorMessages)
                }
                
                Section {
                    SecureField("password-placeholder", text:$viewModel.password)
                    SecureField("confirm-password-placeholder", text: $viewModel.confirmPassword)
                } footer: {
                    VStack(alignment: .leading) {
                        PasswordStrengthBarView(passwordStrength: viewModel.passwordStrength)
                        FormErrorMesagesView(messages: viewModel.passwordErrorMessages)
                    }
                }
            }
            if viewModel.showProgressView {
                ProgressView()
                    .padding(20)
            } else {
                Button("signup-btn") {
                    viewModel.registrUser()
                }
                .buttonStyle(PrimaryButton(color: .blue))
                .padding(20)
                .disabled(!viewModel.formIsValid)
            }
        }
        .alert("Success", isPresented: $viewModel.showMailAlert) {
            Button("Ok") {
                presentationMode.wrappedValue.dismiss()
            }
            Button("Open mail app") {
                openURL(URL(string: "message://")!)
                presentationMode.wrappedValue.dismiss()
            }
        } message: {
            Text("You need to verify your address using the link in the email sent to you.")
        }
        .navigationTitle("signup-title")
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

struct PasswordStrengthBarView: View {
    let passwordStrength: UserPublishers.PasswordStrenght
    
    var body: some View {
        VStack {
            HStack {
                Text("password-strength-title")
                Spacer()
                switch passwordStrength {
                case .bad:
                    Text("poor-password")
                        .foregroundColor(.red)
                case .reasonable:
                    Text("average-password")
                        .foregroundColor(.yellow)
                case .strong:
                    Text("strong-password")
                        .foregroundColor(.green)
                case .veryStrong:
                    Text("great-password")
                        .foregroundColor(.green)
                }
            }
            switch passwordStrength {
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
        }
    }
}
