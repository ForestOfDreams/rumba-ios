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
    @Environment(\.presentationMode) var presentationMode
    
    let editMode: Bool
    
    var body: some View {
        VStack {
            Form {
                Section(
                    footer: FormErrorMesagesView(messages: viewModal.mainErrorMessages)
                ){
                    TextField("Title", text: $viewModal.title)
                    ZStack(alignment: .topLeading) {
                        TextEditor(text: $viewModal.description)
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
                    Stepper("Member count", value: $viewModal.membersCount, in: 1...Int.max)
                    Text("Selected number of members: \(viewModal.membersCount)")
                }
                Section {
                    DatePicker(
                        "Start date",
                        selection: $viewModal.startDate,
                        displayedComponents: [.date, .hourAndMinute])
                    DatePicker(
                        "End date",
                        selection: $viewModal.endDate,
                        displayedComponents: [.date, .hourAndMinute]
                    )
                } footer: {
                    VStack(alignment: .leading) {
                        Text("You need to select time interval between \(viewModal.localizedStartDate) and \(viewModal.localizedEndDate).")
                        FormErrorMesagesView(messages: viewModal.dateErrorMessages)
                    }
                }
            }
            if editMode {
                Button("Remove task") {
                    viewModal.deleteTask()
                }
                .buttonStyle(PrimaryButton(color: .red))
                .padding()
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
//struct TaskPickerView_Previews: PreviewProvider {
//    static var previews: some View {
//        TaskPickerView()
//    }
//}
