//
//  CreatorEventDetailView.swift
//  Rumba
//
//  Created by Vladislav Shchukin on 02.04.2022.
//

import SwiftUI
import MapKit

struct EventDetailView: View {
    var event: Event
    var image: UIImage
    var shareAction : () -> Void
    
    var body: some View {
        VStack(alignment: .leading) {
            MainSectionView(
                event: event,
                image: image,
                shareAction: shareAction
            )
            Divider()
            DescriptionSectionView(event: event)
            Divider()
            LocationSectionView(event: event)
        }
        .padding()
        .background(
            Color.white
                .cornerRadius(5)
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
                if event.isOnline {
                    HStack{
                        Image(systemName: "desktopcomputer")
                        Text("Online event")
                    }
                }
                else {
                    HStack{
                        Image(systemName: "leaf.fill")
                        Text("Offline event")
                    }
                }
                HStack{
                    Image(systemName: "person.3.sequence.fill")
                    Text("\(event.members?.count ?? 0) members")
                }
                HStack{
                    Image(systemName: "calendar")
                    Text("\(Calendar.current.dateComponents([.day], from: Date(), to: event.startDate).day ?? 0) days before start")
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

struct DescriptionSectionView: View {
    @State var showDescription: Bool = false
    var event: Event
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Description")
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
    var event: Event
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Location")
                    .font(.title2)
            }
            
            if let latitude = event.latitude,
               let longitude = event.longitude,
               let placeName = event.placeName
            {
                HStack {
                    Text(placeName)
                    Button {
                        withAnimation {
                            showLocation.toggle()
                        }
                    } label: {
                        showLocation ?
                        Text("hide map") :
                        Text("show map")
                    }
                }
                if showLocation {
                    MapView(
                        region: MKCoordinateRegion(
                            center: CLLocationCoordinate2D(latitude: latitude, longitude: longitude),
                            span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)),
                        annotationItems: [
                            EventPlace(
                                name: event.title,
                                coordinate: CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                            )
                        ]
                    )
                    .aspectRatio(1.5, contentMode: .fit)
                }
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
