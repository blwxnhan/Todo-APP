//
//  TodoAPI.swift
//  TodoAPP_project
//
//  Created by Bowon Han on 12/20/23.
//

import Foundation

enum TodoAPI {
    static let baseURL = "http://hyeseong.na2ru2.me"

    case createTodo(_ id: Int,
                    _ title: String,
                    _ description: String,
                    _ endDate: Date)
    
    case modifyTodo(_ id: Int)
    case deleteTodo(_ id: Int)
    case fetchTodo
    
    var path: String{
        switch self {
        case .createTodo:
            return "/api/tasks/3"
        case .deleteTodo(let id):
            return "/api/tasks/\(id)"
        case .fetchTodo:
            return "/api/tasks/3"
        case .modifyTodo(let id):
            return "/api/tasks/\(id)"
        }
    }
    
    var method: String {
        switch self {
        case .createTodo:
            return "POST"
        case .deleteTodo:
            return "DELETE"
        case .fetchTodo:
            return "GET"
        case .modifyTodo:
            return "GET"
        }
    }
    
    var url: URL {
        return URL(string: TodoAPI.baseURL + path)!
    }
    
    var request: URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        return request
    }

    
    func performRequest() async throws {
        do {
            var request = self.request
            let encoder = JSONEncoder()

            if case .createTodo(let id, let title, let description, let endDate) = self {
                let todo = Todo(id: id, title: title, description: description, endDate: endDate)
                request.httpBody = try encoder.encode(todo)
            }

            let (data, response) = try await URLSession.shared.data(for: request)

            guard let httpResponse = response as? HTTPURLResponse,
                  (200..<300).contains(httpResponse.statusCode) else {
                throw FetchError.invalidStatus
            }

            print("Response data: \(data)")
        } catch {
            throw error
        }
    }
    

}

