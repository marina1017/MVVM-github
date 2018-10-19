//
//  API.swift
//  MVVM-github
//
//  Created by 中川万莉奈 on 2018/09/26.
//  Copyright © 2018年 中川万莉奈. All rights reserved.
//

import Foundation

enum APIError: Error, CustomStringConvertible {
    case unknown
    case invalidURL
    case invalidResponse
    
    var description: String {
        switch self {
        case .unknown:
            return "不明なエラーです"
        case .invalidURL:
            return "無効なURLです"
        case .invalidResponse:
            return "フォーマットが無効なレスポンスをうけとった"
        }
    }
}

class API {

    func getUser(success: @escaping([User]) -> Void, failure: @escaping(Error) -> Void ){
        let requestURL = URL(string: "https://api.github.com/users")
        
        guard let url = requestURL else {
            failure(APIError.invalidURL)
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.timeoutInterval = 10
        
        let task = URLSession.shared.dataTask(with: request){ data, response, error in
            
            //ErrorがあったらErrorをClosureで返す
            if let error = error {
                DispatchQueue.main.async {
                    failure(error)
                }
                return
            }
            
            //dataがなかったら APIError.unknown ErrorをClosureで返す
            guard let data = data else {
                DispatchQueue.main.async {
                    failure(APIError.unknown)
                }
                return
            }
            
            //レスポンスのデータ方が不正だったらAPIError.invalidResponse　ErrorをClosureで返す
            guard let jsonOptional = try? JSONSerialization.jsonObject(with: data, options: []), let json = jsonOptional as? [[String: Any]] else {
                DispatchQueue.main.async {
                    failure(APIError.invalidResponse)
                }
                return
            }
            
            //for文でjsonからUserを作成し[User]についかし[User]をClosureで返す
            
            var users = [User]()
            for j in json {
                let user = User(attributes: j)
                users.append(user)
            }
            DispatchQueue.main.async {
                success(users)
            }
        }
        
        task.resume()
    }
}
