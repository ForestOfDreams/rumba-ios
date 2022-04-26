//
//  TaskPickerView.swift
//  Rumba
//
//  Created by Vladislav Shchukin on 26.03.2022.
//

import SwiftUI
import Combine

struct TaskEditScreen: View {
    @StateObject var viewModal: TaskEditViewModel
    @FocusState private var showKeaboard: Bool
    @Environment(\.presentationMode) var presentationMode
    
    let editMode: Bool
    
    var body: some View {
        VStack {
            Form {
                Section(
                    footer: FormErrorMesagesView(messages: viewModal.mainErrorMessages)
                ) {
                    TextField(
                        "task-title-placeholder",
                        text: $viewModal.title
                    )
                    .focused($showKeaboard)
                    ZStack(alignment: .topLeading) {
                        TextEditor(text: $viewModal.description)
                            .focused($showKeaboard)
                            .padding(.horizontal, -5)
                            .padding(.vertical, -5)
                            .frame(minHeight: 120)
                        Text("description-title")
                            .foregroundColor(Color(.init(gray: 0.5, alpha: 0.5)))
                            .padding(.top, 3)
                            .opacity(viewModal.description.isEmpty ? 1 : 0)
                    }
                }
                Section {
                    Stepper("task-members-count-title", value: $viewModal.membersCount, in: 1...Int.max)
                    Text("task-selected-members-count-title \(viewModal.membersCount)")
                }
                Section {
                    DatePicker(
                        "task-start-time-title",
                        selection: $viewModal.startDate,
                        displayedComponents: [.date, .hourAndMinute])
                    DatePicker(
                        "task-start-end-title",
                        selection: $viewModal.endDate,
                        displayedComponents: [.date, .hourAndMinute]
                    )
                }
            header: {
                Text("task-period-title")
            }
            footer: {
                VStack(alignment: .leading) {
                    Text("task-time-footer \(viewModal.localizedStartDate) \(viewModal.localizedEndDate)")
                    FormErrorMesagesView(messages: viewModal.dateErrorMessages)
                }
            }
            }
            if editMode {
                Button("task-remove-btn") {
                    viewModal.deleteTask()
                }
                .buttonStyle(PrimaryButton(color: .red))
                .padding()
            }
        }
        .toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                Spacer()
                Button("done-btn") {
                    showKeaboard = false
                }
            }
        }
        .navigationTitle(viewModal.isEditMode ? "edit-task-title" : "create-task-title")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    viewModal.onSave()
                } label: {
                    Image(systemName: "square.and.arrow.down")
                }
                .disabled(!viewModal.isFormValid)
            }
        }
        .onChange(of: viewModal.shouldCloseView) { newValue in
            if newValue {
                presentationMode.wrappedValue.dismiss()
            }
        }
    }
}
