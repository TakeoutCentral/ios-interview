//
//  OrderRepository.swift
//  ios-interview-swift
//
//  Created by Mike on 5/16/21.
//

import Foundation
import RxSwift

final class OrderRepository {

    func cartInfo(cartID: String) -> Observable<[OrderCartInfo]> {
        // Stub
        .create { observer in
            observer.onNext([
                OrderCartInfo(
                    orderName: "MedDeli 42",
                    instructions: "Extra spicy",
                    restStatus: .atrest,
                    items: [
                        .item(name: "Falafel Salad", quantity: 1, pickedUp: false, rowID: 1000),
                        .item(name: "Chicken Gyro Platter", quantity: 1, pickedUp: false, rowID: 1001),
                        .option(name: "Sub Gluten Free Pita")
                    ]
                ),
                OrderCartInfo(
                    orderName: "IP3 99",
                    instructions: nil,
                    restStatus: .sent,
                    items: [
                        .item(name: "Cheese Friesssssss", quantity: 2, pickedUp: false, rowID: 2001),
                        .comment(comment: "Extra cheeeesy"),
                        .option(name: "With Mayo"),
                        .whofor(who: "All for me"),
                        .item(name: "16\" Large Meat Lovers Pizza", quantity: 1, pickedUp: false, rowID: 2002),
                        .option(name: "Mushrooms"),
                        .option(name: "Black olives"),
                        .option(name: "Onions")
                    ])
            ])
            return Disposables.create()
        }
    }

    func setPickedUp(_ pickedUp: Bool, rowID: Int64) throws {
        // Stub
    }
}
