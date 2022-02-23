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
    
    func get<T>(
        type: T.Type,
        url: URL,
        headers: Headers
    ) -> AnyPublisher<T, Error> where T: Decodable
    
    func post<T>(
        url: URL,
        headers: Headers,
        params:T
    ) -> AnyPublisher<(data: Data, response: URLResponse), URLError> where T: Encodable
    
    func getData(url: URL, headers: Headers) -> AnyPublisher<Data, URLError>
}

final class Networker: NetworkerProtocol {
    
    func get<T>(
        type: T.Type,
        url: URL,
        headers: Headers
    ) -> AnyPublisher<T, Error> where T : Decodable {
        
        var urlRequest = URLRequest(url: url)
        
        headers.forEach { key, value in
            if let value = value as? String {
                urlRequest.setValue(value, forHTTPHeaderField: key)
            }
        }
        
        return URLSession.shared.dataTaskPublisher(for: urlRequest)
            .map(\.data)
            .decode(type: T.self, decoder: JSONDecoder())
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
    
    func getData(url: URL, headers: Headers) -> AnyPublisher<Data, URLError> {
        
        var urlRequest = URLRequest(url: url)
        
        headers.forEach { key, value in
            if let value = value as? String {
                urlRequest.setValue(value, forHTTPHeaderField: key)
            }
        }
        
        return URLSession.shared.dataTaskPublisher(for: urlRequest)
            .map(\.data)
            .eraseToAnyPublisher()
    }
}
