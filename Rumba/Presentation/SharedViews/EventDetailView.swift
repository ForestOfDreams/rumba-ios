//
//  CreatorEventDetailView.swift
//  Rumba
//
//  Created by Vladislav Shchukin on 02.04.2022.
//

import SwiftUI
import MapKit

struct EventDetailView: View {
    @Environment(\.colorScheme) var colorScheme
    let event: Event
    let image: UIImage
    let shareAction : () -> Void
    
    var body: some View {
        VStack(alignment: .leading) {
            MainSectionView(
                event: event,
                image: image,
                shareAction: shareAction
            )
            Divider()
            EventTimeSectionView(event: event)
            Divider()
            EventDescriptionSectionView(event: event)
            if let latitude = event.latitude,
               let longitude = event.longitude,
               let placeName = event.placeName
            {
                Divider()
                LocationSectionView(
                    latitude: latitude,
                    longitude: longitude,
                    placeName: placeName
                )
            }
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

struct EventDetailView_Previews: PreviewProvider {
    static var previews: some View {
        EventDetailView(
            event: DummyData.event,
            image: UIImage(systemName: "qrcode")!,
            shareAction: {}
        )
        .padding()
        .preferredColorScheme(.light)
        .previewDevice("iPhone 13 Pro Max")
    }
}

struct MainSectionView: View {
    var event: Event
    var image: UIImage
    var shareAction : () -> Void
    
    var body: some View {
        HStack(alignment: .center) {
            VStack(alignment: .leading) {
                if event.isCancelled {
                    HStack{
                        Image(systemName: "exclamationmark.square.fill")
                        Text("Cancelled")
                    }
                    .foregroundColor(.red)
                }
                if event.isRescheduled {
                    HStack{
                        Image(systemName: "exclamationmark.square.fill")
                        Text("Rescheduled")
                    }
                    .foregroundColor(.red)
                }
                if event.isOnline {
                    HStack{
                        Image(systemName: "desktopcomputer")
                        Text("Online")
                    }
                }
                else {
                    HStack{
                        Image(systemName: "leaf.fill")
                        Text("Offline")
                    }
                }
                HStack{
                    Image(systemName: "person.3.sequence.fill")
                    Text("\(event.members?.count ?? 0) members")
                }
                HStack{
                    Image(systemName: "calendar")
                    Text("\(Calendar.current.dateComponents([.day], from: Date(), to: event.startDate).day ?? 0) days to start")
                }
            }
            Spacer()
            QRCodeView(
                image: image,
                shareAction: shareAction
            )
        }
    }
}

struct EventTimeSectionView: View {
    var event: Event
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("event-period-title")
                    .font(.title2)
            }
            Text("Start time:  \(MyDateFormatter().localizedDate(event.startDate))")
            Text("End time:  \(MyDateFormatter().localizedDate(event.endDate))")
        }
        .frame(
            maxWidth: .infinity,
            alignment: .topLeading
        )
    }
}

struct EventDescriptionSectionView: View {
    var event: Event
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("description-title")
                    .font(.title2)
            }
            Text(event.description)
        }
        .frame(
            maxWidth: .infinity,
            alignment: .topLeading
        )
    }
}

struct LocationSectionView: View {
    @State var showLocation: Bool = false
    let latitude: Double
    let longitude: Double
    let placeName: String
    
    var body: some View {
        
        VStack(alignment: .leading) {
            HStack {
                Text("location-title")
                    .font(.title2)
            }
            HStack {
                Text(placeName)
                Button {
                    withAnimation {
                        showLocation.toggle()
                    }
                } label: {
                    showLocation ?
                    Text("hide map") :
                    Text("show-map-btn")
                }
            }
            if showLocation {
                MapView(
                    region: MKCoordinateRegion(
                        center: CLLocationCoordinate2D(latitude: latitude, longitude: longitude),
                        span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)),
                    annotationItems: [
                        EventPlace(
                            name: placeName,
                            coordinate: CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                        )
                    ]
                )
                .aspectRatio(1.5, contentMode: .fit)
            }
        }
        .frame(
            maxWidth: .infinity,
            alignment: .topLeading
        )
    }
}

private func expandImage(imageName: String) -> some View {
    return Image(systemName: imageName)
        .resizable()
        .scaledToFit()
        .frame(width: 12)
}
