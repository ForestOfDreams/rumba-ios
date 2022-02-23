//
//  ContentView.swift
//  Rumba
//
//  Created by Владислав Щукин on 30.12.2021.
//

import SwiftUI

struct RegistrView: View {
    @EnvironmentObject var viewModel: RegistrViewModel
    @State var presentAlert = false
    var body: some View {
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
            Section {
                Button {
                    signUp()
                } label: {
                    Text("Sign up")
                }
                .disabled(!viewModel.isValid)

            }
        }
        .sheet(isPresented: $presentAlert) {
            VStack {
                Text(viewModel.token)
            }
        }

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

