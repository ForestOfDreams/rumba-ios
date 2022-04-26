//
//  CreatorEventCardView.swift
//  Rumba
//
//  Created by Vladislav Shchukin on 31.03.2022.
//

import SwiftUI

struct CreatorEventCardView: View {
    let event: Event
    
    var body: some View {
        HStack {
            Text(event.title)
            Spacer()
            if (event.isActionsRequired ?? false) {
                Image(systemName: "exclamationmark.square")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 15)
                    .foregroundColor(.yellow)
                    .padding(.horizontal)
            }
        }
    }
}
