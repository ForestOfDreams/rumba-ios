//
//  RegistrService.swift
//  Rumba
//
//  Created by Владислав Щукин on 02.02.2022.
//

import Foundation
import Combine
import CoreLocation


protocol RegistrServiceProtocol: AnyObject {
    var networker: NetworkerProtocol { get }
    
    func registrUser(_ form: RegistrForm) -> AnyPublisher<RegistrResponse, Error>
}

final class RegistrService: RegistrServiceProtocol {
    func registrUser(
        _ form: RegistrForm
    ) -> AnyPublisher<RegistrResponse, Error> {
        let endpoint = Endpoint.registr
        
        return networker.post(
            url: endpoint.url,
            headers: endpoint.headers,
            params: form
        )
        .tryMap { (data,response) -> Data in
            guard
                let response = response as? HTTPURLResponse,
                response.statusCode >= 200 && response.statusCode < 300 else {
                let errorResponse = try JSONDecoder().decode(MyError.self, from: data)
                throw errorResponse
            }
            return data
        }
        .decode(type: RegistrResponse.self, decoder: JSONDecoder())
        .eraseToAnyPublisher()
    }
    
    let networker: NetworkerProtocol
    
    init(networker: NetworkerProtocol = Networker()) {
        self.networker = networker
    }
}


struct ErrorResponse: Decodable {
    let timestamp: String
    let type: String
    let path: String
    let message: String
    let status: Int
}
