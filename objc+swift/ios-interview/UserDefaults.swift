//
//  UserDefaults.swift
//  ios-interview
//
//  Created by Mike on 5/15/21.
//

import Foundation

extension UserDefaults {
    static var preferredNav: Int {
        get {
            UserDefaults.standard.integer(forKey: "preferredNav")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "preferredNav")
        }
    }
}
