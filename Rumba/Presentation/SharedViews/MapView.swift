//
//  MapView.swift
//  Rumba
//
//  Created by Vladislav Shchukin on 23.03.2022.
//

import SwiftUI
import MapKit

struct Place: Identifiable {
    let id = UUID()
    let name: String
    let coordinate: CLLocationCoordinate2D
}

struct MapView: View {
    @State var region: MKCoordinateRegion
    
    let annotationItems: [Place]
    
    var body: some View {
        Map(
            coordinateRegion: $region,
            annotationItems: annotationItems) {
                MapMarker(coordinate: $0.coordinate)
            }
        
            .frame(width: 400, height: 300
        )
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView(
            region: MKCoordinateRegion(
                center: CLLocationCoordinate2D(latitude: 3, longitude: 4),
                span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)),
            annotationItems: [
                Place(
                    name: "London",
                    coordinate: CLLocationCoordinate2D(latitude: 3, longitude: 4)
                )
            ]
        )
    }
}
