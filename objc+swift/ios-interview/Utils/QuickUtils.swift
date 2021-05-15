//
// Created by Michael Gray on 10/5/20.
// Copyright (c) 2020 Takeout Central. All rights reserved.
//

import CocoaLumberjack
import Foundation

final class QuickUtils: NSObject {
    @objc(addHeight:toView:)
    @available(*, deprecated, message: "Use UIView.addHeight")
    static func addHeight(_ extra: CGFloat, toView view: UIView) {
        QuickUtils.setHeight(view.frame.size.height + extra, forView: view)
    }

    @objc(setHeight:forView:)
    @available(*, deprecated, message: "Use UIView.setHeight")
    static func setHeight(_ newHeight: CGFloat, forView view: UIView) {
        view.frame = CGRect(
            x: view.frame.origin.x,
            y: view.frame.origin.y,
            width: view.frame.size.width,
            height: newHeight
        )
    }

    @objc(setY:forView:)
    @available(*, deprecated, message: "Use UIView.setY")
    static func setY(_ newY: CGFloat, forView view: UIView) {
        view.frame = CGRect(
            x: view.frame.origin.x,
            y: newY,
            width: view.frame.size.width,
            height: view.frame.size.height
        )
    }
}
