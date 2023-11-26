//
//  Model.swift
//  TodoListProject
//
//  Created by Bowon Han on 11/19/23.
//

import Foundation

struct Model : Codable,Hashable {
    var list : [TodoListModel]
    let sectionName : String
}

struct TodoListModel : Codable,Hashable {
    var id = UUID().uuidString
    var success : Bool = false
    let todoNameLabel : String
    var startDate : Date?
    var endDate : Date?
}
