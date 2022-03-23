//
//  ParticipationView.swift
//  Rumba
//
//  Created by Vladislav Shchukin on 21.03.2022.
//

import SwiftUI
import CodeScanner


struct ParticipationView: View {
    @StateObject var viewModel: ParticipationViewModel = ParticipationViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                Text(viewModel.result)
                EventsListView(events: viewModel.events)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        viewModel.isPresentingScanner = true
                    } label: {
                        Image(systemName: "qrcode.viewfinder")
                    }
                    
                }
            }
        }
        .sheet(isPresented: $viewModel.isPresentingScanner) {
            CodeScannerView(
                codeTypes: [.qr],
                simulatedData: "rumba-app.herokuapp.com://join?id=1",
                completion: viewModel.handleScan
            )
        }
        .sheet(isPresented: $viewModel.isPresentingJoin) {
            JoinEventView(
                title: viewModel.event!.title,
                description: viewModel.event!.description,
                isOnline: viewModel.event!.isOnline,
                isCancelled: viewModel.event!.isCancelled,
                isRescheduled: viewModel.event!.isRescheduled,
                latitude: viewModel.event!.latitude,
                longitude: viewModel.event!.longitude,
                startDate: viewModel.event!.startDate,
                endDate: viewModel.event!.endDate,
                joinEvent: viewModel.joinEvent
            )
            
        }
        .onAppear(perform: {
            viewModel.fetchParticipatedEvents()
        })
        .onOpenURL { url in
            var parameters: [String: String] = [:]
            URLComponents(url: url, resolvingAgainstBaseURL: false)?.queryItems?.forEach {
                parameters[$0.name] = $0.value
            }
            guard parameters.count == 1 else { return }
            
            viewModel.showJoinMenu(id: Int(parameters.first!.value)!)
        }
    }
}


struct ParticipationView_Previews: PreviewProvider {
    static var previews: some View {
        ParticipationView()
    }
}
