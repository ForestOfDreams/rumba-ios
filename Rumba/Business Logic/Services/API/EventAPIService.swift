//
//  EventService.swift
//  Rumba
//
//  Created by Vladislav Shchukin on 22.03.2022.
//

import Foundation
import Combine

protocol EventApiServiceProtocol: AnyObject {
    var networker: NetworkerProtocol { get }
    
    func createEvent( _ form: EventForm) -> AnyPublisher<Data, Error>
    func updateEvent(eventId: Int, event form: EventForm) -> AnyPublisher<Data, Error>
    func getCreatedEvents() -> AnyPublisher<[Event], Error>
    func getParicipatedEvents() -> AnyPublisher<[Event], Error>
    func getEvent(_ id: Int) -> AnyPublisher<Event, Error>
}

final class EventApiService: EventApiServiceProtocol {
    
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
    
    func createEvent( _ form: EventForm) -> AnyPublisher<Data, Error> {
        let endpoint = Endpoint.createEvent
        
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
    
    func updateEvent(eventId: Int, event form: EventForm) -> AnyPublisher<Data, Error> {
        let endpoint = Endpoint.updateEvent(id: eventId)
        
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
    
    func getCreatedEvents() -> AnyPublisher<[Event], Error> {
        let endpoint = Endpoint.getCreatedEvents
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
        .decode(type: [Event].self, decoder: decoder)
        .eraseToAnyPublisher()
    }
    
    func getParicipatedEvents() -> AnyPublisher<[Event], Error> {
        let endpoint = Endpoint.getParicipatedEvents
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
        .decode(type: [Event].self, decoder: decoder)
        .eraseToAnyPublisher()
    }
    
    func getEvent(_ id: Int) -> AnyPublisher<Event, Error> {
        let endpoint = Endpoint.getEvent(id: id)
        
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
        .decode(type: Event.self, decoder: decoder)
        .eraseToAnyPublisher()
    }
}
