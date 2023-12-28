//
//  TodoManager.swift
//  TodoAPP_project
//
//  Created by Bowon Han on 12/21/23.
//

import Foundation

class TodoManager{
    var todoAllDataSource : [Todo] = []
    
    static let shared = TodoManager()

    private init() {}
}
