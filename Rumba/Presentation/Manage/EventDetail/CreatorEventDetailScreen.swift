//
//  CreatorEventDetailView.swift
//  Rumba
//
//  Created by Vladislav Shchukin on 31.03.2022.
//

import SwiftUI
import MapKit
import Combine

struct CreatorEventDetailScreen: View {
    @StateObject var viewModel: CreatorEventDetailViewModel
    
    var body: some View {
        if let event = viewModel.event {
                Form {
                    Section{
                        QRCodeView(
                            image: viewModel.image,
                            shareAction: actionSheet
                        )
                        Text(event.title)
                        Text(event.description)
                        Text(String(event.isOnline))
                        Text(String(event.isCancelled))
                        Text(String(event.isRescheduled))
                        Text(event.startDate.ISO8601Format())
                        Text(event.endDate.ISO8601Format())
                        if let latitude = event.latitude, let longitude = event.longitude{
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
                        }
                    }
                }
//                CreatorTasksListView(tasks: event.tasks ?? [], event: event)
                
            .navigationTitle(event.title)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink {
                        EventEditView(
                            viewModel: EventEditViewModel(
                                editingEventId: event.eventId
                            )
                        )
                    } label: {
                        Image(systemName: "slider.horizontal.3")
                    }
                }
            }
        }
    }
    
    func actionSheet() {
        guard let urlShare = URL(string: "rumba-app.herokuapp.com://join?id=1") else { return }
        
        // set up activity view controller
        let activityViewController = UIActivityViewController(activityItems: [urlShare, viewModel.image], applicationActivities: nil)
        
        // present the view controller
        UIApplication.shared.windows.first?.rootViewController?.present(activityViewController, animated: true, completion: nil)
    }
}

struct CreatorEventDetailView_Previews: PreviewProvider {
    static var previews: some View {
        CreatorEventDetailScreen(viewModel: CreatorEventDetailViewModel(eventId: 1))
    }
}
