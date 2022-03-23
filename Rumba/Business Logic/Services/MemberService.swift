//
//  MemberService.swift
//  Rumba
//
//  Created by Vladislav Shchukin on 22.03.2022.
//

import Foundation
import Combine

protocol MemberServiceProtocol: AnyObject {
    var networker: NetworkerProtocol { get }
    
    func addMember(to eventID: Int) -> AnyPublisher<Data, Error>
//    func deleteMember(from id: Int) -> AnyPublisher<Data, Error>
}

class MemberService: MemberServiceProtocol {
//    func deleteMember(from id: Int) -> AnyPublisher<Data, Error> {
//        
//    }
    
    var networker: NetworkerProtocol
    
    func addMember(to eventID: Int) -> AnyPublisher<Data, Error> {
        let endpoint = Endpoint.member(eventID: eventID)
        print(endpoint.path)
        
        return networker.get (
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
        .eraseToAnyPublisher()
    }
    
    init(networker: NetworkerProtocol = Networker()) {
        self.networker = networker
    }
    
}
