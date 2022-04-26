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
                localizedTaskStartDate: viewModel.localizedStartDate,
                localizedTaskEndDate: viewModel.localizedEndDate,
                isFormValid: $viewModel.isFormValid,
                message: viewModel.resultMessage,
                onSubmit: viewModel.assign
            )
            .navigationTitle("choose-task-btn")
            .onChange(of: viewModel.shouldCloseView) { newValue in
                if newValue {
                    presentationMode.wrappedValue.dismiss()
                }
            }
        }
    }
}
