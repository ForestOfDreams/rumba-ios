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
    @StateObject var viewModel: ParticipatorEventDetailViewModel
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack {
            if let event = viewModel.event {
                ParticipatorEventDetailView(
                    event: event,
                    myTask: viewModel.myTask,
                    QRImage: viewModel.image,
                    onShare: {},
                    onLeaveEvent: viewModel.leaveEvent
                )
            }
        }
        .navigationTitle(viewModel.event?.title ?? "")
        .onChange(of: viewModel.shouldCloseView) { newValue in
            if newValue {
                presentationMode.wrappedValue.dismiss()
            }
        }
        .onAppear(perform: viewModel.fetchEvent)
        .onAppear(perform: viewModel.fetchMyTask)
    }
}
