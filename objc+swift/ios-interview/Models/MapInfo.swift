//
// Created by Michael Gray on 11/15/20.
// Copyright (c) 2020 Takeout Central. All rights reserved.
//

import Foundation

@objc(TCMapInfo)
final class MapInfo: NSObject {
    @objc let status: String
    @objc let customerAddress: String
    @objc let restaurants: [RestaurantInfo]

    init(status: String, customerAddress: String, restaurants: [RestaurantInfo]) {
        self.status = status
        self.customerAddress = customerAddress
        self.restaurants = restaurants
    }
}
