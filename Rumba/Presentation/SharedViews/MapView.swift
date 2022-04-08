//
//  MapView.swift
//  Rumba
//
//  Created by Vladislav Shchukin on 23.03.2022.
//

import SwiftUI
import MapKit

struct MapView: View {
    @State var region: MKCoordinateRegion
    
    let annotationItems: [EventPlace]
    
    var body: some View {
        Map(
            coordinateRegion: $region,
            annotationItems: annotationItems
        ) {
            MapMarker(coordinate: $0.coordinate, tint: .green)
        }
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView(
            region: MKCoordinateRegion(
                center: CLLocationCoordinate2D(latitude: 60.886490560469504, longitude: 29.54654745624353),
                span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)),
            annotationItems: [
                EventPlace(
                    name: "Лазурное озеро",
                    coordinate: CLLocationCoordinate2D(latitude: 60.886490560469504, longitude: 29.54654745624353)
                )
            ]
        )
    }
}
