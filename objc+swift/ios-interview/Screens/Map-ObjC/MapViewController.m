//
//  MapViewController.m
//  Takeout Central Driver App
//
//  Created by Allen Luo on 4/2/15.
//  Copyright (c) 2015 Takeout Central. All rights reserved.
//

#import "MapViewController.h"
#import "ios_interview-Swift.h"
#import "RouteTableViewCell.h"
#import "MBProgressHUD.h"
#import "UIResponder+Theme.h"
#import "UIColor+Theme.h"
#import "EXTScope.h"

@interface MapViewController ()

@end

@implementation MapViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.mapInfo = [[OrderRepository new] mapInfoWithCartID:@"1234"];
    }
    return self;
}

- (NSString *)title {
    return @"Map";
}

- (void)viewDidLoad {
    [super viewDidLoad];

    UIBarButtonItem *locationsButton = [[UIBarButtonItem alloc] initWithTitle:@"Locations" style:UIBarButtonItemStylePlain target:self action:@selector(onLocationsPressed:)];

    self.navigationItem.rightBarButtonItem = locationsButton;

    self.automaticallyAdjustsScrollViewInsets = NO;

    [self.locationManager requestWhenInUseAuthorization];

    _directionsTableView.allowsSelection = NO;

    _directionsTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    _routesTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];

    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toggleDirections:)];
    [_directionsTitleLabel addGestureRecognizer:tapGesture];
    [_directionsTitleLabel setUserInteractionEnabled:YES];
}

- (CLLocationManager *)locationManager {
    if (_locationManager == nil) {
        _locationManager = [[CLLocationManager alloc] init];

        _locationManager.delegate = self;
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;

        // Set a movement threshold for new events.
        _locationManager.distanceFilter = kCLLocationAccuracyNearestTenMeters;
    }
    return _locationManager;
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];

    if(!initialized){
        bottomMargin = 0;
        if (@available(iOS 11.0, *)) {
            UIWindow *window = UIApplication.sharedApplication.keyWindow;
            CGFloat extraTop = window.safeAreaInsets.top - 20.0f;
            if(extraTop>0){
                CGFloat extraBottom = window.safeAreaInsets.bottom;
                [QuickUtils addHeight:extraTop toView:_routesLayout];
                [QuickUtils addHeight:extraTop toView:_directionsLayout];

                bottomMargin = extraBottom;
            }
        }

        [QuickUtils setY:0 forView:_addressLabel];
        [QuickUtils setY:_addressLabel.frame.size.height + 8 forView:_navButton];

        _directionsLayout.frame = CGRectMake(_directionsLayout.frame.origin.x, _directionsLayout.frame.origin.y, self.view.frame.size.width, _directionsLayout.frame.size.height);
        _routesLayout.frame = CGRectMake(_routesLayout.frame.origin.x, _routesLayout.frame.origin.y, self.view.frame.size.width, _routesLayout.frame.size.height);

        _mapView.frame = CGRectMake(0, 0, _mapView.frame.size.width, self.view.frame.size.height);

        initialized = YES;
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (_addressName == nil || [_addressName isEqualToString:@""]) {
        [self onLocationsPressed:nil];
    }
};

- (void) startRoute{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];

    if(_directionsLayout.superview==nil)
        [self.view addSubview:_directionsLayout];
    _directionsLayout.frame = CGRectMake(0, self.view.frame.size.height - _directionsLayout.frame.size.height - bottomMargin, _directionsLayout.frame.size.width, _directionsLayout.frame.size.height);
    _directionsTableView.alpha = 0.0f;
    _directionsLayout.hidden = YES;

    if(_routesLayout.superview==nil)
        [self.view addSubview:_routesLayout];
    _routesLayout.frame = CGRectMake(0, self.view.frame.size.height - _routesLayout.frame.size.height, _routesLayout.frame.size.width, _routesLayout.frame.size.height);
    _routesLayout.hidden = YES;

    _addressLabel.text = _addressName;

    if(_geocoder==nil)
        _geocoder = [[CLGeocoder alloc] init];

    @weakify(self);
    [_geocoder geocodeAddressString:_address completionHandler:^(NSArray *placemarks, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        @strongify(self);
        if ([placemarks count] > 0) {
            CLPlacemark *placemark = [placemarks objectAtIndex:0];
            CLLocation *location = placemark.location;
            CLLocationCoordinate2D coordinate = location.coordinate;
            self->destCoord = coordinate;

            NSArray *lines = placemark.addressDictionary[ @"FormattedAddressLines"];
            if(lines.count>1)
                self.addressLabel.text = [NSString stringWithFormat:@"%@\n%@, %@", self.addressName, lines[0], lines[1]];
            else if(lines.count>0)
                self.addressLabel.text = [NSString stringWithFormat:@"%@\n%@", self.addressName, lines[0]];

            MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
            point.coordinate = coordinate;
            point.title = self.address;
            [self.mapView addAnnotation:point];

            MKDirectionsRequest *request = [[MKDirectionsRequest alloc] init];

            request.source = [MKMapItem mapItemForCurrentLocation];
            request.transportType = MKDirectionsTransportTypeAutomobile;
            request.destination = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithPlacemark:placemark]];
            request.requestsAlternateRoutes = YES;
            MKDirections *directions = [[MKDirections alloc] initWithRequest:request];

            [directions calculateDirectionsWithCompletionHandler:
             ^(MKDirectionsResponse *response, NSError *error) {
                 if (error || response.routes.count==0) {
                     MKCoordinateRegion region;
                     region.center = coordinate;
                     region.span = MKCoordinateSpanMake(0.005, 0.005);
                     region = [self.mapView regionThatFits:region];
                     [self.mapView setRegion:region animated:YES];

                     UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"No routes found" preferredStyle:UIAlertControllerStyleAlert];
                     [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
                     [self presentViewController:alert animated:YES completion:nil];
                 } else {
                     [self showRoute:response];
                 }
             }];
        }
    }];
}

-(void)showRoute:(MKDirectionsResponse *)response {
    _routes = response.routes;

    if([_routes count]==1){
        MKRoute *route = [response.routes objectAtIndex:0];
        [_mapView addOverlay:route.polyline level:MKOverlayLevelAboveRoads];
        _directions = route.steps;

        [_directionsTableView reloadData];
        _directionsLayout.hidden = NO;
        _directionsLayout.frame = CGRectMake(0, self.view.frame.size.height, _directionsLayout.frame.size.width, _directionsLayout.frame.size.height);
        _directionsTableView.alpha = 0.0f;
        _directionsTitleLabel.text = @"Show Directions";
        _directionsLayout.backgroundColor = [UIColor tc_PrimaryColor:CFACurrentTheme];
        [UIView animateWithDuration:0.5 animations:^{
            self.directionsLayout.frame = CGRectMake(0, self.view.frame.size.height - self.directionsTitleLabel.frame.size.height - self->bottomMargin, self.directionsLayout.frame.size.width, self.directionsLayout.frame.size.height);
            self.mapView.frame = CGRectMake(self.mapView.frame.origin.x, self.mapView.frame.origin.y, self.mapView.frame.size.width, self.directionsLayout.frame.origin.y - self.mapView.frame.origin.y);
        } completion:^(BOOL finished){
            [self.mapView setVisibleMapRect:[route.polyline boundingMapRect] edgePadding:UIEdgeInsetsMake(40.0, 40.0, 40.0, 40.0) animated:YES];
        }];
        return;
    }

    [_routesTableView reloadData];

    selectedRouteIndex = 0;
    _routeOverlays = [[NSMutableArray alloc] init];
    for(int i=0; i<_routes.count; i++){
        MKRoute *route = [_routes objectAtIndex:i];
        [_routeOverlays addObject:route.polyline];
    }
    for(int i=0; i<_routeOverlays.count; i++){
        if(i==selectedRouteIndex)
            continue;
        MKPolyline *polyline = [_routeOverlays objectAtIndex:i];
        [_mapView addOverlay:polyline level:MKOverlayLevelAboveRoads];
    }
    [_mapView addOverlay:[_routeOverlays objectAtIndex:selectedRouteIndex] level:MKOverlayLevelAboveRoads];

    _routesLayout.hidden = NO;
    _routesLayout.frame = CGRectMake(0, self.view.frame.size.height, _routesLayout.frame.size.width, _routesLayout.frame.size.height);
    [UIView animateWithDuration:0.5 animations:^{
        self.routesLayout.frame = CGRectMake(0, self.view.frame.size.height - self.routesLayout.frame.size.height, self.routesLayout.frame.size.width, self.routesLayout.frame.size.height);
        self.mapView.frame = CGRectMake(self.mapView.frame.origin.x, self.mapView.frame.origin.y, self.mapView.frame.size.width, self.routesLayout.frame.origin.y - self.mapView.frame.origin.y);
    } completion:^(BOOL finished){
        MKRoute *route = [self.routes objectAtIndex:self->selectedRouteIndex];
        [self.mapView setVisibleMapRect:[route.polyline boundingMapRect] edgePadding:UIEdgeInsetsMake(40.0, 40.0, 40.0, 40.0) animated:YES];
    }];
}

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id < MKOverlay >)overlay {
    MKPolylineRenderer *renderer = [[MKPolylineRenderer alloc] initWithOverlay:overlay];
    if([_routeOverlays indexOfObject:overlay]==selectedRouteIndex)
        renderer.strokeColor = [UIColor colorWithRGB:0x0e84c4];
    else
        renderer.strokeColor = [UIColor grayColor];
    renderer.lineWidth = 5.0;
    return renderer;
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    switch (status) {
        case kCLAuthorizationStatusAuthorizedAlways:
        {
            TC_LOG(@"kCLAuthorizationStatusAuthorized");
//            [self.locationManager startUpdatingLocation];
        }
            break;
        case kCLAuthorizationStatusDenied:
            TC_LOG(@"kCLAuthorizationStatusDenied");
        {
            UIAlertController *alert = [UIAlertController
                                        alertControllerWithTitle:@"Takeout Central can’t access your current location.\n\nTurn on access for Takeout Central to your location in the Settings app under Location Services."
                                        message:nil
                                        preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
            [self presentViewController:alert animated:YES completion:nil];
            // Disable the post button.
        }
            break;
        case kCLAuthorizationStatusNotDetermined:
        {
            TC_LOG(@"kCLAuthorizationStatusNotDetermined");
        }
            break;
        case kCLAuthorizationStatusRestricted:
        {
            TC_LOG(@"kCLAuthorizationStatusRestricted");
        }
            break;
        default:break;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    // Let the system handle user location annotations.
    if ([annotation isKindOfClass:[MKUserLocation class]]) {
        return nil;
    }

    static NSString *pinIdentifier = @"CustomPinAnnotation";

    // Handle any custom annotations.
    // Try to dequeue an existing pin view first.
    MKPinAnnotationView *pinView = (MKPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:pinIdentifier];

    if (!pinView) {
        // If an existing pin view was not available, create one.
        pinView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation
                                                  reuseIdentifier:pinIdentifier];
    } else {
        pinView.annotation = annotation;
    }

    pinView.pinTintColor = [UIColor greenColor];
    pinView.animatesDrop = YES;
    pinView.canShowCallout = YES;

    return pinView;
}

- (IBAction)onRoutesDone:(id)sender {
    for(MKPolyline *polyline in _routeOverlays){
        [_mapView removeOverlay:polyline];
    }

    MKRoute *route = [_routes objectAtIndex:selectedRouteIndex];
    [_mapView addOverlay:route.polyline level:MKOverlayLevelAboveRoads];
    _directions = route.steps;
    [_directionsTableView reloadData];

    [UIView animateWithDuration:0.5 animations:^{
        self.routesLayout.frame = CGRectMake(0, self.view.frame.size.height, self.routesLayout.frame.size.width, self.routesLayout.frame.size.height);
        self.mapView.frame = CGRectMake(self.mapView.frame.origin.x, self.mapView.frame.origin.y, self.mapView.frame.size.width, self.routesLayout.frame.origin.y - self.mapView.frame.origin.y);
    } completion:^(BOOL finished){
        self.routesLayout.hidden = YES;
        self.directionsLayout.hidden = NO;
        self.directionsLayout.frame = CGRectMake(0, self.view.frame.size.height, self.directionsLayout.frame.size.width, self.directionsLayout.frame.size.height);
        self.directionsTableView.alpha = 0.0f;
        self.directionsTitleLabel.text = @"Show Directions";
        self.directionsLayout.backgroundColor = [UIColor tc_PrimaryColor:CFACurrentTheme];
        [UIView animateWithDuration:0.5 animations:^{
            self.directionsLayout.frame = CGRectMake(0, self.view.frame.size.height - self.directionsTitleLabel.frame.size.height - self->bottomMargin, self.directionsLayout.frame.size.width, self.directionsLayout.frame.size.height);
            self.mapView.frame = CGRectMake(self.mapView.frame.origin.x, self.mapView.frame.origin.y, self.mapView.frame.size.width, self.directionsLayout.frame.origin.y - self.mapView.frame.origin.y);
        } completion:^(BOOL finished){
            [self.mapView setVisibleMapRect:[route.polyline boundingMapRect] edgePadding:UIEdgeInsetsMake(40.0, 40.0, 40.0, 40.0) animated:YES];
        }];
    }];
}

- (IBAction)onLocationsPressed:(id)sender {
    @weakify(self);
    UIAlertController *alert = [UIAlertController
                                alertControllerWithTitle:@"Choose Destination"
                                message:nil
                                preferredStyle:UIAlertControllerStyleActionSheet];
    [alert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];
    [alert addAction:[UIAlertAction actionWithTitle:@"Customer" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        @strongify(self);
        self.addressName = @"Customer";
        self.address = self.mapInfo.customerAddress;
        [self onLocationSelected];
    }]];

    for(TCRestaurantInfo *restaurant in self.mapInfo.restaurants){
        [alert addAction:[UIAlertAction actionWithTitle:restaurant.restName style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            @strongify(self);
            self.addressName = restaurant.restName;
            self.address = restaurant.restAddress;
            [self onLocationSelected];
        }]];
    }

    if (@available(iOS 13.0, *)) {
        switch (CFACurrentTheme) {
            case CFAThemeDark:
                alert.overrideUserInterfaceStyle = UIUserInterfaceStyleDark;
            default:
                alert.overrideUserInterfaceStyle = UIUserInterfaceStyleLight;
        }
    }

    [self presentViewController:alert animated:YES completion:nil];
}

- (IBAction)onNavPressed:(id)sender {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    int navIndex = (int)[userDefaults integerForKey:@"preferredNav"];

    if(navIndex==0){ //apple
        NSString *url = [NSString stringWithFormat:@"http://maps.apple.com/?daddr=%@&dirflg=d", [_address stringByReplacingOccurrencesOfString:@" " withString:@"+"]];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url] options:@{} completionHandler:nil];
    } else if(navIndex==1){ //google
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"comgooglemaps://"]]) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"comgooglemaps://?daddr=%@&directionsmode=driving&views=traffic", [_address stringByReplacingOccurrencesOfString:@" " withString:@"+"]]] options:@{} completionHandler:nil];
        } else {
            // Google Maps is not installed. Launch AppStore to install Google Maps app
            [[UIApplication sharedApplication] openURL:[NSURL
                                                        URLWithString:@"https://itunes.apple.com/us/app/google-maps-real-time-navigation/id585027354"]
                                               options:@{}
                                     completionHandler:nil];
        }
    } else if(navIndex==2){ //waze
        if ([[UIApplication sharedApplication]
             canOpenURL:[NSURL URLWithString:@"waze://"]]) {

            // Waze is installed. Launch Waze and start navigation
            NSString *urlStr = [NSString stringWithFormat:@"waze://?ll=%f,%f&navigate=yes",
             destCoord.latitude, destCoord.longitude];

            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStr] options:@{} completionHandler:nil];
        } else {
            // Waze is not installed. Launch AppStore to install Waze app
            [[UIApplication sharedApplication] openURL:[NSURL
                                                        URLWithString:@"http://itunes.apple.com/us/app/id323229106"]
                                               options:@{}
                                     completionHandler:nil];
        }
    }
}

- (void)onLocationSelected{
    [UIView animateWithDuration:0.7f animations:^{
        if(!self.routesLayout.hidden){
            self.routesLayout.frame = CGRectMake(0, self.view.frame.size.height, self.routesLayout.frame.size.width, self.routesLayout.frame.size.height);
        }

        if(!self.directionsLayout.hidden){
            self.directionsLayout.frame = CGRectMake(0, self.view.frame.size.height, self.directionsLayout.frame.size.width, self.directionsLayout.frame.size.height);
        }

        self.mapView.frame = CGRectMake(self.mapView.frame.origin.x, self.mapView.frame.origin.y, self.mapView.frame.size.width, self.view.frame.size.height - self.mapView.frame.origin.y);
    } completion:^(BOOL finished){
        [self.mapView removeAnnotations:[self.mapView annotations]];

        for(MKPolyline *polyline in self.routeOverlays){
            [self.mapView removeOverlay:polyline];
        }

        [self startRoute];
    }];
}

- (BOOL)shouldAutorotate {
    return NO;
}

// Set preferred orientation for initial display
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
    return UIInterfaceOrientationPortrait;
}

// Return list of supported orientations.
- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    if(UIInterfaceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation]))
        return UIInterfaceOrientationMaskAll;

    return UIInterfaceOrientationMaskPortrait;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    // Remove seperator inset
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }

    // Prevent the cell from inheriting the Table View's margin settings
    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
        [cell setPreservesSuperviewLayoutMargins:NO];
    }

    // Explictly set your cell's layout margins
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(tableView==_directionsTableView){
        if(_directions==nil)
            return 0;

        MKRouteStep *step = [_directions objectAtIndex:indexPath.row];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;

        CGRect stepRect = [step.instructions boundingRectWithSize:CGSizeMake(_directionsTableView.frame.size.width - 16, CGFLOAT_MAX)
                                                          options:NSStringDrawingUsesLineFragmentOrigin
                                                       attributes:@{NSFontAttributeName:[UIFont fontWithName:@"OpenSans" size:18.0], NSParagraphStyleAttributeName:paragraphStyle.copy}
                                                          context:nil];
        CGSize stepSize = stepRect.size;

        return  8 + stepSize.height + 8;
    } else if(tableView==_routesTableView){
        if(_routes==nil)
            return 0;

        return [RouteTableViewCell heightForRoute:[_routes objectAtIndex:indexPath.row] andWidth:_routesTableView.frame.size.width];
    }

    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(tableView==_directionsTableView){
        if(_directions==nil)
            return 0;
        return  [_directions count];
    } else if(tableView==_routesTableView){
        if(_routes==nil)
            return  0;
        return  [_routes count];
    }

    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(tableView==_directionsTableView){
        static NSString *CellIdentifier = @"DirectionCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            [cell setAccessoryType:UITableViewCellAccessoryNone];

            [cell.textLabel setFont:[UIFont fontWithName:@"OpenSans" size:18.0]];
            cell.textLabel.numberOfLines = 0;
        }

        cell.backgroundColor = [UIColor tc_Gray4:CFACurrentTheme];
        cell.textLabel.textColor = [UIColor tc_Gray900:CFACurrentTheme];

        MKRouteStep *step = [_directions objectAtIndex:indexPath.row];
        cell.textLabel.text = step.instructions;

        return cell;
    } else if(tableView==_routesTableView){
        NSString *CellIdentifier = @"RouteCell";

        RouteTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            NSArray *topLevelObjects;
            topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"RouteTableViewCell" owner:self options:nil];
            cell = [topLevelObjects objectAtIndex:0];

            [cell.routeName setFont:[UIFont fontWithName:@"Montserrat-Bold" size:18.0]];
            [cell.distance setFont:[UIFont fontWithName:@"OpenSans" size:18.0]];
            [cell.time setFont:[UIFont fontWithName:@"OpenSans" size:18.0]];
            [cell.alerts setFont:[UIFont fontWithName:@"OpenSans" size:18.0]];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }

        cell.backgroundColor = [UIColor tc_Gray4:CFACurrentTheme];
        UIColor *textColor = [UIColor tc_Gray900:CFACurrentTheme];
        cell.routeName.textColor = textColor;
        cell.distance.textColor = textColor;
        cell.time.textColor = textColor;
        cell.alerts.textColor = textColor;

        MKRoute *route = [_routes objectAtIndex:indexPath.row];

        cell.routeName.text = route.name;
        cell.distance.text = [NSString stringWithFormat:@"%.1f miles", route.distance / 1609.34];
        cell.time.text = [NSString stringWithFormat:@"%d min", (int)(route.expectedTravelTime / 60)];

        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;

        CGRect nameRect = [cell.routeName.text boundingRectWithSize:CGSizeMake(self.view.frame.size.width - 16, CGFLOAT_MAX)
                                                                  options:NSStringDrawingUsesLineFragmentOrigin
                                                               attributes:@{NSFontAttributeName:[UIFont fontWithName:@"Montserrat-Bold" size:18.0], NSParagraphStyleAttributeName:paragraphStyle.copy}
                                                                  context:nil];
        CGSize nameSize = nameRect.size;

        if(nameSize.height < 29)
            nameSize.height = 29;

        cell.routeName.frame = CGRectMake(cell.routeName.frame.origin.x, cell.routeName.frame.origin.y, cell.routeName.frame.size.width, nameSize.height);
        cell.distance.frame = CGRectMake(cell.distance.frame.origin.x, cell.routeName.frame.origin.y + cell.routeName.frame.size.height + 4, cell.distance.frame.size.width, cell.distance.frame.size.height);
        cell.time.frame = CGRectMake(cell.time.frame.origin.x, cell.distance.frame.origin.y, cell.time.frame.size.width, cell.time.frame.size.height);

        if(route.advisoryNotices!=nil && [route.advisoryNotices count]>0){
            cell.alerts.hidden = NO;
            NSMutableString *alertString = [[route.advisoryNotices objectAtIndex:0] mutableCopy];
            for(int i=1; i<route.advisoryNotices.count; i++){
                [alertString appendFormat:@"\n%@", [route.advisoryNotices objectAtIndex:i]];
            }

            CGRect alertRect = [alertString boundingRectWithSize:CGSizeMake(self.view.frame.size.width - 16, CGFLOAT_MAX)
                                                         options:NSStringDrawingUsesLineFragmentOrigin
                                                      attributes:@{NSFontAttributeName:[UIFont fontWithName:@"OpenSans" size:18.0], NSParagraphStyleAttributeName:paragraphStyle.copy}
                                                         context:nil];
            CGSize alertSize = alertRect.size;
            cell.alerts.frame = CGRectMake(cell.alerts.frame.origin.x, cell.time.frame.origin.y + cell.time.frame.size.height + 4, cell.alerts.frame.size.width, alertSize.height);
            cell.alerts.text = alertString;
        } else
            cell.alerts.hidden = YES;

        if(indexPath.row==selectedRouteIndex){
            cell.backgroundColor = [UIColor tc_Gray2:CFACurrentTheme];
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        } else {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }

        return cell;
    }

    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == _routesTableView) {
        selectedRouteIndex = (int)indexPath.row;
        [_routesTableView reloadData];

        for(MKPolyline *polyline in _routeOverlays){
            [_mapView removeOverlay:polyline];
        }

        for(int i=0; i<_routeOverlays.count; i++){
            if(i==selectedRouteIndex)
                continue;
            MKPolyline *polyline = [_routeOverlays objectAtIndex:i];
            [_mapView addOverlay:polyline level:MKOverlayLevelAboveRoads];
        }
        [_mapView addOverlay:[_routeOverlays objectAtIndex:selectedRouteIndex] level:MKOverlayLevelAboveRoads];

        MKRoute *route = [_routes objectAtIndex:selectedRouteIndex];
        [_mapView setVisibleMapRect:[route.polyline boundingMapRect] edgePadding:UIEdgeInsetsMake(40.0, 40.0, 40.0, 40.0) animated:YES];
    }
}

- (void) toggleDirections:(UITapGestureRecognizer*)gesture {
    if(_directionsLayout.frame.origin.y < self.view.frame.size.height - _directionsTitleLabel.frame.size.height - bottomMargin - 1){
        [UIView animateWithDuration:0.5 animations:^{
            self.directionsLayout.frame = CGRectMake(0, self.view.frame.size.height - self.directionsTitleLabel.frame.size.height - self->bottomMargin, self.directionsLayout.frame.size.width, self.directionsLayout.frame.size.height);
            self.directionsTableView.alpha = 0.0f;
        } completion:^(BOOL finished){
            self.directionsTitleLabel.text = @"Show Directions";
            self.directionsLayout.backgroundColor = [UIColor tc_PrimaryColor:CFACurrentTheme];
        }];
    } else {
        [UIView animateWithDuration:0.5 animations:^{
            self.directionsLayout.frame = CGRectMake(0, self.view.frame.size.height - self.directionsLayout.frame.size.height, self.directionsLayout.frame.size.width, self.directionsLayout.frame.size.height);
            self.directionsTableView.alpha = 1.0f;
        } completion:^(BOOL finished){
            self.directionsTitleLabel.text = @"Hide Directions";
            self.directionsLayout.backgroundColor = [UIColor tc_Gray2:CFACurrentTheme];
        }];
    }
}

- (void)themeDidChange:(CFATheme)theme {
    [super themeDidChange:theme];
    self.view.backgroundColor = [UIColor tc_Gray2:theme];
    self.addressLabel.backgroundColor = [UIColor tc_Gray];
    self.routesTitleLabel.backgroundColor = [UIColor tc_PrimaryColor:theme];
    self.routesDoneButton.backgroundColor = [UIColor tc_PrimaryColor:theme];
    [self.routesDoneButton setTitleColor:[UIColor tc_TextColorOnPrimary:theme]
                                forState:UIControlStateNormal];
    self.directionsTitleLabel.backgroundColor = [UIColor tc_PrimaryColor:theme];
    self.directionsLayout.backgroundColor = [UIColor tc_PrimaryColor:theme];
    self.routesLayout.backgroundColor = [UIColor tc_Gray2:theme];
    self.routesTableView.backgroundColor = [UIColor tc_Gray2:theme];
    self.directionsTableView.backgroundColor = [UIColor tc_Gray2:theme];
    self.routesTableView.separatorColor = [UIColor tc_Gray7:theme];
    self.directionsTableView.separatorColor = [UIColor tc_Gray7:theme];

    self.directionsTitleLabel.textColor = [UIColor tc_TextColorOnPrimary:theme];
    self.routesTitleLabel.textColor = [UIColor tc_TextColorOnPrimary:theme];
    self.addressLabel.textColor = [UIColor whiteColor];

    if (@available(iOS 13, *)) {
        switch (theme) {
            case CFAThemeLight:
                _mapView.overrideUserInterfaceStyle = UIUserInterfaceStyleLight;
            case CFAThemeDark:
                _mapView.overrideUserInterfaceStyle = UIUserInterfaceStyleDark;
        }
    }
}

@end
