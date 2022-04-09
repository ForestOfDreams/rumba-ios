//
//  TitleView.swift
//  Rumba
//
//  Created by Vladislav Shchukin on 09.04.2022.
//

import SwiftUI

struct TitleView: View {
    let text: String
    
    var body: some View {
        VStack {
            Text(text)
                .font(.title)
                .padding(.top, 10)
        }
        .frame(
            maxWidth: .infinity,
            alignment: .topLeading
        )
    }
}

struct TitleView_Previews: PreviewProvider {
    static var previews: some View {
        TitleView(text: "Tasks")
    }
}
