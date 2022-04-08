//
//  ParticipatorEventCardView.swift
//  Rumba
//
//  Created by Vladislav Shchukin on 04.04.2022.
//

import SwiftUI

struct ParticipatorEventCardView: View {
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

struct ParticipatorEventCardView_Previews: PreviewProvider {
    static var previews: some View {
        ParticipatorEventCardView(event: DummyData.event)
    }
}
