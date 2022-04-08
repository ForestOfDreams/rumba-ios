//
//  TaskPickerView.swift
//  Rumba
//
//  Created by Vladislav Shchukin on 26.03.2022.
//

import SwiftUI
import Combine

struct TaskEditView: View {
    @StateObject var viewModel: TaskEditViewModel
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack {
            Form {
                Section(
                    header: Text("You need to select time interval between \(viewModel.relatedEvent.startDate.ISO8601Format()) and \(viewModel.relatedEvent.endDate.ISO8601Format())"),
                    footer: FormErrorMesagesView(messages: viewModel.mainErrorMessages)
                ){
                    TextField("Title", text: $viewModel.title)
                    ZStack(alignment: .topLeading) {
                        TextEditor(text: $viewModel.description)
                            .padding(.horizontal, -5)
                            .padding(.vertical, -5)
                            .frame(minHeight: 120)
                        Text("Description")
                            .foregroundColor(Color(.init(gray: 0.5, alpha: 0.5)))
                            .padding(.top, 3)
                            .opacity(viewModel.description.isEmpty ? 1 : 0)
                    }
                }
                Section {
                    Stepper("Member count", value: $viewModel.membersCount, in: 1...Int.max)
                    Text("Selected number of members: \(viewModel.membersCount)")
                }
                Section(
                    footer: FormErrorMesagesView(messages: viewModel.dateErrorMessages)
                ) {
                    DatePicker(
                        "Start date",
                        selection: $viewModel.startDate,
                        displayedComponents: [.date, .hourAndMinute])
                    DatePicker(
                        "End date",
                        selection: $viewModel.endDate,
                        displayedComponents: [.date, .hourAndMinute])
                }
            }
            Button("Remove task") {
                viewModel.deleteTask()
            }
        }
        .navigationTitle(viewModel.isEditMode ? "Task editor" : "Create task")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    viewModel.onSave()
                } label: {
                    Image(systemName: "square.and.arrow.down")
                }
                .disabled(!viewModel.isFormValid)
            }
        }
        .onChange(of: viewModel.shouldCloseView) { newValue in
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
