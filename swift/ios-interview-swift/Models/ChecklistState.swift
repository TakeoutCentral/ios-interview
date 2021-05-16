//
// Created by Mike on 2/2/21.
// Copyright (c) 2021 Takeout Central. All rights reserved.
//

import Foundation

enum ChecklistState: Int, Codable {
    case off
    case enabled
    case required
}

extension ChecklistState: CaseIterable {
    init(rawValue: Int) {
        if let value = Self.allCases.first(where: { $0.rawValue == rawValue }) {
            self = value
        } else {
            self = .required
        }
    }
}

extension ChecklistState: CustomStringConvertible {
    public var description: String {
        switch self {
        case .off: return "Off"
        case .enabled: return "Enabled"
        case .required: return "Required"
        }
    }
}
