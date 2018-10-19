//
//  User.swift
//  MVVM-github
//
//  Created by 中川万莉奈 on 2018/09/26.
//  Copyright © 2018年 中川万莉奈. All rights reserved.
//

import Foundation

final class User {
    let id: Int
    let name: String
    let iconUrl: String
    let webUrl: String
    
    init(attributes: [String: Any]) {
        id = attributes["id"] as! Int
        name = attributes["login"] as! String
        iconUrl = attributes["avatar_url"] as! String
        webUrl = attributes["url"] as! String
     }
}
