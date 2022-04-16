//
//  LoginView.swift
//  Rumba
//
//  Created by Vladislav Shchukin on 24.02.2022.
//

import SwiftUI

struct LoginScreen: View {
    @StateObject var viewModel: LoginViewModel
    
    @State var selection: Int? = nil
    
    var body: some View {
        NavigationView {
            VStack {
                Form {
                    Section(
                        footer:
                            FormErrorMesagesView(messages: viewModel.loginErrorMessages)
                    ) {
                        TextField("email-placeholder", text:$viewModel.email)
                        SecureField("password-placeholder", text:$viewModel.password)
                    }
                }
                if viewModel.showProgressView {
                    ProgressView()
                        .padding(20)
                } else {
                    Button("login-btn") {
                        viewModel.loginUser()
                    }
                    .buttonStyle(PrimaryButton(color: .blue))
                    .padding(20)
                    .disabled(!viewModel.isFormValid)
                }
                HStack {
                    Text("switch-to-signup-title")
                    NavigationLink(destination: {
                        RegistrScreen()
                    }, label: {
                        Text("signup-title")
                    }
                    )
                }
                .padding(.bottom)
            }
            .navigationTitle("login-title")
            .alert(isPresented: self.$viewModel.showAlert, content: {
                Alert(
                    title: Text("error-title"),
                    message: Text(viewModel.alertMessage),
                    dismissButton: .default(
                        Text("OK!"),
                        action: {}
                    )
                )
            })
        }
    }
}

//struct LoginView_Previews: PreviewProvider {
//    static var previews: some View {
//        LoginView()
//    }
//}
