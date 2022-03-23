//
//  EventService.swift
//  Rumba
//
//  Created by Vladislav Shchukin on 22.03.2022.
//

import Foundation
import Combine

protocol EventServiceProtocol: AnyObject {
    var networker: NetworkerProtocol { get }
    
    func createEvent(_ form: CreateEventForm) -> AnyPublisher<Data, Error>
    //    func updateEvent(_ form: UpdateEventForm) -> AnyPublisher<UpdateEventResponse, Error>
    //    func getCreatedEvents(_ form: GetCreatedEventsForm) -> AnyPublisher<GetCreatedEventsResponse, Error>
    func getParicipationEvents() -> AnyPublisher<[GetParicipatedEventsResponse], Error>
    func getEvent(_ id: Int) -> AnyPublisher<GetEventResponse, Error>
}

final class EventService: EventServiceProtocol {
    
    var networker: NetworkerProtocol
    
    private var decoder: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return decoder
    }
    
    init(networker: NetworkerProtocol = Networker()) {
        self.networker = networker
    }
    
    func createEvent(_ form: CreateEventForm) -> AnyPublisher<Data, Error> {
        let endpoint = Endpoint.login
        
        return networker.post(
            url: endpoint.url,
            headers: endpoint.authHeaders,
            params: form
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
        //        .decode(type: LoginResponse.self, decoder: decoder)
        .eraseToAnyPublisher()
        
    }
    
    //    func updateEvent(_ form: UpdateEventForm) -> AnyPublisher<UpdateEventResponse, Error> {
    //
    //    }
    
    //    func getCreatedEvents(_ form: GetCreatedEventsForm) -> AnyPublisher<GetCreatedEventsResponse, Error> {
    //
    //    }
    
    func getParicipationEvents() -> AnyPublisher<[GetParicipatedEventsResponse], Error> {
        let endpoint = Endpoint.getParicipatedEvents
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
        .decode(type: [GetParicipatedEventsResponse].self, decoder: decoder)
        .eraseToAnyPublisher()
    }
    
    func getEvent(_ id: Int) -> AnyPublisher<GetEventResponse, Error> {
        let endpoint = Endpoint.getEvent(id: id)
        
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
        .decode(type: GetEventResponse.self, decoder: decoder)
        .eraseToAnyPublisher()
    }
}
