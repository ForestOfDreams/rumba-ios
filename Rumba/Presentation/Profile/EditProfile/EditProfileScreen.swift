//
//  EditProfileView.swift
//  Rumba
//
//  Created by Vladislav Shchukin on 25.03.2022.
//

import SwiftUI

struct EditProfileScreen: View {
    @StateObject var viewModal: EditProfileViewModel
    @State var showChangePasswordScreen: Bool = false
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack {
            Form {
                Section {
                    TextField("First name", text: $viewModal.firstName)
                    TextField("Last name", text: $viewModal.lastName)
                }
                Section {
                    TextField("Email", text: $viewModal.email)
                }
                
                Section {
                    Button {
                        showChangePasswordScreen = true
                    } label: {
                        Text("Change password")
                    }
                }
            }
            Button {
                viewModal.onChangeUser()
            } label: {
                Text("Save profile")
            }
            .disabled(!viewModal.formIsValid)
            .buttonStyle(PrimaryButton(color: .green))
            .padding()
        }
        .navigationTitle("Edit Profile")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    viewModal.onClear()
                } label: {
                    Text("Clear")
                }
            }
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
}

//struct EditProfileView_Previews: PreviewProvider {
//    static var previews: some View {
//        EditProfileScreen()
//    }
//}
