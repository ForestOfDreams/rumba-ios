//
//  BaseQRCodeView.swift
//  Rumba
//
//  Created by Vladislav Shchukin on 25.03.2022.
//

import SwiftUI

struct BaseQRCodeView: View {
    var image: Image
    
    var body: some View {
        image
            .resizable()
            .interpolation(.none)
            .scaledToFit()
            .frame(
                width: UIScreen.main.bounds.size.width * 0.3,
                height: UIScreen.main.bounds.size.width * 0.3
            )
    }
}

struct BaseQRCodeView_Previews: PreviewProvider {
    static var previews: some View {
        BaseQRCodeView(image: Image(systemName: "xmark.octagon"))
    }
}
