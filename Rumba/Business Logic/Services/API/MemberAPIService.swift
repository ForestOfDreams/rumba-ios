//
//  MemberService.swift
//  Rumba
//
//  Created by Vladislav Shchukin on 22.03.2022.
//

import Foundation
import Combine

protocol MemberApiServiceProtocol: AnyObject {
    var networker: NetworkerProtocol { get }
    
    func addMember(to eventID: Int) -> AnyPublisher<Data, Error>
    func leaveEvent(_ id: Int) -> AnyPublisher<Data, Error>
    func tryAssignMemberToTask(taskID: Int, form: AssignMemberToTaskForm) -> AnyPublisher<Bool, Error>
    func assignMemberToTask(taskID: Int, form: AssignMemberToTaskForm) -> AnyPublisher<Data, Error>
}

class MemberApiService: MemberApiServiceProtocol {
    var networker: NetworkerProtocol
    
    private var encoder: JSONEncoder {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        return encoder
    }

    
    func tryAssignMemberToTask(taskID: Int, form: AssignMemberToTaskForm) -> AnyPublisher<Bool, Error> {
        let endpoint = Endpoint.tryAssignMemberToTask(id: taskID)
        
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
                let errorResponse = try JSONDecoder().decode(MyError.self, from: data)
                throw errorResponse
            }
            return data
        }
        .decode(type: Bool.self, decoder: JSONDecoder())
        .eraseToAnyPublisher()
    }
    
    func assignMemberToTask(taskID: Int, form: AssignMemberToTaskForm) -> AnyPublisher<Data, Error> {
        let endpoint = Endpoint.assignMemberToTask(id: taskID)
        
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
                let errorResponse = try JSONDecoder().decode(MyError.self, from: data)
                throw errorResponse
            }
            return data
        }
        .eraseToAnyPublisher()
    }
    
    func addMember(to eventID: Int) -> AnyPublisher<Data, Error> {
        let endpoint = Endpoint.member(eventID: eventID)
        
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
    
    func leaveEvent(_ id: Int) -> AnyPublisher<Data, Error> {
        let endpoint = Endpoint.leaveEvent(id: id)
        
        return networker.delete(
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
