//
//  ManageView.swift
//  Rumba
//
//  Created by Vladislav Shchukin on 21.03.2022.
//

import SwiftUI
import CoreImage
import CoreImage.CIFilterBuiltins

struct ManageView: View {
    @State private var qrCode = UIImage()
    
    let context = CIContext()
    let filter = CIFilter.qrCodeGenerator()
    
    var body: some View {
        NavigationView {
            Image(uiImage: qrCode)
                .resizable()
                .interpolation(.none)
                .scaledToFit()
                .frame(width: 200, height: 200)
                .contextMenu {
                    Button(action: actionSheet) {
                        Label("Share invation", systemImage: "square.and.arrow.up")
                    }
                }
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
                            
                        } label: {
                            Image(systemName: "plus.square")
                        }
                        
                    }
                }
            
        }
        .onAppear {
            qrCode = generateQRCode(from: "rumba-app.herokuapp.com://join?id=1")
        }
    }
    
    func actionSheet() {
        guard let urlShare = URL(string: "rumba-app.herokuapp.com://join?id=1") else { return }
        
        // set up activity view controller
        let activityViewController = UIActivityViewController(activityItems: [urlShare, qrCode], applicationActivities: nil)
        
        // present the view controller
        UIApplication.shared.windows.first?.rootViewController?.present(activityViewController, animated: true, completion: nil)
    }
    
    
    func generateQRCode(from string: String) -> UIImage {
        filter.message = Data(string.utf8)
        
        if let outputImage = filter.outputImage {
            if let cgimg = context.createCGImage(outputImage, from: outputImage.extent) {
                return UIImage(cgImage: cgimg)
            }
        }
        
        return UIImage(systemName: "xmark.circle") ?? UIImage()
    }
}

struct ManageView_Previews: PreviewProvider {
    static var previews: some View {
        ManageView()
    }
}
