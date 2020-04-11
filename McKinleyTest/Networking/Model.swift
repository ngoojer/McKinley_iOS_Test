
//
//  Model.swift
//  McKinleyTest
//
//  Created by Narendra on 17/03/20.
//  Copyright © 2020 Narendra. All rights reserved.
//

struct LoginRequestModel: Encodable {
    let email: String
    let password: String
}

struct LoginResponseModel: Codable {
    let token: String
}

