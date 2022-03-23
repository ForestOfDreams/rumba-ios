//
//  Networker.swift
//  Rumba
//
//  Created by Владислав Щукин on 01.02.2022.
//

import Foundation
import Combine

protocol NetworkerProtocol: AnyObject {
    typealias Headers = [String: Any]
    
    func get(
        url: URL,
        headers: Headers
    ) -> AnyPublisher<(data: Data, response: URLResponse), URLError>
    
    func post<T>(
        url: URL,
        headers: Headers,
        params:T
    ) -> AnyPublisher<(data: Data, response: URLResponse), URLError> where T: Encodable
}

final class Networker: NetworkerProtocol {
    
    func get(
        url: URL,
        headers: Headers
    ) -> AnyPublisher<(data: Data, response: URLResponse), URLError> {
        
        var urlRequest = URLRequest(url: url)
        
        headers.forEach { key, value in
            if let value = value as? String {
                urlRequest.setValue(value, forHTTPHeaderField: key)
            }
        }
        
        return URLSession.shared.dataTaskPublisher(for: urlRequest)
            .eraseToAnyPublisher()
    }
    
    func post<T>(
        url: URL,
        headers: Headers,
        params:T
    ) -> AnyPublisher<(data: Data, response: URLResponse), URLError> where T: Encodable {
        
        var urlRequest = URLRequest(url: url)
        
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.httpMethod = "POST"
        headers.forEach { key, value in
            if let value = value as? String {
                urlRequest.setValue(value, forHTTPHeaderField: key)
            }
        }
        
        let encoder = JSONEncoder()
        
        urlRequest.httpBody = try? encoder.encode(params)
        
        return URLSession.shared.dataTaskPublisher(for: urlRequest)
            .eraseToAnyPublisher()
    }
}
