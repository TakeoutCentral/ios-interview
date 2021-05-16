//
// Created by Mike on 1/24/21.
// Copyright (c) 2021 Takeout Central. All rights reserved.
//

import Foundation

public protocol Configuration {
    var priority: Int { get }
    func feature(named name: String) -> Feature?
}

public protocol MutableConfiguration: Configuration {
    func save(feature: Feature)
    func resetFeature(named name: Feature.Name)
}
