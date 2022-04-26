//
//  LinkService.swift
//  Rumba
//
//  Created by Vladislav Shchukin on 24.03.2022.
//

import Foundation
import UIKit
import SwiftUI
import CoreImage
import CoreImage.CIFilterBuiltins

protocol LinkServiceProtocol: AnyObject {
    func parseUrl(url: URL) -> Int?
    func generateQRCode(from string: String) -> UIImage?
}

class LinkService: LinkServiceProtocol {
    private let context = CIContext()
    private let qrGen = CIFilter.qrCodeGenerator()
    
    
    /// Get event id from url
    /// - Parameter url: url
    /// - Returns: event id
    func parseUrl(url: URL) -> Int? {
        var parameters: [String: String] = [:]
        URLComponents(url: url, resolvingAgainstBaseURL: false)?.queryItems?.forEach {
            parameters[$0.name] = $0.value
        }
        if let id = parameters.first?.value {
            return Int(id)
        }
        return nil
    }
    
    
    /// Create qr code from string
    /// - Parameter string: coding string
    /// - Returns: Optional QR image
    func generateQRCode(from string: String) -> UIImage? {
        qrGen.message = Data(string.utf8)
        
        if let outputImage = qrGen.outputImage {
            if let cgImg = context.createCGImage(outputImage, from: outputImage.extent) {
                return UIImage(cgImage: cgImg)
            }
        }
        return nil
    }
}
