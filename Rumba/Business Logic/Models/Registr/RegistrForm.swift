//
//  registrForm.swift
//  Rumba
//
//  Created by Владислав Щукин on 02.02.2022.
//

import Foundation

struct RegistrForm: Encodable {
    let firstName: String
    let lastName: String
    let email: String
    let password: String
}
