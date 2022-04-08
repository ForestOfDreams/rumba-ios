//
//  ManageView.swift
//  Rumba
//
//  Created by Vladislav Shchukin on 21.03.2022.
//

import SwiftUI
import CoreImage
import CoreImage.CIFilterBuiltins

struct ManageTabScreen: View {
    @StateObject var viewModel: ManageViewModel = ManageViewModel()
    
    var body: some View {
        NavigationView {
            CreatorEventsListView(
                events: viewModel.filteredEvents,
                onRefresh: viewModel.fetchCreatedEvents,
                onEventDisappear: viewModel.fetchCreatedEvents,
                searchText: $viewModel.searchText,
                filterType: $viewModel.filterType
            )
            .navigationTitle("Created events")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink {
                        EventEditView(viewModel: EventEditViewModel())
                    } label: {
                        Image(systemName: "plus.square")
                    }
                }
            }
        }
    }
}

struct ManageView_Previews: PreviewProvider {
    static var previews: some View {
        ManageTabScreen()
    }
}
