//
//  APIServiceModel.swift
//  Gap_International
//
//  Created by Vaibhav Rajani on 10/30/23.
//

import Foundation

struct LoginRequest: Encodable {
    let userName: String
    let password: String
}

struct SignUpRequest: Encodable {
    let userName: String
    let password: String
}

struct SaveCommentRequest: Encodable {
    let userName: String
    let chapterName: String
    let comment: String
    let level: Int
}
