//
//  DetailEventView.swift
//  Rumba
//
//  Created by Vladislav Shchukin on 22.03.2022.
//

import SwiftUI
import MapKit

struct EventPlace: Identifiable {
    let id = UUID()
    let name: String
    let coordinate: CLLocationCoordinate2D
}

struct ParticipatorEventDetailScreen: View {
    let event: Event
    
    var body: some View {
        ScrollView {
            VStack {
                EventDetailView(
                    event: event,
                    image: UIImage(systemName: "qrcode")!,
                    shareAction: {}
                )
            }
            .padding()
        }
    }
}

struct DetailEventView_Previews: PreviewProvider {
    static var previews: some View {
        ParticipatorEventDetailScreen(
            event: Event(
                eventId: 1,
                title: "Уборка пляжа",
                description: "Необходимо очистить от мусора пляж лазурного озера",
                isOnline: false,
                isCancelled: false,
                isRescheduled: false,
                placeName: "Лазурное озеро",
                latitude: 60.886490560469504,
                longitude: 29.54654745624353,
                startDate: Date.now,
                endDate: Date.now,
                tasks: [],
                members: [],
                creator: Creator(
                    accountId: 1,
                    firstName: "Петр",
                    lastName: "Енотов",
                    email: "touch@gmail.com")
            )
        )
    }
}
