//
//  RegistrService.swift
//  Rumba
//
//  Created by Владислав Щукин on 02.02.2022.
//

import Foundation
import Combine
import CoreLocation

protocol RegistrApiServiceProtocol: AnyObject {
    var networker: NetworkerProtocol { get }
    
    func registrUser(_ form: RegistrForm) -> AnyPublisher<Data, Error>
}

final class RegistrApiService: RegistrApiServiceProtocol {
    func registrUser(
        _ form: RegistrForm
    ) -> AnyPublisher<Data, Error> {
        let endpoint = Endpoint.registr
        
        return networker.post(
            url: endpoint.url,
            headers: endpoint.headers,
            params: form,
            encoder: JSONEncoder()
        )
        .tryMap { (data,response) -> Data in
            guard
                let response = response as? HTTPURLResponse,
                response.statusCode >= 200 && response.statusCode < 300 else {
                let errorResponse = try JSONDecoder().decode(ApiError.self, from: data)
                throw errorResponse
            }
            return data
        }
        .eraseToAnyPublisher()
    }
    
    let networker: NetworkerProtocol
    
    init(networker: NetworkerProtocol = Networker()) {
        self.networker = networker
    }
}
