//
//  MyError.swift
//  Rumba
//
//  Created by Vladislav Shchukin on 18.03.2022.
//

import Foundation


struct MyError: Error, Decodable {
    enum ErrorType: String, Decodable {
        case ACCOUNT_NOT_CONFIRMED,
             CONFIRM_TOKEN_EXPIRED,
             CONFIRM_TOKEN_NOT_EXIST,
             EMAIL_CONFIRMED,
             EMAIL_EXIST,
             EMAIL_NOT_FOUND,
             EVENT_NOT_FOUND,
             INVALID_CREDENTIALS,
             TASK_NOT_FOUND,
             VALIDATION_ERROR
    }
    let type: ErrorType?
    let message: String
}
