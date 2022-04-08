//
//  CreateEventView.swift
//  Rumba
//
//  Created by Vladislav Shchukin on 25.03.2022.
//

import SwiftUI
import MapItemPicker

struct EventEditView: View {
    typealias EventType = EventEditViewModel.EventType
    @StateObject var viewModel: EventEditViewModel
    @Environment(\.presentationMode) var presentationMode
    
    @State private var showingPicker = false
    
    var body: some View {
        Form {
            Section(
                footer: FormErrorMesagesView(messages: viewModel.mainErrorMessages)
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
                    ForEach([EventType.online,EventType.offline], id: \.self) {
                        Text($0.rawValue)
                    }
                }
                .pickerStyle(.segmented)
            }
            Section(
                header: Text("Period"),
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
            if viewModel.type == .offline {
                Section(
                    header: Text("Location"),
                    footer: FormErrorMesagesView(messages: viewModel.locationErrorMessages)
                ) {
                    PlacePickerField(viewModel: viewModel)
                }
            }
        }
        .navigationTitle(viewModel.isEditMode ? "Edit event" : "Create event")
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

//struct CreateEventView_Previews: PreviewProvider {
//    static var previews: some View {
//        EventEditView(viewModel: EventEditViewModel())
//    }
//}
