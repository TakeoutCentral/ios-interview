//
// Created by Mike on 1/24/21.
// Copyright (c) 2021 Takeout Central. All rights reserved.
//

import Foundation

public protocol RemoteConfig {
    func value<T: Decodable>(forKey key: String) -> T?
}

final public class RemoteConfiguration: Configuration {

    public let priority = 10

    private let remoteConfig: RemoteConfig

    public init(remoteConfig: RemoteConfig) {
        self.remoteConfig = remoteConfig
    }

    public func feature(named name: String) -> Feature? {
        remoteConfig.value(forKey: name)
    }
}
