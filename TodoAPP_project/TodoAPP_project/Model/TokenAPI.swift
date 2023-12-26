//
//  LoginAPI.swift
//  TodoAPP_project
//
//  Created by Bowon Han on 12/24/23.
//

import Foundation

enum TokenAPI {
    static let authenticationURL = "http://hyeseong.na2ru2.me/api/members"
    
    case login (_ id: String,_ password: String)
    case join (_ param: Member)
    
    var path: String{
        switch self {
        case .login(let id, let password):
            return "/login?id=\(id)&password=\(password)"
        case .join:
            return ""
        }
    }
    
    var method: String {
        switch self {
        case .login,
             .join:
            return "POST"
        }
    }
    
    var url: URL {
        let url = TokenAPI.authenticationURL + path
        return URL(string: url.stringByAddingPercentEncodingForRFC3986() ?? "")!
    }
    
    var request: URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        return request
    }
    
    func performRequest(with parameters: Encodable? = nil) async throws -> Bool{
        //URLRequest 생성
        var request = self.request

        if let parameters = parameters {
            request.httpBody = try JSONEncoder().encode(parameters)
        }
        
        print(request)

        // 실제로 request를 보내서 network를 하는 부분
        let (data, response) = try await URLSession.shared.data(for: request)
        print(data)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw FetchError.invalidStatus
        }
        
        //response가 200번대인지 확인하는 부분
        if (200..<300).contains(httpResponse.statusCode) {
            // Handle success (200번대)
            if case .login = self {
//                let loginToken = try JSONDecoder().decode(Token.self, from: data)
                let loginToken = String(decoding: data, as: UTF8.self)
                print(loginToken)
                TokenManager.shared.token?.accessToken = loginToken
                return true
            }
            else {
                let dataContent = try JSONDecoder().decode(ErrorStatus.self, from: data)
                print("Response Data: \(dataContent.msg)")
                return false
            }
        }
        else if (400..<500).contains(httpResponse.statusCode) {
            let dataContent = try JSONDecoder().decode(ErrorStatus.self, from: data)
            print("Response Data: \(dataContent.msg)")
            print("error: \(httpResponse.statusCode)")
            return false
        }
        return false
    }
}
