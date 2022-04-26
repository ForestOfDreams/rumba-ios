//
//  JoinEventView.swift
//  Rumba
//
//  Created by Vladislav Shchukin on 23.03.2022.
//

import SwiftUI

struct JoinEventScreen: View {
    @StateObject var viewModel: JoinEventViewModel
    var dismiss: Binding<Bool>
    
    var body: some View {
        NavigationView {
            if let event = viewModel.event {
                ZStack {
                    JoinEventView(
                        event: event,
                        onJoinEvent: viewModel.joinEvent
                    )
                }
                .navigationTitle("join-event-title")
                .navigationBarTitleDisplayMode(.inline)
                .alert(isPresented: self.$viewModel.showAlert, content: {
                    Alert(
                        title: Text("error-title"),
                        message: Text(viewModel.alertMessages.joined(separator: " ")),
                        dismissButton: .default(
                            Text("OK!"),
                            action: {}
                        )
                    )
                    
                })
                .onChange(of: viewModel.shouldCloseView) { newValue in
                    if newValue {
                        dismiss.wrappedValue = false 
                    }
                }
            }
            if viewModel.showAlert {
                Text("invition-link-incorrect")
            }
        }
    }
}
