//
//  OrderRepository.swift
//  ios-interview
//
//  Created by Mike on 5/15/21.
//

import Foundation

@objc
final class OrderRepository: NSObject {

    @objc
    func mapInfo(cartID: String) -> MapInfo {
        MapInfo(
            status: "accepted",
            customerAddress: "400 Market St 27516",
            restaurants: [
                RestaurantInfo(
                    restName: "Mediterranean Deli",
                    restAddress: "410 W Franklin St 27516",
                    status: .sent,
                    ready: true
                ),
                RestaurantInfo(
                    restName: "IP3 (Italian Pizzeria III)",
                    restAddress: "508 W Franklin St 27516",
                    status: .sent,
                    ready: true
                )
            ]
        )
    }
}
