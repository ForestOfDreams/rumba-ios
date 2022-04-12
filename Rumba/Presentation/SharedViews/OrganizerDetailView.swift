//
//  OrganizerEventDetailView.swift
//  Rumba
//
//  Created by Vladislav Shchukin on 11.04.2022.
//

import SwiftUI

struct OrganizerDetailView: View {
    @Environment(\.colorScheme) var colorScheme
    
    let organizer: Creator
    
    var body: some View {
        VStack(alignment: .leading) {
            OrganizerMainSectionView(organizer: organizer)
            Divider()
            OrganizerContactSectionView(organizer: organizer)
        }
        .padding()
        .background(
            (colorScheme == .light ?
             Color.white : Color(red: 40/255, green: 40/255, blue: 40/255))
            .cornerRadius(10)
            .shadow(radius: 4)
        )
    }
}

struct OrganizerDetailView_Previews: PreviewProvider {
    static var previews: some View {
        TaskDetailView(
            task: DummyData.task, event: DummyData.event,
            manageMode: false, showAssignButton: true
        )
    }
}

struct OrganizerContactSectionView: View {
    var organizer: Creator
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("event-contact-title")
                    .font(.title2)
            }
            Text(organizer.email)
        }
        .frame(
            maxWidth: .infinity,
            alignment: .topLeading
        )
    }
}


struct OrganizerMainSectionView: View {
    var organizer: Creator
    
    var body: some View {
        HStack {
            Text("\(organizer.firstName) \(organizer.lastName)")
                .font(.title)
        }
    }
}
