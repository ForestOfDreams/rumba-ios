//
//  QRCodeView.swift
//  Rumba
//
//  Created by Vladislav Shchukin on 24.03.2022.
//

import SwiftUI

struct QRCodeView: View {
    var image: UIImage
    var shareAction : () -> Void
    
    var body: some View {
        BaseQRCodeView(image: Image(uiImage: image))
            .contextMenu {
                Button(action: shareAction) {
                    Label(
                        "share-invation-btn",
                        systemImage: "square.and.arrow.up"
                    )
                }
            }
    }
}

struct QRCodeView_Previews: PreviewProvider {
    static var previews: some View {
        QRCodeView(image: UIImage(systemName: "qrcode")!, shareAction: {})
    }
}
