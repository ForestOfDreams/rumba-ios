//
//  LoginView.swift
//  Rumba
//
//  Created by Vladislav Shchukin on 24.02.2022.
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject var loginViewModel: LoginViewModel
    
    var body: some View {
        NavigationView {
            Form {
                Section() {
                    TextField("Email", text:$loginViewModel.email)
                    SecureField("Password", text:$loginViewModel.password)
                }
                Section {
                    if loginViewModel.showProgressView {
                        ProgressView()
                    } else {
                        Button {
                            loginViewModel.loginUser()
                        } label: {
                            Text("Log in")
                        }
                    }
                    NavigationLink(destination: {
                        RegistrView()
                    }, label: {
                        Text("Go to sign up")
                    })
                }
            }
            .alert(isPresented: self.$loginViewModel.showAlert, content: {
                Alert(title: Text("Error"), message: Text(loginViewModel.alertMessage), dismissButton: .default(Text("OK!"), action: {
                    
                }))
                
            })
            .navigationTitle("Log in")
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
