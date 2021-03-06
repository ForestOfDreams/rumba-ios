//
//  ParticipationView.swift
//  Rumba
//
//  Created by Vladislav Shchukin on 21.03.2022.
//

import SwiftUI
import CodeScanner

struct ParticipationTabScreen: View {
    @StateObject var viewModel: ParticipationViewModel = ParticipationViewModel()
    
    var body: some View {
        NavigationView {
            ParticipatorEventsListView(
                events: viewModel.filteredEvents,
                onRefresh: { viewModel.fetchParticipatedEvents()
                    viewModel.refreshFilters()
                },
                searchText: $viewModel.searchText,
                filterType: $viewModel.filterType
            )
            .onAppear(perform: {
                viewModel.fetchParticipatedEvents()
            })
            .navigationBarTitle("participation-title", displayMode: .large)
            .toolbar {
                qrCodeButton
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
            if let joinEventId = viewModel.joinEventId {
                JoinEventScreen(viewModel: JoinEventViewModel(eventId: joinEventId), dismiss: $viewModel.isPresentingJoin)
            }
        }
        .onOpenURL { url in
            viewModel.openDeepLink(url: url)
        }
    }
    
    var qrCodeButton: some ToolbarContent  {
        ToolbarItem(placement: .navigationBarTrailing) {
            Button {
                viewModel.isPresentingScanner = true
            } label: {
                Image(systemName: "qrcode.viewfinder")
            }
        }
    }
}

struct ParticipationView_Previews: PreviewProvider {
    static var previews: some View {
        ParticipationTabScreen()
    }
}
