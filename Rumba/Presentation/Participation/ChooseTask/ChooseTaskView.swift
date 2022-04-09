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
    var isFormValid: Binding<Bool>
    var message: String
    var onSubmit: () -> ()
    
    var body: some View {
        VStack {
            Form {
                Section(
                    footer: Text(message)
                ) {
                    DatePicker("Start date", selection: startDate)
                    DatePicker("End date", selection: endDate)
                }
            }
            Button("Submit") {
                onSubmit()
            }
            .buttonStyle(PrimaryButton())
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
            isFormValid: $isFormValid,
            message: "Unfortunately, the required number of participants for this time has already joined",
            onSubmit: {}
        )
    }
}
