//
//  registrForm.swift
//  Rumba
//
//  Created by Владислав Щукин on 02.02.2022.
//

import Foundation

struct RegistrForm: Encodable {
    var firstName: String
    var lastName: String
    var email: String
    var password: String
}
