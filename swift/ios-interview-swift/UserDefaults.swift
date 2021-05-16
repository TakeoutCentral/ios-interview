//
//  UserDefaults.swift
//  ios-interview-swift
//
//  Created by Mike on 5/16/21.
//

import Foundation

extension UserDefaults {
    static var userChecklistState: ChecklistState? {
        get {
            if let value = UserDefaults.standard.object(forKey: "userChecklistState")
                as? ChecklistState.RawValue {
                return ChecklistState(rawValue: value)
            } else {
                return .required
            }
        }
        set {
            if let value = newValue {
                UserDefaults.standard.set(value.rawValue, forKey: "userChecklistState")
            } else {
                UserDefaults.standard.removeObject(forKey: "userChecklistState")
            }
        }
    }
}
