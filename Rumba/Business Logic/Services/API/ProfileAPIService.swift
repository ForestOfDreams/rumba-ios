//
//  ProfileService.swift
//  Rumba
//
//  Created by Vladislav Shchukin on 25.03.2022.
//

import Foundation
import Combine

protocol ProfileApiServiceProtocol: AnyObject {
    var networker: NetworkerProtocol { get }
    
    func getCurrentUser() -> AnyPublisher<User, Error>
}

final class ProfileApiService: ProfileApiServiceProtocol {
    var networker: NetworkerProtocol
    
    init() {
        networker = Networker()
    }
    
    func getCurrentUser() -> AnyPublisher<User, Error> {
        let endpoint = Endpoint.getCurrentUser
        
        return networker.get(
            url: endpoint.url,
            headers: endpoint.authHeaders
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
        .decode(type: User.self, decoder: JSONDecoder())
        .eraseToAnyPublisher()
    }
}
