//
//  CreateEventView.swift
//  Rumba
//
//  Created by Vladislav Shchukin on 25.03.2022.
//

import SwiftUI
import MapItemPicker

struct EventEditView: View {
    @StateObject var viewModel: EventEditViewModel
    @Environment(\.presentationMode) var presentationMode
    
    @State private var showingPicker = false
    
    var body: some View {
        Form {
            Section(
                footer: VStack(alignment: .leading) {
                    ForEach(
                        viewModel.mainErrorMessages.sorted() {
                            $0.rawValue > $1.rawValue }, id: \.self) { message in
                                Text(message.rawValue)
                                    .foregroundColor(.red)
                            }
                }
            ) {
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
            Section(
                header: Text("Event type"),
                footer: Text("Select the type of event, for an online event you will not be able to select a location.")
            ) {
                Picker("Event type", selection: $viewModel.type) {
                    ForEach(viewModel.eventTypes, id: \.self) {
                        Text($0.rawValue)
                    }
                }
                .pickerStyle(.segmented)
            }
            Section(
                header: Text("Period"),
                footer:
                    VStack(alignment: .leading) {
                        ForEach(
                            viewModel.dateErrorMessages.sorted() { $0.rawValue > $1.rawValue }, id: \.self) { message in
                                Text(message.rawValue)
                                    .foregroundColor(.red)
                            }
                    }
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
            if viewModel.type == .offline {
                Section(
                    header: Text("Location"),
                    footer: VStack(alignment: .leading) {
                        ForEach(
                            viewModel.locationErrorMessages.sorted() {
                                $0.rawValue > $1.rawValue }, id: \.self) { message in
                                    Text(message.rawValue)
                                        .foregroundColor(.red)
                                }
                    }
                ) {
                    PlacePickerField(viewModel: viewModel)
                }
            }
//            Section(
//                header: Text("Tasks"),
//                footer: Text("You need to create at least one task.")) {
//                    Stepper("Task count") {
//                        viewModel.onTaskCountIncrement()
//                    } onDecrement: {
//                        viewModel.onTaskCountDescrement()
//                    }
//                    Text("Selected number of tasks: \(viewModel.tasks.count)")
//
//                }
//            ForEach($viewModel.tasks, id: \.taskId) { $task in
//                TaskPickerView(task: $task)
//            }
        }
        .navigationTitle("Create event")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    viewModel.onSaveEvent()
                } label: {
                    Image(systemName: "square.and.arrow.down")
                }
                .disabled(!viewModel.isFormValid)
            }
        }
        .onChange(of: viewModel.closeView) { newValue in
            if newValue {
                presentationMode.wrappedValue.dismiss()
            }
        }
    }
}

struct CreateEventView_Previews: PreviewProvider {
    static var previews: some View {
        EventEditView(viewModel: EventEditViewModel())
    }
}
