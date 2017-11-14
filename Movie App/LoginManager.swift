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
    
    private func getToken() -> String {
        var token = ""
        provider.request(.getToken) { (result) in
            switch result {
            case let .success(moyaResponse):
                let responseData = moyaResponse.data
                let responseJSON = try? JSONSerialization.jsonObject(with: responseData, options: .allowFragments)
                guard let unwrappedJson = responseJSON as? Dictionary<String, Any> else { return }
                guard let unwrappedToken = unwrappedJson["request_token"] as? String else { return }
                token = unwrappedToken
            case let .failure(error):
                print(error.errorDescription ?? "Unknown error")
            }
        }
        return token
    }

    func login() {
        let token = getToken()
        
    }
    
    func logOut() {
    }
    
}
