//
// Created by Michael Gray on 11/12/20.
// Copyright (c) 2020 Takeout Central. All rights reserved.
//

import CocoaLumberjack
import FeatureFlags
import Foundation
import RxCocoa
import RxDataSources
import RxSwift

final class CartViewModel {

    private let orderRepository = OrderRepository()
    @RxDriver([])
    var cartInfo: Driver<[OrderCartInfo]>

    var showChecklist: Bool {
        if Feature.isUnlocked(.checklistNotRequired) {
            return UserDefaults.userChecklistState != .off
        } else {
            return true
        }
    }

    private let disposeBag = DisposeBag()

    func load(cartID: String) throws {
        orderRepository.cartInfo(cartID: cartID)
            .bind(to: $cartInfo)
            .disposed(by: disposeBag)
    }

    func setPickedUp(_ pickedUp: Bool, for rowID: Int64) {
        do {
            try orderRepository.setPickedUp(pickedUp, rowID: rowID)
        } catch {
            DDLogError("Unknown DB error: \(error)")
            assertionFailure()
        }
    }
}

extension OrderCartInfo: SectionModelType {
    public init(original: OrderCartInfo, items: [Item]) {
        self = original
        self.items = items
    }
}
