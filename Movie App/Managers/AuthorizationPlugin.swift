//
//  AuthoriztionPlagin.swift
//  Movie App
//
//  Created by Bogdan on 21.01.2018.
//  Copyright © 2018 Bogdan Semeniuk. All rights reserved.
//

import Foundation
import Moya

class AuthorizationPlugin: PluginType {
    
    func prepare(_ request: URLRequest, target: TargetType) -> URLRequest {
        print(request.url?.absoluteString)
        return request
    }
}
