//
//  FormErrorMesagesView.swift
//  Rumba
//
//  Created by Vladislav Shchukin on 04.04.2022.
//

import SwiftUI

struct FormErrorMesagesView: View {
    let messages: Set<String>
    
    var body: some View {
        VStack(alignment: .leading) {
            ForEach(messages.sorted() { $0 > $1 }, id: \.self) { message in
                    Text(LocalizedStringKey(message))
                        .foregroundColor(.red)
                }
        }
        .frame(minHeight: 10)
    }
}

struct FormErrorMesagesView_Previews: PreviewProvider {
    static var previews: some View {
        FormErrorMesagesView(messages: ["error1", "error2"])
    }
}
