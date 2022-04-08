//
//  CreatorEventCardView.swift
//  Rumba
//
//  Created by Vladislav Shchukin on 31.03.2022.
//

import SwiftUI

struct CreatorEventCardView: View {
    let event: Event
    
    var body: some View {
        VStack {
            Text(event.title)
        }
    }
}

//struct CreatorEventCardView_Previews: PreviewProvider {
//    static var previews: some View {
//        CreatorEventCardView()
//    }
//}
