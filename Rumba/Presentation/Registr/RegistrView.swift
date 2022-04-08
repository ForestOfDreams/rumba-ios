//
//  ContentView.swift
//  Rumba
//
//  Created by Владислав Щукин on 30.12.2021.
//

import SwiftUI

struct RegistrView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject var viewModel: RegistrViewModel = RegistrViewModel()
    @State var presentAlert = false
    var body: some View {
        VStack {
            Form {
                Section(footer: Text(viewModel.usernameMessage)) {
                    TextField("First name", text:$viewModel.firstName)
                        .autocapitalization(.none)
                    TextField("Last name", text:$viewModel.lastName)
                        .autocapitalization(.none)
                    TextField("Emal", text:$viewModel.email)
                }
                Section(footer: Text(viewModel.passwordMessage)) {
                    SecureField("Password", text:$viewModel.password)
                    SecureField("Confirm password", text: $viewModel.confirmPassword)
                }
            }
            if viewModel.showProgressView {
                ProgressView()
                    .padding(20)
            } else {
                Button("Sign up") {
                    viewModel.registrUser()
                }
                .buttonStyle(PrimaryButton())
                .padding(20)
                .disabled(!viewModel.isValid)
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
        RegistrView()
    }
}
