//
//  PlacePickerField.swift
//  Rumba
//
//  Created by Vladislav Shchukin on 25.03.2022.
//

import SwiftUI
import MapKit

struct PlacePickerField: View {
    @ObservedObject var viewModel: EventEditViewModel
    @State private var showingPicker = false
    
    var body: some View {
        HStack {
            if viewModel.longitude == nil || viewModel.latitude == nil {
                Button {
                    showingPicker = true
                } label: {
                    Text("location-title")
                }
                .mapItemPicker(isPresented: $showingPicker) { [weak viewModel] item in
                    if let place = item {
                        viewModel?.latitude = place.placemark.coordinate.latitude
                        viewModel?.longitude = place.placemark.coordinate.longitude
                        viewModel?.placeName = place.name
                    }
                }
            }
            else {
                HStack {
                    Text(viewModel.placeName ?? "")
                    Spacer()
                    Button {
                        viewModel.latitude = nil
                        viewModel.longitude = nil
                        viewModel.placeName = nil
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                    }
                }
                .buttonStyle(.borderless)
            }
        }
    }
}

//
//struct PlacePickerField_Previews: PreviewProvider {
//    static var previews: some View {
//        PlacePickerField(place: LMPlace())
//    }
//}
