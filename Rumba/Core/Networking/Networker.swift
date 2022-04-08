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
        params:T,
        encoder: JSONEncoder
    ) -> AnyPublisher<(data: Data, response: URLResponse), URLError> where T: Encodable
    
    func put<T>(
        url: URL,
        headers: Headers,
        params:T,
        encoder: JSONEncoder
    ) -> AnyPublisher<(data: Data, response: URLResponse), URLError> where T: Encodable
    
    func delete(
        url: URL,
        headers: Headers
    ) -> AnyPublisher<(data: Data, response: URLResponse), URLError>
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
        params:T,
        encoder: JSONEncoder
    ) -> AnyPublisher<(data: Data, response: URLResponse), URLError> where T: Encodable
    {
        var urlRequest = URLRequest(url: url)
        
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.httpMethod = "POST"
        headers.forEach { key, value in
            if let value = value as? String {
                urlRequest.setValue(value, forHTTPHeaderField: key)
            }
        }
        urlRequest.httpBody = try? encoder.encode(params)
        
        return URLSession.shared.dataTaskPublisher(for: urlRequest)
            .eraseToAnyPublisher()
    }
    
    func put<T>(
        url: URL,
        headers: Headers,
        params:T,
        encoder: JSONEncoder
    ) -> AnyPublisher<(data: Data, response: URLResponse), URLError> where T: Encodable
    {
        var urlRequest = URLRequest(url: url)
        
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.httpMethod = "PUT"
        headers.forEach { key, value in
            if let value = value as? String {
                urlRequest.setValue(value, forHTTPHeaderField: key)
            }
        }
        urlRequest.httpBody = try? encoder.encode(params)
        
        return URLSession.shared.dataTaskPublisher(for: urlRequest)
            .eraseToAnyPublisher()
    }
    
    func delete(
        url: URL,
        headers: Headers
    ) -> AnyPublisher<(data: Data, response: URLResponse), URLError> {
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "DELETE"
        headers.forEach { key, value in
            if let value = value as? String {
                urlRequest.setValue(value, forHTTPHeaderField: key)
            }
        }
        
        return URLSession.shared.dataTaskPublisher(for: urlRequest)
            .eraseToAnyPublisher()
    }
}
