//
// Created by Michael Gray on 11/15/20.
// Copyright (c) 2020 Takeout Central. All rights reserved.
//

import Foundation

@objc(TCRestaurantInfo)
final class RestaurantInfo: NSObject, Decodable {
    @objc let restName: String
    @objc let restAddress: String
    let status: RestaurantStatus
    @objc var statusString: String { status.rawValue }
    @objc let ready: Bool

    init(restName: String, restAddress: String, status: RestaurantStatus, ready: Bool) {
        self.restName = restName
        self.restAddress = restAddress
        self.status = status
        self.ready = ready
    }
}
