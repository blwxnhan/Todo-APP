//
//  TokenUserDefaults.swift
//  TodoAPP_project
//
//  Created by Bowon Han on 12/24/23.
//

import Foundation

class TokenManager {
    static let shared = TokenManager()
    
    var token = Token.init(accessToken: "")
    
    private init() {}
}
