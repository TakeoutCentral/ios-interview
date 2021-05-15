//
// Created by Michael Gray on 1/3/21.
// Copyright (c) 2021 Takeout Central. All rights reserved.
//

import CocoaLumberjack
import CoreLocation
import Foundation
import MapKit
import MBProgressHUD
import Reusable
import RxCocoa
import RxSwift
import TinyConstraints

// swiftlint:disable type_body_length file_length function_body_length closure_body_length
final class MapViewController: UIViewController {

    private var binding: MapView {
        // swiftlint:disable:next force_cast
        view as! MapView
    }

    private let viewModel: MapViewViewModel = MapViewViewModel()
    private let geocoder = CLGeocoder()
    private let locationManager = CLLocationManager()

    init() {
        super.init(nibName: nil, bundle: nil)

        viewModel.loadMapInfo(for: "1234")
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        let nib = UINib(nibName: "MapViewController", bundle: nil).instantiate(withOwner: nil)
        // swiftlint:disable:next force_cast
        view = (nib.first as! UIView)
        title = "Map"
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        locationManager.requestWhenInUseAuthorization()

        let locationsButton = UIBarButtonItem(
            title: "Locations", style: .plain, target: self, action: #selector(onLocationsPressed)
        )
        navigationItem.rightBarButtonItem = locationsButton

        binding.mapView.delegate = self
        binding.routesTableView.delegate = self
        binding.routesTableView.dataSource = self
        binding.routesTableView.register(cellType: RouteTableViewCell.self)
        binding.directionsTableView.delegate = self
        binding.directionsTableView.dataSource = self

        binding.navButton.addTarget(
            self, action: #selector(onNavPressed), for: .touchUpInside
        )
        binding.routesDoneButton.addTarget(
            self, action: #selector(onRoutesDone), for: .touchUpInside
        )
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if viewModel.addressName.isEmpty {
            onLocationsPressed()
        }
    }

    private func startRoute() {
        MBProgressHUD.showAdded(to: view, animated: true)

        binding.directionsLayout.frame = CGRect(
            x: 0,
            y: view.frame.size.height - binding.directionsLayout.frame.size.height - binding.bottomMargin,
            width: binding.directionsLayout.frame.size.width,
            height: binding.directionsLayout.frame.size.height
        )
        binding.directionsTableView.alpha = 0
        binding.directionsLayout.isHidden = true

        binding.routesLayout.frame = CGRect(
            x: 0,
            y: view.frame.size.height - binding.routesLayout.frame.size.height,
            width: binding.routesLayout.frame.size.width,
            height: binding.routesLayout.frame.size.height
        )
        binding.routesLayout.isHidden = true

        binding.addressLabel.text = viewModel.addressName

        geocoder.geocodeAddressString(viewModel.address) { [weak self] placemarks, error in
            guard let self = self else { return }
            MBProgressHUD.hide(for: self.view, animated: true)

            guard let placemark = placemarks?.first,
                  let location = placemark.location
            else { return }

            let coordinate = location.coordinate
            self.viewModel.destCoord = coordinate

            let lines = placemark.addressDictionary?["FormattedAddressLines"] as? [String] ?? []
            switch lines.count {
            case 2...:
                self.binding.addressLabel.text = "\(self.viewModel.addressName)\n\(lines[1]), \(lines[0])"
            case 1:
                self.binding.addressLabel.text = "\(self.viewModel.addressName)\n\(lines[0])"
            default:
                self.binding.addressLabel.text = self.viewModel.addressName
            }

            let point = MKPointAnnotation()
            point.coordinate = coordinate
            point.title = self.viewModel.address
            self.binding.mapView.addAnnotation(point)

            let request = MKDirections.Request()

            request.source = MKMapItem.forCurrentLocation()
            request.transportType = .automobile
            request.destination = MKMapItem(placemark: MKPlacemark(placemark: placemark))
            request.requestsAlternateRoutes = true
            let directions = MKDirections(request: request)

            directions.calculate { [weak self] response, error in
                guard let self = self else { return }
                if error == nil, let response = response {
                    self.showRoutes(response: response)
                } else {
                    var region = MKCoordinateRegion(
                        center: coordinate,
                        span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
                    )
                    region = self.binding.mapView.regionThatFits(region)
                    self.binding.mapView.setRegion(region, animated: true)

                    let alert = UIAlertController(title: nil, message: "No routes found", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .default))
                    self.present(alert, animated: true)
                }
            }
        }
    }

    private func showRoutes(response: MKDirections.Response) {
        viewModel.routes = response.routes

        if viewModel.routes.count == 1, let route = viewModel.routes.first {
            binding.mapView.addOverlay(route.polyline, level: .aboveRoads)
            viewModel.directions = route.steps

            binding.directionsTableView.reloadData()
            binding.directionsLayout.isHidden = false
            binding.directionsLayout.frame = CGRect(
                x: 0,
                y: view.frame.size.height,
                width: binding.directionsLayout.frame.size.width,
                height: binding.directionsLayout.frame.size.height
            )
            binding.directionsTableView.alpha = 0
            binding.directionsTitleLabel.text = "Show Directions"
            binding.directionsLayout.backgroundColor = Colors.primary(CFACurrentTheme)
            UIView.animate(
                withDuration: 0.5
            ) { [self] in
                binding.directionsLayout.frame = CGRect(
                    x: 0,
                    y: view.frame.size.height - binding.directionsTitleLabel.frame.size.height - binding.bottomMargin,
                    width: binding.directionsLayout.frame.size.width,
                    height: binding.directionsLayout.frame.size.height
                )
                binding.mapView.frame = CGRect(
                    x: binding.mapView.frame.origin.x,
                    y: binding.mapView.frame.origin.y,
                    width: binding.mapView.frame.size.width,
                    height: binding.directionsLayout.frame.origin.y - binding.mapView.frame.origin.y
                )
            } completion: { [self] _ in
                binding.mapView.setVisibleMapRect(
                    route.polyline.boundingMapRect,
                    edgePadding: .horizontal(40) +
                        .top(binding.addressLabel.frame.height + 40) +
                        .bottom(view.frame.height - binding.directionsLayout.frame.origin.y),
                    animated: true
                )
            }

            return
        }

        binding.routesTableView.reloadData()

        viewModel.selectedRouteIndex = 0
        viewModel.routeOverlays = viewModel.routes.map(\.polyline)
        binding.mapView.addOverlays(viewModel.routeOverlays, level: .aboveRoads)

        binding.routesLayout.isHidden = false
        binding.routesLayout.frame = CGRect(
            x: 0,
            y: view.frame.size.height,
            width: binding.routesLayout.frame.size.width,
            height: binding.routesLayout.frame.size.height
        )
        UIView.animate(
            withDuration: 0.5
        ) { [self] in
            binding.routesLayout.frame = CGRect(
                x: 0,
                y: view.frame.size.height - binding.routesLayout.frame.size.height,
                width: binding.routesLayout.frame.size.width,
                height: binding.routesLayout.frame.size.height
            )
            binding.mapView.frame = CGRect(
                x: binding.mapView.frame.origin.x,
                y: binding.mapView.frame.origin.y,
                width: binding.mapView.frame.size.width,
                height: binding.routesLayout.frame.origin.y - binding.mapView.frame.origin.y
            )
        } completion: { [self] _ in
            let route = viewModel.routes[viewModel.selectedRouteIndex]
            binding.mapView.setVisibleMapRect(
                route.polyline.boundingMapRect,
                edgePadding: .horizontal(40) +
                    .top(binding.addressLabel.frame.height + 40) +
                    .bottom(binding.routesLayout.frame.height),
                animated: true
            )
        }
    }

    @objc private func onRoutesDone() {
        binding.mapView.removeOverlays(viewModel.routeOverlays)

        let route = viewModel.routes[viewModel.selectedRouteIndex]
        binding.mapView.addOverlay(route.polyline, level: .aboveRoads)
        viewModel.directions = route.steps
        binding.directionsTableView.reloadData()

        UIView.animate(
            withDuration: 0.5
        ) { [self] in
            binding.routesLayout.frame = CGRect(
                x: 0,
                y: view.frame.size.height,
                width: binding.routesLayout.frame.size.width,
                height: binding.routesLayout.frame.size.height
            )
            binding.mapView.frame = CGRect(
                x: binding.mapView.frame.origin.x,
                y: binding.mapView.frame.origin.y,
                width: binding.mapView.frame.size.width,
                height: binding.routesLayout.frame.origin.y - binding.mapView.frame.origin.y
            )
        } completion: { [self] _ in
            binding.routesLayout.isHidden = true
            binding.directionsLayout.isHidden = false
            binding.directionsLayout.frame = CGRect(
                x: 0,
                y: view.frame.size.height,
                width: binding.directionsLayout.frame.size.width,
                height: binding.directionsLayout.frame.size.height
            )
            binding.directionsTableView.alpha = 0
            binding.directionsTitleLabel.text = "Show Directions"
            binding.directionsLayout.backgroundColor = Colors.primary(CFACurrentTheme)
            UIView.animate(
                withDuration: 0.5
            ) { [self] in
                binding.directionsLayout.frame = CGRect(
                    x: 0,
                    y: view.frame.size.height - binding.directionsTitleLabel.frame.size.height - binding.bottomMargin,
                    width: binding.directionsLayout.frame.size.width,
                    height: binding.directionsLayout.frame.size.height
                )
                binding.mapView.frame = CGRect(
                    x: binding.mapView.frame.origin.x,
                    y: binding.mapView.frame.origin.y,
                    width: binding.mapView.frame.size.width,
                    height: binding.directionsLayout.frame.origin.y - binding.mapView.frame.origin.y
                )
            } completion: { [self] _ in
                binding.mapView.setVisibleMapRect(
                    route.polyline.boundingMapRect,
                    edgePadding: .horizontal(40) +
                        .top(binding.addressLabel.frame.height + 40) +
                        .bottom(view.frame.height - binding.directionsLayout.frame.origin.y),
                    animated: true
                )
            }
        }
    }

    @objc private func onLocationsPressed() {
        var style = UIAlertController.Style.actionSheet
        if UIDevice.current.userInterfaceIdiom == .pad {
            style = .alert
        }
        let alert = UIAlertController(
            title: "Choose Destination",
            message: nil,
            preferredStyle: style
        )
        alert.addAction(
            UIAlertAction(title: "Cancel", style: .cancel)
        )
        alert.addAction(
            UIAlertAction(
                title: "Customer",
                style: .default
            ) { [self] _ in
                viewModel.address = viewModel.mapInfo.customerAddress
                viewModel.addressName = "Customer"
                onLocationSelected()
            }
        )

        for restaurant in viewModel.mapInfo.restaurants {
            alert.addAction(
                UIAlertAction(
                    title: restaurant.restName,
                    style: .default
                ) { [self] _ in
                    viewModel.address = restaurant.restAddress
                    viewModel.addressName = restaurant.restName
                    onLocationSelected()
                }
            )
        }

        if #available(iOS 13, *) {
            switch CFACurrentTheme {
            case .dark:
                alert.overrideUserInterfaceStyle = .dark

            default:
                alert.overrideUserInterfaceStyle = .light
            }
        }

        present(alert, animated: true)
    }

    @objc private func onNavPressed() {
        let addr = viewModel.address
            .replacingOccurrences(of: " ", with: "+")
            .addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        switch UserDefaults.preferredNav {
        case 1:
            if UIApplication.shared.canOpenURL(URL(string: "comgooglemaps://")!) {
                guard let url = URL(
                    string: "comgooglemaps://?daddr=\(addr)&directionsmode=driving&views=traffic"
                ) else {
                    DDLogError("Failed to create google maps url with address: \(viewModel.address)")
                    return
                }
                UIApplication.shared.open(url)
            } else {
                // Google Maps is not installed. Launch AppStore to install Google Maps app
                UIApplication.shared.open(
                    URL(string: "https://itunes.apple.com/us/app/google-maps-real-time-navigation/id585027354")!
                )
            }

        case 2:
            if UIApplication.shared.canOpenURL(URL(string: "waze://")!) {
                guard let url = URL(
                    string: "waze://?ll=\(viewModel.destCoord.latitude),\(viewModel.destCoord.longitude)&navigate=yes"
                ) else {
                    DDLogError("Failed to create waze maps url with lat/lng: \(viewModel.destCoord)")
                    return
                }
                UIApplication.shared.open(url)
            } else {
                // Waze is not installed. Launch AppStore to install Waze app
                UIApplication.shared.open(
                    URL(string: "http://itunes.apple.com/us/app/id323229106")!
                )
            }

        default:
            guard let url = URL(string: "http://maps.apple.com/?daddr=\(addr)&dirflg=d") else {
                DDLogError("Failed to create apple maps url with address: \(viewModel.address)")
                return
            }
            UIApplication.shared.open(url)
        }
    }

    private func onLocationSelected() {
        if binding.routesLayout.isHidden, binding.directionsLayout.isHidden {
            startRoute()
            return
        }

        UIView.animate(
            withDuration: 0.7
        ) { [self] in
            if !binding.routesLayout.isHidden {
                binding.routesLayout.frame = CGRect(
                    x: 0,
                    y: view.frame.size.height,
                    width: binding.routesLayout.frame.size.width,
                    height: binding.routesLayout.frame.size.height
                )
            }

            if !binding.directionsLayout.isHidden {
                binding.directionsLayout.frame = CGRect(
                    x: 0,
                    y: view.frame.size.height,
                    width: binding.directionsLayout.frame.size.width,
                    height: binding.directionsLayout.frame.size.height
                )
            }

            binding.mapView.frame = CGRect(
                x: binding.mapView.frame.origin.x,
                y: binding.mapView.frame.origin.y,
                width: binding.mapView.frame.size.width,
                height: view.frame.size.height - binding.mapView.frame.origin.y
            )
        } completion: { [self] _ in
            binding.mapView.removeAnnotations(binding.mapView.annotations)
            binding.mapView.removeOverlays(viewModel.routeOverlays)
            startRoute()
        }
    }
}

extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard type(of: annotation) != MKUserLocation.Type.self else {
            return nil
        }

        let pinIdentifier = "CustomPinAnnotation"

        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: pinIdentifier) as? MKPinAnnotationView

        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: pinIdentifier)
        } else {
            pinView?.annotation = annotation
        }

        pinView?.pinTintColor = .green
        pinView?.animatesDrop = true
        pinView?.canShowCallout = true

        return pinView
    }

    public func mapView(_: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        if let polyline = overlay as? MKPolyline,
           viewModel.routeOverlays.firstIndex(of: polyline) == viewModel.selectedRouteIndex {
            renderer.strokeColor = UIColor(rgb: 0x0E84C4)
        } else {
            renderer.strokeColor = .gray
        }
        renderer.lineWidth = 5
        return renderer
    }
}

extension MapViewController: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == binding.directionsTableView {
            guard viewModel.directions.count > indexPath.row else {
                return 0
            }

            let step = viewModel.directions[indexPath.row]
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineBreakMode = .byWordWrapping
            let stepRect = step.instructions.boundingRect(
                with: CGSize(
                    width: binding.directionsTableView.frame.size.width - 16,
                    height: .greatestFiniteMagnitude
                ),
                options: [.usesLineFragmentOrigin],
                attributes: [
                    NSAttributedString.Key.font: FontFamily.OpenSans.regular.font(size: 18),
                    NSAttributedString.Key.paragraphStyle: paragraphStyle
                ],
                context: nil
            )
            let stepSize = stepRect.size

            return 8 + stepSize.height + 8
        } else if tableView == binding.routesTableView {
            guard viewModel.routes.count > indexPath.row else {
                return 0
            }

            return RouteTableViewCell.height(
                forRoute: viewModel.routes[indexPath.row],
                width: binding.routesTableView.frame.size.width
            )
        }

        return 0
    }

    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == binding.routesTableView {
            viewModel.selectedRouteIndex = indexPath.row
            binding.routesTableView.reloadData()

            binding.mapView.removeOverlays(viewModel.routeOverlays)

            for overlay in viewModel.routeOverlays {
                binding.mapView.addOverlay(overlay, level: .aboveRoads)
            }

            let route = viewModel.routes[viewModel.selectedRouteIndex]
            binding.mapView.setVisibleMapRect(
                route.polyline.boundingMapRect,
                edgePadding: .horizontal(40) +
                    .top(binding.addressLabel.frame.height + 40) +
                    .bottom(binding.routesLayout.frame.height),
                animated: true
            )
        }
    }
}

extension MapViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection _: Int) -> Int {
        if tableView == binding.directionsTableView {
            return viewModel.directions.count
        } else if tableView == binding.routesTableView {
            return viewModel.routes.count
        }

        return 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == binding.directionsTableView {
            let cellIdentifier = "DirectionCell"
            let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) ?? {
                let cell = UITableViewCell(style: .default, reuseIdentifier: cellIdentifier)
                cell.accessoryType = .none

                cell.textLabel?.font = FontFamily.OpenSans.regular.font(size: 18)
                cell.textLabel?.numberOfLines = 0
                return cell
            }()

            cell.backgroundColor = Colors.gray4(CFACurrentTheme)
            cell.textLabel?.textColor = Colors.gray900(CFACurrentTheme)

            let step = viewModel.directions[indexPath.row]
            cell.textLabel?.text = step.instructions

            return cell
        } else if tableView == binding.routesTableView {
            let cell: RouteTableViewCell = tableView.dequeueReusableCell(for: indexPath)
            let route = viewModel.routes[indexPath.row]
            cell.bind(route: route)

            if indexPath.row == viewModel.selectedRouteIndex {
                cell.backgroundColor = Colors.gray2(CFACurrentTheme)
                cell.accessoryType = .checkmark
            } else {
                cell.backgroundColor = Colors.gray4(CFACurrentTheme)
                cell.accessoryType = .none
            }
            return cell
        }

        return UITableViewCell()
    }
}
