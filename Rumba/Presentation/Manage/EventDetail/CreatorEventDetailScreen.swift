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
                    onShare: viewModel.onShareInvitation
                )
                .navigationTitle(event.title)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        NavigationLink {
                            EventEditScreen(
                                viewModel: EventEditViewModel(
                                    editingEventId: event.eventId
                                )
                            )
                        } label: {
                            Text("edit-button")
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
}
