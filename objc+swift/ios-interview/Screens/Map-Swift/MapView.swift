//
// Created by Michael Gray on 1/3/21.
// Copyright (c) 2021 Takeout Central. All rights reserved.
//

import CFATheme
import Foundation
import MapKit

final class MapView: UIView {

    @IBOutlet var addressLabel: UILabel!
    @IBOutlet var mapView: MKMapView!
    @IBOutlet var navButton: UIButton!

    @IBOutlet var directionsLayout: UIView!
    @IBOutlet var directionsTitleLabel: UILabel!
    @IBOutlet var directionsTableView: UITableView!

    @IBOutlet var routesLayout: UIView!
    @IBOutlet var routesTitleLabel: UILabel!
    @IBOutlet var routesTableView: UITableView!
    @IBOutlet var routesDoneButton: UIButton!

    private(set) var bottomMargin: CGFloat = 0

    override func awakeFromNib() {
        super.awakeFromNib()
        registerForThemeChanges()
        initialize()
    }

    private func initialize() {
        addSubview(directionsLayout)
        addSubview(routesLayout)
        directionsLayout.isHidden = true
        routesLayout.isHidden = true

        directionsTableView.allowsSelection = false
        directionsTableView.tableFooterView = UIView()
        routesTableView.tableFooterView = UIView()

        directionsTitleLabel.addGestureRecognizer(
            UITapGestureRecognizer(target: self, action: #selector(toggleDirections))
        )
        directionsTitleLabel.isUserInteractionEnabled = true
    }

    private var initialized = false
    override func layoutSubviews() {
        super.layoutSubviews()

        if !initialized,
           #available(iOS 11.0, *),
           let bottom = UIApplication.shared.keyWindow?.safeAreaInsets.bottom {
            routesLayout.addHeight(bottom)
            directionsLayout.addHeight(bottom)
            bottomMargin = bottom
            initialized = true
        }

        addressLabel.setY(to: 0)
        navButton.setY(to: addressLabel.frame.size.height + 8)

        directionsLayout.frame = CGRect(
            x: directionsLayout.frame.origin.x,
            y: directionsLayout.frame.origin.y,
            width: frame.size.width,
            height: directionsLayout.frame.size.height
        )
        routesLayout.frame = CGRect(
            x: routesLayout.frame.origin.x,
            y: routesLayout.frame.origin.y,
            width: frame.size.width,
            height: routesLayout.frame.size.height
        )

        mapView.frame = CGRect(
            x: 0,
            y: 0,
            width: mapView.frame.size.width,
            height: frame.size.height
        )
    }

    @objc private func toggleDirections() {
        let value = frame.size.height - directionsTitleLabel.frame.size.height - bottomMargin - 1
        if directionsLayout.frame.origin.y < value {
            UIView.animate(
                withDuration: 0.5
            ) {
                self.directionsLayout.frame = CGRect(
                    x: 0,
                    y: self.frame.size.height - self.directionsTitleLabel.frame.size.height - self.bottomMargin,
                    width: self.directionsLayout.frame.size.width,
                    height: self.directionsLayout.frame.size.height
                )
                self.directionsTableView.alpha = 0
            } completion: { _ in
                self.directionsTitleLabel.text = "Show Directions"
                self.directionsLayout.backgroundColor = Colors.primary(CFACurrentTheme)
            }
        } else {
            UIView.animate(
                withDuration: 0.5
            ) {
                self.directionsLayout.frame = CGRect(
                    x: 0,
                    y: self.frame.size.height - self.directionsLayout.frame.size.height,
                    width: self.directionsLayout.frame.size.width,
                    height: self.directionsLayout.frame.size.height
                )
                self.directionsTableView.alpha = 1
            } completion: { _ in
                self.directionsTitleLabel.text = "Hide Directions"
                self.directionsLayout.backgroundColor = Colors.gray2(CFACurrentTheme)
            }
        }
    }

    override func themeDidChange(_ theme: CFATheme) {
        backgroundColor = Colors.gray2(theme)
        addressLabel.backgroundColor = Colors.gray
        routesTitleLabel.backgroundColor = Colors.primary(theme)
        routesDoneButton.backgroundColor = Colors.primary(theme)
        routesDoneButton.setTitleColor(
            Colors.textColorOnPrimary(theme),
            for: .normal
        )
        directionsTitleLabel.backgroundColor = Colors.primary(theme)
        directionsLayout.backgroundColor = Colors.primary(theme)
        routesLayout.backgroundColor = Colors.gray2(theme)
        routesTableView.backgroundColor = Colors.gray2(theme)
        directionsTableView.backgroundColor = Colors.gray2(theme)
        routesTableView.separatorColor = Colors.gray7(theme)
        directionsTableView.separatorColor = Colors.gray7(theme)

        directionsTitleLabel.textColor = Colors.textColorOnPrimary(theme)
        routesTitleLabel.textColor = Colors.textColorOnPrimary(theme)
        addressLabel.textColor = .white

        if #available(iOS 13, *) {
            switch theme {
            case .dark:
                mapView.overrideUserInterfaceStyle = .dark

            default:
                mapView.overrideUserInterfaceStyle = .light
            }
        }
    }
}
