//
//  DetailEventView.swift
//  Rumba
//
//  Created by Vladislav Shchukin on 22.03.2022.
//

import SwiftUI
import MapKit

struct City: Identifiable {
    let id = UUID()
    let name: String
    let coordinate: CLLocationCoordinate2D
}

struct DetailEventView: View {
    let title: String
    let description: String
    let isOnline: Bool
    let isCancelled: Bool
    let isRescheduled: Bool
    let latitude: Double
    let longitude: Double
    let startDate: Date
    let endDate: Date
    
    var body: some View {
        ScrollView {
            VStack {
                Text(title)
                Text(description)
                Text(String(isOnline))
                Text(String(isCancelled))
                Text(String(isRescheduled))
                Text(startDate.ISO8601Format())
                Text(endDate.ISO8601Format())
                MapView(
                    region: MKCoordinateRegion(
                        center: CLLocationCoordinate2D(latitude: latitude, longitude: longitude),
                        span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)),
                    annotationItems: [
                        Place(
                            name: "London",
                            coordinate: CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                        )
                    ]
                )
            }
        }
    }
}

struct DetailEventView_Previews: PreviewProvider {
    static var previews: some View {
        DetailEventView(
            title: "Уборка пляжа",
            description: "Увлекательная уборка пляжа",
            isOnline: false,
            isCancelled: false,
            isRescheduled: false,
            latitude: 45.4,
            longitude: 43.3,
            startDate: Date.now,
            endDate: Date.now + TimeInterval(1)
        )
    }
}
