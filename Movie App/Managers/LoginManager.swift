//
//  LoginManager.swift
//  Movie App
//
//  Created by Богдан Семенюк on 14.11.2017.
//  Copyright © 2017 Bogdan Semeniuk. All rights reserved.
//

import Foundation
import Moya
import KeychainSwift

class LoginManager {

    private lazy var provider = MoyaProvider<LoginAPI>()
    private var token = ""
    
    var isLogined: Bool {
        return Keychain.sharedStorage.get("session") != nil
    }
    
    func getTokenAndRedirectToApp() {
        provider.request(.getToken) { (result) in
            switch result {
            case let .success(moyaResponse):
                let responseData = moyaResponse.data
                let responseJSON = try? JSONSerialization.jsonObject(with: responseData, options: .allowFragments)
                guard let unwrappedJson = responseJSON as? Dictionary<String, Any> else { return }
                guard let unwrappedToken = unwrappedJson["request_token"] as? String else { return }
                self.token = unwrappedToken
                
                guard let url = URL(string: "https://www.themoviedb.org/authenticate/\(self.token)?redirect_to=movieapp://approved") else { return }
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            case let .failure(error):
                print(error.errorDescription ?? "Unknown error")
            }
        }
    }

    func getSessionId(complition: @escaping () -> Void) {
        provider.request(.getSessionId(token: token)) { (result) in
            switch result {
            case let .success(moyaResponse):
                let responseData = moyaResponse.data
                let responseJSON = try? JSONSerialization.jsonObject(with: responseData, options: .allowFragments)
                guard let unwrappedJson = responseJSON as? Dictionary<String, Any> else { return }
                guard let unwrappedSessionId = unwrappedJson["session_id"] as? String else { return }
                let sessionId = unwrappedSessionId
                Keychain.sharedStorage.set(sessionId, forKey: "session")
                complition()
            case let .failure(error):
                print(error.errorDescription ?? "Unknown error")
            }
        }
    }
}
