//
//  ChooseTaskView.swift
//  Rumba
//
//  Created by Vladislav Shchukin on 28.03.2022.
//

import SwiftUI

struct ChooseTaskScreen: View {
    @StateObject var viewModel: ChooseTaskViewModel
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            ChooseTaskView(
                startDate: $viewModel.startDate,
                endDate: $viewModel.endDate,
                isFormValid: $viewModel.isFormValid,
                message: viewModel.resultMessage,
                onSubmit: viewModel.assign
            )
            .onChange(of: viewModel.shouldCloseView) { newValue in
                if newValue {
                    presentationMode.wrappedValue.dismiss()
                }
            }
            .navigationTitle("Choose task")
        }
    }
}

