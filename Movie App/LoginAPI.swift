//
//  MoyaService.swift
//  Movie App
//
//  Created by Богдан Семенюк on 14.11.2017.
//  Copyright © 2017 Bogdan Semeniuk. All rights reserved.
//

import Foundation
import Moya

let apiKey = "85cfecbf4366c6b833864140f4bc428c"

enum LoginAPI {
    case getToken
}

extension LoginAPI: TargetType {
    var baseURL: URL {
        return URL(string: "https://api.themoviedb.org/3")!
    }

    var path: String {
        return "authentication/token/new"
    }

    var method: Moya.Method {
        return .get
    }

    var sampleData: Data {
        return Data()
    }

    var task: Task {
        return .requestParameters(parameters: ["api_key":apiKey], encoding: URLEncoding.queryString)
    }

    var headers: [String : String]? {
        return [:]
    }
}

