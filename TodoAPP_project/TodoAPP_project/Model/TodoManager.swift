//
//  TodoManager.swift
//  TodoAPP_project
//
//  Created by Bowon Han on 12/21/23.
//

import Foundation

class TodoManager{
    static let shared = TodoManager()
    
    var todoDataSource : [Todo] = []
    var accessToken : String = ""
    var refreshToken : String = ""
    
    private init() {}
}
