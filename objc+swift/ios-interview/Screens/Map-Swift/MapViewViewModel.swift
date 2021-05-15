//
// Created by Michael Gray on 1/4/21.
// Copyright (c) 2021 Takeout Central. All rights reserved.
//

import CoreLocation
import Foundation
import MapKit
import RxCocoa
import RxSwift

final class MapViewViewModel {

    var address = ""
    var addressName = ""
    var destCoord = CLLocationCoordinate2D()
    var routes = [MKRoute]()
    var selectedRouteIndex = 0
    var routeOverlays = [MKPolyline]()
    var directions = [MKRoute.Step]()

    private(set) var mapInfo: MapInfo!
    private let orderRepository = OrderRepository()

    func loadMapInfo(for cartID: String) {
        mapInfo = orderRepository.mapInfo(cartID: cartID)
    }
}
