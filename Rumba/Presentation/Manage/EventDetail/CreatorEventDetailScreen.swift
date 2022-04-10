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
        ZStack {
            if let event = viewModel.event {
                CreatorEventDetailView(
                    event: event,
                    image: viewModel.image,
                    onShare: actionSheet
                )
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
            else {
                ProgressView()
            }
        }
        .onAppear {
            viewModel.fetchEvent()
        }
    }
    
    func actionSheet() {
        guard let urlShare = URL(string: "rumba-app.herokuapp.com://join?id=1") else { return }
        
        let activityViewController = UIActivityViewController(activityItems: [urlShare, viewModel.image], applicationActivities: nil)
        
        UIApplication.shared.windows.first?.rootViewController?.present(activityViewController, animated: true, completion: nil)
    }
}
