//
//  TodoAPI.swift
//  TodoAPP_project
//
//  Created by Bowon Han on 12/20/23.
//

import Foundation

enum FetchError: Error {
    case invalidStatus
    case jsonDecodeError
}

enum TodoAPI {
    static let baseURL = "http://hyeseong.na2ru2.me/api"

    case createTodo(_ param: RequestDTO)
    case modifyTodoSuccess(id: Int)
    case deleteTodo(id: Int)
    case fetchAllTodo
    case fetchTodo (id: Int)
    case modifyTodo(id: Int, _ param: RequestDTO)
    
    var path: String{
        switch self {
        case .fetchAllTodo:
            return "/members/tasks"
        case .createTodo:
            return "/tasks"
        case .deleteTodo(let id),
             .fetchTodo(let id),
             .modifyTodo(let id,_):
            return "/tasks/\(id)"
        case .modifyTodoSuccess(let id):
            return "/tasks/finish/\(id)"
        }
    }
    
    var method: String {
        switch self {
        case .createTodo:
            return "POST"
            
        case .deleteTodo:
            return "DELETE"
            
        case .fetchAllTodo,
             .modifyTodoSuccess,
             .fetchTodo:
            return "GET"
            
        case .modifyTodo:
            return "PUT"
        }
    }
    
    var url: URL {
        return URL(string: TodoAPI.baseURL + path)!
    }
    
    var request: URLRequest {
        let token = TokenManager.shared.token.accessToken
        
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(token, forHTTPHeaderField: "Authentication")
        return request
    }
        
    func performRequest(with parameters: Encodable? = nil) async throws {
        //URLRequest 생성
        var request = self.request

        if let parameters = parameters {
            request.httpBody = try JSONEncoder().encode(parameters)
        }
        
        print(request)

        // 실제로 request를 보내서 network를 하는 부분
        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw FetchError.invalidStatus
        }
        
        //response가 200번대인지 확인하는 부분
        if (200..<300).contains(httpResponse.statusCode) {
            // Handle success (200번대)
            if case .fetchAllTodo = self {
                let todoList = try JSONDecoder().decode([RequestDTO].self, from: data)
                
                TodoManager.shared.todoAllDataSource = todoList
                
//                print("Todo List: \(TodoManager.shared.todoAllDataSource)")
            }
            else if case .fetchTodo = self {
                let dataContent = try JSONDecoder().decode(ErrorStatus.self, from: data)
                print("Response Data: \(dataContent.msg)")
                
                let todoList = try JSONDecoder().decode(Todo.self, from: data)
                TodoManager.shared.todoDataSource = todoList
            }
            else {
                let dataContent = try JSONDecoder().decode(ErrorStatus.self, from: data)
                print("Response Data: \(dataContent.msg)")
            }
        }
        else if (400..<600).contains(httpResponse.statusCode) {
            // Handle client error (4xx)
            let dataContent = try JSONDecoder().decode(ErrorStatus.self, from: data)
            print("Response Data: \(dataContent.msg)")
            print("error: \(httpResponse.statusCode)")
        }
    }
}
