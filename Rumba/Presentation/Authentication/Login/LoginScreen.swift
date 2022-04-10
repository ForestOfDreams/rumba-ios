//
//  LoginView.swift
//  Rumba
//
//  Created by Vladislav Shchukin on 24.02.2022.
//

import SwiftUI

struct LoginScreen: View {
    @EnvironmentObject var viewModel: LoginViewModel
    @State var selection: Int? = nil
    
    var body: some View {
        NavigationView {
            VStack {
                Form {
                    Section(
                        footer:
                            FormErrorMesagesView(messages: viewModel.loginErrorMessages)
                    ) {
                        TextField("Email", text:$viewModel.email)
                        SecureField("Password", text:$viewModel.password)
                    }
                }
                if viewModel.showProgressView {
                    ProgressView()
                        .padding(20)
                } else {
                    Button("Log in") {
                        viewModel.loginUser()
                    }
                    .buttonStyle(PrimaryButton(color: .blue))
                    .padding(20)
                    .disabled(!viewModel.isFormValid)
                }
                HStack {
                    Text("Don't have an account?")
                    NavigationLink(destination: {
                        RegistrScreen()
                    }, label: {
                        Text("Sign up")
                    }
                    )
                }
                .padding(.bottom)
            }
            .navigationTitle("Log in")
            .alert(isPresented: self.$viewModel.showAlert, content: {
                Alert(
                    title: Text("Error"),
                    message: Text(viewModel.alertMessage),
                    dismissButton: .default(Text("OK!"),
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
