//
//  JoinEventView.swift
//  Rumba
//
//  Created by Vladislav Shchukin on 23.03.2022.
//

import SwiftUI

struct JoinEventScreen: View {
    @StateObject var viewModel: JoinEventViewModel
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            if let event = viewModel.event {
                ZStack {
                    JoinEventView(
                        event: event,
                        onJoinEvent: viewModel.joinEvent
                    )
                }
                .navigationTitle("Join Event")
                .alert(isPresented: self.$viewModel.showAlert, content: {
                    Alert(
                        title: Text("Error"),
                        message: Text(viewModel.alertMessages.joined(separator: " ")),
                        dismissButton: .default(
                            Text("OK!"),
                            action: {}
                        )
                    )
                })
                .onChange(of: viewModel.shouldCloseView) { newValue in
                    if newValue {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        }
    }
}
