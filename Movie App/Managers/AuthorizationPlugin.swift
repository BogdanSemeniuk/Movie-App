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
    let sessionId = Keychain.sharedStorage.get("session")
    func prepare(_ request: URLRequest, target: TargetType) -> URLRequest {
        guard let urlString = request.url?.absoluteString else {return request}
        let newUrlString = urlString + "?api_key=\(apiKey)&session_id=\(sessionId!)"
        
        var newRequest = request
        newRequest.url = URL(string: newUrlString)
        
        return newRequest
    }
}
