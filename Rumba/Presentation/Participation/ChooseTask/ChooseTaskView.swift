//
//  ChooseTaskView.swift
//  Rumba
//
//  Created by Vladislav Shchukin on 08.04.2022.
//

import SwiftUI

struct ChooseTaskView: View {
    var startDate: Binding<Date>
    var endDate: Binding<Date>
    let localizedTaskStartDate: String
    let localizedTaskEndDate: String
    var isFormValid: Binding<Bool>
    var message: String
    var onSubmit: () -> ()
    
    var body: some View {
        VStack {
            Form {
                Section {
                    DatePicker("Start date", selection: startDate)
                    DatePicker("End date", selection: endDate)
                } footer: {
                    VStack {
                        Text("You need to select time interval between \(localizedTaskStartDate) and \(localizedTaskEndDate).")
                    }
                }
            }
            Button("Submit") {
                onSubmit()
            }
            .buttonStyle(PrimaryButton(color: .green))
            .padding(20)
            .disabled(!isFormValid.wrappedValue)
        }
    }
}

struct ChooseTaskView_Previews: PreviewProvider {
    @State static var startDate = Date()
    @State static var endDate = Date()
    @State static var isFormValid = true
    
    static var previews: some View {
        ChooseTaskView(
            startDate: $startDate,
            endDate: $endDate,
            localizedTaskStartDate: "12/25/19 7:00 AM",
            localizedTaskEndDate: "12/25/19 9:00 AM",
            isFormValid: $isFormValid,
            message: "Unfortunately, the required number of participants for this time has already joined",
            onSubmit: {}
        )
    }
}
