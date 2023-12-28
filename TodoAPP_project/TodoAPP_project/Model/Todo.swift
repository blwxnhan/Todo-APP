//
//  Todo.swift
//  TodoAPP_project
//
//  Created by Bowon Han on 11/26/23.
//


import Foundation

struct Todo : Codable {
    let id : Int
    var title : String
    var description : String?
    var endDate : String?
    var isFinished : Bool
    
    enum Section {
        case expire
        case upcoming
        case today
    }
        
    var section: Section {
        if let endDate = endDate{
            let currentDate : Date = .now
            let current = currentDate.toString()

            if let targetDate: Date = dateFormatter.date(from: current),
               let fromDate: Date = dateFormatter.date(from: endDate) {
                  switch targetDate.compare(fromDate) {
                  case .orderedSame:
                      return .today
                  case .orderedDescending:
                      return .expire
                  case .orderedAscending:
                      return .upcoming
                  }
            }
            
        } else {
            return .today
        }
        return .today
    }
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }
}

//class classify {
//    func classifyTodos(_ allTodos :[Todo]) {
//        let todoManager = TodoManager.shared
//        
//        let dateFormatter: DateFormatter = .init()
//        dateFormatter.dateFormat = "yyyy-MM-dd"
//        
//        let currentDate : Date = .now
//        let current = currentDate.toString()
//        
//        todoManager.todoExpireDataSource = []
//        todoManager.todoTodayDataSource = []
//        todoManager.todoUpcomingDataSource = []
//        
//        for todo in allTodos {
//            if let dueDate = todo.endDate {
//                if let targetDate: Date = dateFormatter.date(from: current),
//                   let fromDate: Date = dateFormatter.date(from: dueDate) {
//                      switch targetDate.compare(fromDate) {
//                      case .orderedSame:
//                          TodoManager.shared.todoTodayDataSource.append(todo)
//                      case .orderedDescending:
//                          TodoManager.shared.todoExpireDataSource.append(todo)
//                      case .orderedAscending:
//                          TodoManager.shared.todoUpcomingDataSource.append(todo)
//                      }
//                }
//            }
//        }
//    }
//}

