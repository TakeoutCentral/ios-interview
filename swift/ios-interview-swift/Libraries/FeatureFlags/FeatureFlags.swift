//
// Created by Mike on 1/24/21.
// Copyright (c) 2021 Takeout Central. All rights reserved.
//

import Foundation

public class FeatureFlags {
    public static let shared = FeatureFlags()
    private init() {}

    private(set) var configurations = [Configuration]()
//    var mutableConfiguration:
    public var useCache = true {
        didSet {
            if useCache != oldValue {
                resetCache()
            }
        }
    }

    private let queue = DispatchQueue(label: "takeoutcentral.featureflags")
    internal var cache = [String : Feature]()

    public func add(configuration: Configuration) {
        configurations.append(configuration)
        configurations.sort { $0.priority > $1.priority }
    }

    public func feature(named name: Feature.Name) -> Feature {
        guard let feature = feature(named: name.rawValue) else {
            preconditionFailure()
        }
        return feature
    }

    public func feature(named name: String) -> Feature? {
        queue.sync {
            if useCache, let feature = cache[name] {
                return feature
            }

            for configuration in configurations {
                if let feature = configuration.feature(named: name) {
                    if useCache {
                        cache[name] = feature
                    }
                    return feature
                }
            }

            return nil
        }
    }

    internal func cache(feature: Feature) {
        guard useCache else { return }
        queue.sync {
            cache[feature.name.rawValue] = feature
        }
    }
}

extension FeatureFlags {
    public func resetCache() {
        queue.sync {
            cache = [:]
        }
    }
}
