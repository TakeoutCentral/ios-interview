//
// Created by Mike on 1/4/21.
// Copyright (c) 2021 Takeout Central. All rights reserved.
//

import CFATheme
import Foundation
import MapKit
import Reusable

final class RouteTableViewCell: UITableViewCell, Reusable, NibLoadable {

    @IBOutlet var routeName: UILabel!
    @IBOutlet var distance: UILabel!
    @IBOutlet var time: UILabel!
    @IBOutlet var alerts: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        initialize()
        registerForThemeChanges()
    }

    private func initialize() {
        routeName.font = FontFamily.Montserrat.bold.font(size: 18)
        distance.font = FontFamily.OpenSans.regular.font(size: 18)
        time.font = FontFamily.OpenSans.regular.font(size: 18)
        alerts.font = FontFamily.OpenSans.regular.font(size: 18)
        selectionStyle = .none

        separatorInset = .zero
        preservesSuperviewLayoutMargins = false
        layoutMargins = .zero
    }

    // swiftlint:disable:next function_body_length
    func bind(route: MKRoute) {
        routeName.text = route.name
        distance.text = String(format: "%.1f miles", route.distance / 1609.34)
        time.text = String(format: "%d min", Int(route.expectedTravelTime / 60))

        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineBreakMode = .byWordWrapping

        let nameRect = route.name.boundingRect(
            with: CGSize(width: frame.size.width - 16, height: .greatestFiniteMagnitude),
            options: [.usesLineFragmentOrigin],
            attributes: [
                NSAttributedString.Key.font: FontFamily.Montserrat.bold.font(size: 18),
                NSAttributedString.Key.paragraphStyle: paragraphStyle
            ],
            context: nil
        )
        var nameSize = nameRect.size

        if nameSize.height < 29 {
            nameSize.height = 29
        }

        routeName.frame = CGRect(
            x: routeName.frame.origin.x,
            y: routeName.frame.origin.y,
            width: routeName.frame.size.width,
            height: nameSize.height
        )
        distance.frame = CGRect(
            x: distance.frame.origin.x,
            y: routeName.frame.origin.y + routeName.frame.size.height + 4,
            width: distance.frame.size.width,
            height: distance.frame.size.height
        )
        time.frame = CGRect(
            x: time.frame.origin.x,
            y: distance.frame.origin.y,
            width: time.frame.size.width,
            height: time.frame.size.height
        )

        if !route.advisoryNotices.isEmpty {
            alerts.isHidden = false
            let alertString = NSMutableString(string: route.advisoryNotices[0])
            for notice in route.advisoryNotices.dropFirst() {
                alertString.append("\n\(notice)")
            }

            let alertRect = alertString.boundingRect(
                with: CGSize(width: frame.size.width - 16, height: .greatestFiniteMagnitude),
                options: [.usesLineFragmentOrigin],
                attributes: [
                    NSAttributedString.Key.font: FontFamily.OpenSans.regular.font(size: 18),
                    NSAttributedString.Key.paragraphStyle: paragraphStyle
                ],
                context: nil
            )
            let alertSize = alertRect.size
            alerts.frame = CGRect(
                x: alerts.frame.origin.x,
                y: time.frame.origin.y + time.frame.size.height + 4,
                width: alerts.frame.size.width,
                height: alertSize.height
            )
            alerts.text = String(alertString)
        } else {
            alerts.isHidden = true
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        routeName.text = nil
        distance.text = nil
        time.text = nil
        alerts.text = nil
    }

    override func themeDidChange(_ theme: CFATheme) {
        backgroundColor = Colors.gray4(theme)
        let textColor = Colors.gray900(theme)
        routeName.textColor = textColor
        distance.textColor = textColor
        time.textColor = textColor
        alerts.textColor = textColor
    }

    static func height(forRoute route: MKRoute, width: CGFloat) -> CGFloat {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineBreakMode = .byWordWrapping

        let nameRect = route.name.boundingRect(
            with: CGSize(width: width - 16, height: .greatestFiniteMagnitude),
            options: [.usesLineFragmentOrigin],
            attributes: [
                NSAttributedString.Key.font: FontFamily.Montserrat.bold.font(size: 18),
                NSAttributedString.Key.paragraphStyle: paragraphStyle
            ],
            context: nil
        )
        let nameSize = nameRect.size
        if route.advisoryNotices.isEmpty {
            return 8 + nameSize.height + 4 + 29 + 8
        }

        let alertString = NSMutableString(string: route.advisoryNotices[0])
        for notice in route.advisoryNotices.dropFirst() {
            alertString.append("\n\(notice)")
        }

        let alertRect = alertString.boundingRect(
            with: CGSize(width: width - 16, height: .greatestFiniteMagnitude),
            options: [.usesLineFragmentOrigin],
            attributes: [
                NSAttributedString.Key.font: FontFamily.OpenSans.regular.font(size: 18),
                NSAttributedString.Key.paragraphStyle: paragraphStyle
            ],
            context: nil
        )
        let alertSize = alertRect.size
        return 8 + nameSize.height + 4 + 29 + 4 + alertSize.height + 8
    }
}
