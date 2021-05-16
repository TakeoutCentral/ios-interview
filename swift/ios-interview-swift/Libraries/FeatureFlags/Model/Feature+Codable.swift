//
// Created by Mike on 1/24/21.
// Copyright (c) 2021 Takeout Central. All rights reserved.
//

import Foundation
import GenericJSON

extension Feature: Codable {
    fileprivate enum CodingKeys: String, CodingKey {
        case name
        case displayName
        case description
        case type
        case parent
        case enabled
        case unlocked
        case value
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(Feature.Name.self, forKey: .name)
        displayName = try container.decode(String.self, forKey: .displayName)
        description = try container.decodeIfPresent(String.self, forKey: .description)
        type = try container.decode(FeatureType.self, forKey: .type)
        _parentName = try container.decodeIfPresent(Feature.Name.self, forKey: .parent)
        _enabled = try container.decode(Bool.self, forKey: .enabled)
        _unlocked = try container.decodeIfPresent(Bool.self, forKey: .unlocked)
        _value = try container.decodeIfPresent(JSON.self, forKey: .value)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(displayName, forKey: .displayName)
        try container.encodeIfPresent(description, forKey: .description)
        try container.encode(type, forKey: .type)
        try container.encodeIfPresent(_parentName, forKey: .parent)
        try container.encode(_enabled, forKey: .enabled)
        try container.encodeIfPresent(_unlocked, forKey: .unlocked)
        try container.encodeIfPresent(_value, forKey: .value)
    }
}
