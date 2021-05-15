//
// Created by Michael Gray on 10/30/20.
// Copyright (c) 2020 Takeout Central. All rights reserved.
//

import CocoaLumberjack
import Foundation

enum RestaurantStatus: String, Codable {
    case sent
    case atrest
    case pickedup
    case completed
    case unknown
}
