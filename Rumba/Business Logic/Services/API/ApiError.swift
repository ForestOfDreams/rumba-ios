//
//  MyError.swift
//  Rumba
//
//  Created by Vladislav Shchukin on 18.03.2022.
//

import Foundation


struct ApiError: Error, Decodable {
    enum ErrorType: String, Decodable {
        case ACCOUNT_NOT_CONFIRMED,
             CONFIRM_TOKEN_EXPIRED,
             CONFIRM_TOKEN_NOT_EXIST,
             EMAIL_CONFIRMED,
             EMAIL_EXIST,
             EMAIL_NOT_FOUND,
             EVENT_NOT_FOUND,
             FORBIDDEN,
             INVALID_CREDENTIALS,
             INVALID_DATES,
             MEMBER_ALREADY_EXIST,
             MEMBER_NOT_FOUND,
             TASK_NOT_FOUND,
             VALIDATION_ERROR
    }
    let type: ErrorType?
    let messages: [String]
}
