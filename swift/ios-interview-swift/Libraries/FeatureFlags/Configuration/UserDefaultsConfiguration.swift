//
// Created by Mike on 1/25/21.
//

import Foundation

final public class UserDefaultsConfiguration {

    private let userDefaults: UserDefaults

    private static let prefix = "FeatureFlag"

    public init(userDefaults: UserDefaults) {
        self.userDefaults = userDefaults
    }
}

extension UserDefaultsConfiguration: Configuration {
    public var priority: Int { 100 }

    public func feature(named name: String) -> Feature? {
        let key = keyForFeature(named: name)
        guard let data = userDefaults.data(forKey: key) else { return nil }
        return try? JSONDecoder().decode(Feature.self, from: data)
    }
}

extension UserDefaultsConfiguration: MutableConfiguration {
    public func save(feature: Feature) {
        updateUserDefaults(feature: feature)
    }

    public func resetFeature(named name: Feature.Name) {
        let key = keyForFeature(named: name.rawValue)
        userDefaults.removeObject(forKey: key)
    }
}

extension UserDefaultsConfiguration {
    private func keyForFeature(named name: String) -> String {
        "\(UserDefaultsConfiguration.prefix).\(name)"
    }

    private func updateUserDefaults(feature: Feature) {
        let key = keyForFeature(named: feature.name.rawValue)
        guard let data = try? JSONEncoder().encode(feature) else { return }
        userDefaults.set(data, forKey: key)
    }
}
