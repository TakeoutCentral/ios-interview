//
//  MapViewController.h
//  Takeout Central Driver App
//
//  Created by Allen Luo on 4/2/15.
//  Copyright (c) 2015 Takeout Central. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@class TCMapInfo;

@interface MapViewController : UIViewController<MKMapViewDelegate, CLLocationManagerDelegate, UIActionSheetDelegate>{
    int selectedRouteIndex;
    BOOL initialized;
    CLLocationCoordinate2D destCoord;
    float bottomMargin;
}

@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSString *addressName;
@property (strong, nonatomic) IBOutlet UILabel *addressLabel;

@property (nonatomic, strong) TCMapInfo *mapInfo;
@property (nonatomic, strong) CLGeocoder *geocoder;

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) CLLocation *currentLocation;

@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) IBOutlet UIButton *navButton;

@property (nonatomic, strong) NSMutableArray *annotations;
@property (nonatomic, assign) BOOL mapPinsPlaced;
@property (nonatomic, assign) BOOL mapPannedSinceLocationUpdate;

@property (nonatomic, strong) NSArray *directions;
@property (nonatomic, strong) NSArray *routes;
@property (nonatomic, strong) NSMutableArray *routeOverlays;


@property (strong, nonatomic) IBOutlet UIView *directionsLayout;
@property (strong, nonatomic) IBOutlet UILabel *directionsTitleLabel;
@property (strong, nonatomic) IBOutlet UITableView *directionsTableView;

@property (strong, nonatomic) IBOutlet UILabel *routesTitleLabel;
@property (strong, nonatomic) IBOutlet UITableView *routesTableView;
@property (strong, nonatomic) IBOutlet UIView *routesLayout;
@property (strong, nonatomic) IBOutlet UIButton *routesDoneButton;

- (IBAction)onRoutesDone:(id)sender;
- (IBAction)onLocationsPressed:(id)sender;
- (IBAction)onNavPressed:(id)sender;

@end
