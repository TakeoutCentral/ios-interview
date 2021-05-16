//
// Created by Mike on 5/12/21.
// Copyright (c) 2021 Takeout Central. All rights reserved.
//

public struct OrderCartInfo {
    public let orderName: String
    public let instructions: String?
    public let restStatus: DriverStatus
    public var items: [Item]

    public init(orderName: String, instructions: String?, restStatus: DriverStatus, items: [Item]) {
        self.orderName = orderName
        self.instructions = instructions
        self.restStatus = restStatus
        self.items = items
    }
}

extension OrderCartInfo {
    public enum Item {
        case item(name: String, quantity: Int, pickedUp: Bool, rowID: Int64)
        case option(name: String)
        case whofor(who: String)
        case comment(comment: String)
    }
}
