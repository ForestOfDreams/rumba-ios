//
//  ManageViewModel.swift
//  Rumba
//
//  Created by Vladislav Shchukin on 24.03.2022.
//

import Foundation
import SwiftUI

class ManageViewModel : ObservableObject {
    private var linkService: LinkServiceProtocol
    @Published var image: UIImage = UIImage(systemName: "xmark")!
    
//    @Published var qr: UIImage?
    
    func generateQR(link: String) {
        self.image = linkService.generateQRCode(from: link) ?? UIImage(systemName: "xmark")!
    }
    
    init() {
        linkService = LinkService()
    }
}
