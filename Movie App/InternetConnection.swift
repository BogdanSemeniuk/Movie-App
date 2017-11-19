//
//  InternetConnection.swift
//  Movie App
//
//  Created by Богдан Семенюк on 19.11.2017.
//  Copyright © 2017 Bogdan Semeniuk. All rights reserved.
//

import Foundation
import Alamofire

class InternetConnection {
    
    static let shared = InternetConnection()
    
    private let manager = NetworkReachabilityManager()!
    
    var isConnectedToInternet:Bool {
        return manager.isReachable
    }
}
