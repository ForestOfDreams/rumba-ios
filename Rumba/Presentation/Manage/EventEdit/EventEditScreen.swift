//
//  CreateEventView.swift
//  Rumba
//
//  Created by Vladislav Shchukin on 25.03.2022.
//

import SwiftUI
import MapItemPicker

struct EventEditScreen: View {
    typealias EventType = EventEditViewModel.EventType
    @StateObject var viewModel: EventEditViewModel
    @FocusState private var showKeaboard: Bool
    @Environment(\.presentationMode) var presentationMode
    
    @State private var showingPicker = false
    
    var body: some View {
        Form {
            Section(
                footer: FormErrorMesagesView(messages: viewModel.mainErrorMessages)
            ) {
                TextField("event-title-placeholder", text: $viewModel.title)
                    .focused($showKeaboard)
                ZStack(alignment: .topLeading) {
                    TextEditor(text: $viewModel.description)
                        .focused($showKeaboard)
                        .padding(.horizontal, -5)
                        .padding(.vertical, -5)
                        .frame(minHeight: 120)
                    Text("description-title")
                        .foregroundColor(Color(.init(gray: 0.5, alpha: 0.5)))
                        .padding(.top, 3)
                        .opacity(viewModel.description.isEmpty ? 1 : 0)
                }
            }
            Section(
                header: Text("event-type-title"),
                footer: Text("event-type-footer")
            ) {
                Picker("event-type-title", selection: $viewModel.type) {
                    ForEach(EventType.allCases, id: \.self) {
                        Text(LocalizedStringKey($0.rawValue))
                    }
                }
                .pickerStyle(.segmented)
            }
            Section(
                header: Text("event-period-title"),
                footer: FormErrorMesagesView(messages: viewModel.dateErrorMessages)
            ) {
                DatePicker(
                    "event-start-time-title",
                    selection: $viewModel.startDate,
                    displayedComponents: [.date, .hourAndMinute]
                )
                DatePicker(
                    "event-start-end-title",
                    selection: $viewModel.endDate,
                    displayedComponents: [.date, .hourAndMinute]
                )
                
            }
            if viewModel.type == .offline {
                Section(
                    header: Text("location-title"),
                    footer: FormErrorMesagesView(messages: viewModel.locationErrorMessages)
                ) {
                    PlacePickerField(viewModel: viewModel)
                }
            }
            if viewModel.isEditMode {
                Section(
                    header: Text("event-status-title"),
                    footer: FormErrorMesagesView(messages: viewModel.locationErrorMessages)
                ) {
                    Toggle("event-cancel-btn", isOn: $viewModel.isCancelled)
                        .toggleStyle(SwitchToggleStyle(tint: .red))
                }
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
        .navigationTitle(viewModel.isEditMode ? "edit-event-title" : "create-event-title")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            editButton
        }
        .onChange(of: viewModel.shouldCloseView) { newValue in
            if newValue {
                presentationMode.wrappedValue.dismiss()
            }
        }
    }
    
    var editButton: some ToolbarContent {
        ToolbarItem(placement: .navigationBarTrailing) {
            Button {
                viewModel.onSave()
            } label: {
                Image(systemName: "square.and.arrow.down")
            }
            .disabled(!viewModel.isFormValid)
        }
    }
}
