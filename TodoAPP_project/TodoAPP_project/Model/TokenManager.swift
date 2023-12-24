//
//  TokenUserDefaults.swift
//  TodoAPP_project
//
//  Created by Bowon Han on 12/24/23.
//

import Foundation

//class TokenUserDefaults {
//    static let token = TokenUserDefaults()
//    let todoList = "todoList"
//    
//    var tokens : TokenModel?
//    
//    let userDefaults = UserDefaults.standard
//        
//    private init() {}
//
//    func saveAllData() {
//        let encoder = JSONEncoder()
//        if let encoded = try? encoder.encode(tokens){
//            userDefaults.set(encoded, forKey: todoList)
//        }
//    }
//            
//    func loadAllData() {
//        if let savedData = userDefaults.object(forKey: todoList) as? Data{
//            let decoder = JSONDecoder()
//            if let savedObject = try? decoder.decode(TokenModel.self, from: savedData){
//                tokens = savedObject
//            }
//        }
//    }
//}

class TokenManager {
    static let shared = TokenManager()
    
    var token : TokenModel?
    
    private init() {}
}
