//
// Created by Mike on 1/24/21.
// Copyright (c) 2021 Takeout Central. All rights reserved.
//

import Foundation

extension Feature {
    public struct Section: Codable {
        public let name: String
        public let features: [Feature]

        public init(name: String, features: [Feature]) {
            self.name = name
            self.features = features
        }

        enum CodingKeys: String, CodingKey {
            case name = "section"
            case features
        }
    }
}
