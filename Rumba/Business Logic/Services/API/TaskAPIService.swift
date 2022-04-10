//
//  TaskAPIService.swift
//  Rumba
//
//  Created by Vladislav Shchukin on 01.04.2022.
//

import Foundation


import Foundation
import Combine

protocol TaskApiServiceProtocol: AnyObject {
    var networker: NetworkerProtocol { get }
    
    func createTask(task form: TaskForm, eventId: Int) -> AnyPublisher<Data, Error>
    func updateTask(taskId: Int, task form: TaskForm) -> AnyPublisher<Data, Error>
    func deleteTask(taskId: Int) -> AnyPublisher<Data, Error>
    func getMyTask(eventId: Int) -> AnyPublisher<Task, Error>
}

final class TaskAPIService: TaskApiServiceProtocol {
    var networker: NetworkerProtocol
    
    private var decoder: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return decoder
    }
    
    private var encoder: JSONEncoder {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        return encoder
    }
    
    init(networker: NetworkerProtocol = Networker()) {
        self.networker = networker
    }
    
    func createTask(task form: TaskForm, eventId: Int) -> AnyPublisher<Data, Error> {
        let endpoint = Endpoint.createTask(eventID: eventId)
        
        return networker.post(
            url: endpoint.url,
            headers: endpoint.authHeaders,
            params: form,
            encoder: encoder
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
    
    func updateTask(taskId: Int, task form: TaskForm) -> AnyPublisher<Data, Error> {
        let endpoint = Endpoint.updateTask(id: taskId)
        
        return networker.put(
            url: endpoint.url,
            headers: endpoint.authHeaders,
            params: form,
            encoder: encoder
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
    
    func deleteTask(taskId: Int) -> AnyPublisher<Data, Error> {
        let endpoint = Endpoint.deleteTask(id: taskId)
        
        return networker.delete(
            url: endpoint.url,
            headers: endpoint.authHeaders
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
    
    func getMyTask(eventId: Int) -> AnyPublisher<Task, Error> {
        let endpoint = Endpoint.getMyTask(eventID: eventId)
        
        return networker.get(
            url: endpoint.url,
            headers: endpoint.authHeaders
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
        .decode(type: Task.self, decoder: decoder)
        .eraseToAnyPublisher()
    }
}
