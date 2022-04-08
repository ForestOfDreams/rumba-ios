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
}

final class ProfileApiService: ProfileApiServiceProtocol {
    var networker: NetworkerProtocol
    
    init() {
        networker = Networker()
    }
}
