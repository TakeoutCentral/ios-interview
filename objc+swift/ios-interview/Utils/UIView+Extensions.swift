//
//  UIView+Extensions.swift
//  ios-interview
//
//  Created by Mike on 5/15/21.
//

import UIKit

extension UIView {
    func addHeight(_ extra: CGFloat) {
        frame.size.height += extra
    }

    func setHeight(to height: CGFloat) {
        frame.size.height = height
    }

    func setY(to newY: CGFloat) {
        frame.origin.y = newY
    }
}
