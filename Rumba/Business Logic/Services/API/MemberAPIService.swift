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
}

class MemberApiService: MemberApiServiceProtocol {
    var networker: NetworkerProtocol
    
    func tryAssignMemberToTask(taskID: Int, form: AssignMemberToTaskForm) -> AnyPublisher<Bool, Error> {
        let endpoint = Endpoint.tryAssignMemberToTask(id: taskID)
        
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
                let errorResponse = try JSONDecoder().decode(MyError.self, from: data)
                throw errorResponse
            }
            return data
        }
        .decode(type: Bool.self, decoder: JSONDecoder())
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
