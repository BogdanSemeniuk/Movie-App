//
//  Keychain.swift
//  Movie App
//
//  Created by Богдан Семенюк on 18.11.2017.
//  Copyright © 2017 Bogdan Semeniuk. All rights reserved.
//

import Foundation
import KeychainSwift

class Keychain: KeychainSwift {
    static let sharedStorage = Keychain()
}
