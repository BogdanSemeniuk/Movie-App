//
//  LoginManager.swift
//  Movie App
//
//  Created by Богдан Семенюк on 14.11.2017.
//  Copyright © 2017 Bogdan Semeniuk. All rights reserved.
//

import UIKit
import Moya

class LoginManager: NSObject {
    
    private let provider = MoyaProvider<LoginAPI>()
    
    func getToken() -> String {
        var token = ""
        provider.request(.getToken) { (result) in
            switch result {
            case let .success(moyaResponse):
                let responseData = moyaResponse.data
                let responseJSON = try? JSONSerialization.jsonObject(with: responseData, options: .allowFragments)
                guard let unwrappedJson = responseJSON as? Dictionary<String, Any> else { return }
                guard let unwrappedToken = unwrappedJson["request_token"] as? String else { return }
                token = unwrappedToken
                
                guard let url = URL(string: "https://www.themoviedb.org/authenticate/\(token)?redirect_to=movieapp://approved") else { return }
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
                
            case let .failure(error):
                print(error.errorDescription ?? "Unknown error")
            }
        }
        return token
    }

    func login(token: String) -> String {
        var sessionId = ""
        provider.request(.getSessionId(token: token)) { (result) in
            switch result {
            case let .success(moyaResponse):
                let responseData = moyaResponse.data
                let responseJSON = try? JSONSerialization.jsonObject(with: responseData, options: .allowFragments)
                guard let unwrappedJson = responseJSON as? Dictionary<String, Any> else { return }
                guard let unwrappedSessionId = unwrappedJson["session_id"] as? String else { return }
                sessionId = unwrappedSessionId
            case let .failure(error):
                print(error.errorDescription ?? "Unknown error")
            }
        }
        return sessionId
    }
    
    func logOut() {
    }
    
}
