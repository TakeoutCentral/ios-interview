//
// Created by Mike on 1/24/21.
// Copyright (c) 2021 Takeout Central. All rights reserved.
//

import Foundation

final public class LocalConfiguration: Configuration {

    public let priority = 0
    public let features: [Feature.Section]

    public init(jsonURL: URL) {
        // swiftlint:disable force_try

        let data = try! Data(contentsOf: jsonURL)
        features = try! JSONDecoder().decode([Feature.Section].self, from: data)

        // swiftlint:enable force_try
    }

    public func feature(named name: String) -> Feature? {
        var feature: Feature?
        for section in features {
            feature = section.features.first(where: { $0.name.rawValue == name })
            if feature != nil { break }
        }
        return feature
    }
}
