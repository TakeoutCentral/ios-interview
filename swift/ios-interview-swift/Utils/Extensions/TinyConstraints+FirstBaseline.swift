//
//  TinyConstraints+FirstBaseline.swift
//  Takeout Central
//
//  Created by Michael Gray on 1/20/20.
//  Copyright © 2020 Takeout Central. All rights reserved.
//

import Foundation
import TinyConstraints

public extension Constrainable where Self: UIView {
    @discardableResult
    func firstBaseline(to view: Self, isActive: Bool = true) -> Constraint {
        prepareForLayout()

        return self.firstBaselineAnchor.constraint(equalTo: view.firstBaselineAnchor).set(isActive)
    }
}
