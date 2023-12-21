//
//  Model.swift
//  TodoListProject
//
//  Created by Bowon Han on 11/19/23.
//

import Foundation

struct Model : Codable {
    var list : [TodoListModel]
    let sectionName : String
}

//mutating 

struct TodoListModel : Codable {
    var success : Bool = false
    let todoNameLabel : String
    var startDate : Date?
    var endDate : Date?
}
