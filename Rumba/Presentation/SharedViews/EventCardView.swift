//
//  EventCardView.swift
//  Rumba
//
//  Created by Vladislav Shchukin on 23.03.2022.
//

import SwiftUI

struct EventCardView: View {
    let event: Event
    
    var body: some View {
        VStack {
            Text(event.title)
        }
    }
}

struct EventCardView_Previews: PreviewProvider {
    static var previews: some View {
        EventCardView(
            event: DummyData.event
        )
    }
}
