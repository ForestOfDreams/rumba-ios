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
                onRefresh: viewModel.fetchParticipatedEvents,
                onEventDisappear: viewModel.fetchParticipatedEvents,
                searchText: $viewModel.searchText,
                filterType: $viewModel.filterType
            )
                .navigationTitle("Participation")
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
            JoinEventScreen(viewModel: JoinEventViewModel(eventId: viewModel.joinEventId!))
            
        }
        .onOpenURL { url in
            viewModel.openDeepLink(url: url)
        }
    }
}


struct ParticipationView_Previews: PreviewProvider {
    static var previews: some View {
        ParticipationTabScreen()
    }
}
