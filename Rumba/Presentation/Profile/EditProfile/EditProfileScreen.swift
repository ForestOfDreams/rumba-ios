//
//  EditProfileView.swift
//  Rumba
//
//  Created by Vladislav Shchukin on 25.03.2022.
//

import SwiftUI

struct EditProfileScreen: View {
    @StateObject var viewModal: EditProfileViewModel
    @Environment(\.presentationMode) var presentationMode
    
    @State var showChangePasswordScreen: Bool = false
    
    var body: some View {
        VStack {
            Form {
                Section {
                    TextField("First name", text: $viewModal.firstName)
                    TextField("Last name", text: $viewModal.lastName)
                } footer: {
                    VStack(alignment: .leading) {
                        Text("edit-name-footer")
                        FormErrorMesagesView(messages: viewModal.namesErrorMessages)
                    }
                }
                Section {
                    TextField("Email", text: $viewModal.email)
                } footer: {
                    VStack(alignment: .leading) {
                        Text("edit-email-footer")
                        FormErrorMesagesView(messages: viewModal.emailErrorMessages)
                    }
                }
                Section {
                    Button {
                        showChangePasswordScreen = true
                    } label: {
                        Text("change-password-btn")
                    }
                }
            }
            Button {
                viewModal.onChangeUser()
            } label: {
                Text("save-profile-btn")
            }
            .disabled(!viewModal.formIsValid)
            .buttonStyle(PrimaryButton(color: .green))
            .padding()
        }
        .navigationTitle("edit-profile-title")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            restoreButton
        }
        .sheet(isPresented: $showChangePasswordScreen) {
            ChangePasswordScreen()
        }
        .onChange(of: viewModal.shouldCloseView) { newValue in
            if newValue {
                presentationMode.wrappedValue.dismiss()
            }
        }
    }
    
    var restoreButton: some ToolbarContent {
        ToolbarItem(placement: .navigationBarTrailing) {
            Button {
                viewModal.onClear()
            } label: {
                Text("restore-button")
            }
        }
    }
}
