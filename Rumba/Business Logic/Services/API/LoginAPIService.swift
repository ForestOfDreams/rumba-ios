//
//  LoginService.swift
//  Rumba
//
//  Created by Vladislav Shchukin on 24.02.2022.
//

import Foundation
import Combine

protocol LoginApiServiceProtocol: AnyObject {
    var networker: NetworkerProtocol { get }
    
    func loginUser(_ form: LoginForm) -> AnyPublisher<LoginResponse, Error>
}

final class LoginApiService:LoginApiServiceProtocol {
    private var decoder: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return decoder
    }
    var networker: NetworkerProtocol
    
    func loginUser(_ form: LoginForm) -> AnyPublisher<LoginResponse, Error> {
        let endpoint = Endpoint.login
        
        return networker.post(
            url: endpoint.url,
            headers: endpoint.authHeaders,
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
        .decode(type: LoginResponse.self, decoder: decoder)
        .eraseToAnyPublisher()
    }
    
    init(networker: NetworkerProtocol = Networker()) {
        self.networker = networker
    }
}
