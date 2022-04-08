//
//  ManageView.swift
//  Rumba
//
//  Created by Vladislav Shchukin on 21.03.2022.
//

import SwiftUI
import CoreImage
import CoreImage.CIFilterBuiltins

struct ManageTabView: View {
    @StateObject var viewModel: ManageViewModel = ManageViewModel()
    
    var body: some View {
        NavigationView {
            CreatorEventsListView(
                events: $viewModel.events,
                onRefresh: viewModel.fetchCreatedEvents
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
        .onAppear {
            viewModel.fetchCreatedEvents()
        }
    }
}

struct ManageView_Previews: PreviewProvider {
    static var previews: some View {
        ManageTabView()
    }
}
