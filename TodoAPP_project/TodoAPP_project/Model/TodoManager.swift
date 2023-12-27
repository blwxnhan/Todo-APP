//
//  TodoManager.swift
//  TodoAPP_project
//
//  Created by Bowon Han on 12/21/23.
//

import Foundation

class TodoManager{
    var todoTodayDataSource : [Todo] = []
    var todoUpcomingDataSource : [Todo] = []
    var todoExpireDataSource : [Todo] = []
    
    static let shared = TodoManager()

    private init() {}
    
    func classifyTodo(_ allTodos :[Todo]) {
        let dateFormatter: DateFormatter = .init()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        let currentDate : Date = .now
        let current = currentDate.toString()
        
        for todo in allTodos {
            if let dueDate = todo.endDate {
                if let targetDate: Date = dateFormatter.date(from: current),
                   let fromDate: Date = dateFormatter.date(from: dueDate) {
                      switch targetDate.compare(fromDate) {
                      case .orderedSame: todoTodayDataSource.append(todo)
                      case .orderedDescending: todoExpireDataSource.append(todo)
                      case .orderedAscending: todoUpcomingDataSource.append(todo)
                      }
                }
            }
        }
    }
}
