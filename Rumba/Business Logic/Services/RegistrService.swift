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
                        let errorResponse = try JSONDecoder().decode(ErrorResponse.self, from: data)
                        let error = MyError(
                            type: .init(rawValue: errorResponse.type),
                            message: errorResponse.message
                        )
                        throw error
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


struct MyError: Error {
    enum ErrorType: String {
         case ACCOUNT_NOT_CONFIRMED,
         CONFIRM_TOKEN_EXPIRED,
         CONFIRM_TOKEN_NOT_EXIST,
         EMAIL_CONFIRMED,
         EMAIL_EXIST,
         EMAIL_NOT_FOUND,
         INVALID_CREDENTIALS,
         JWT_EXPIRED
    }
    let type: ErrorType?
    let message: String
}

struct ErrorResponse: Decodable {
    let timestamp: String
    let type: String
    let path: String
    let message: String
    let status: Int
}
