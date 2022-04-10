//
//  BaseQRCodeView.swift
//  Rumba
//
//  Created by Vladislav Shchukin on 25.03.2022.
//

import SwiftUI

struct BaseQRCodeView: View {
    var image: Image
    
    //    var qr: Image {
    //        return Image(uiImage: image)
    //    }
    
    var body: some View {
        image
            .resizable()
            .interpolation(.none)
            .scaledToFit()
            .frame(width: 150, height: 150)
    }
}

//struct BaseQRCodeView_Previews: PreviewProvider {
//    static var previews: some View {
//        BaseQRCodeView(image: UIImage(systemName: "xmark.octagon")!)
//    }
//}
