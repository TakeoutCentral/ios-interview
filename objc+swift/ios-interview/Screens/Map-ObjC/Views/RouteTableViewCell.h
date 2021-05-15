//
//  RouteTableViewCell.h
//  Takeout Central Driver App
//
//  Created by Allen Luo on 6/2/15.
//  Copyright (c) 2015 Takeout Central. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface RouteTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *routeName;
@property (strong, nonatomic) IBOutlet UILabel *distance;
@property (strong, nonatomic) IBOutlet UILabel *time;
@property (strong, nonatomic) IBOutlet UILabel *alerts;

+ (float) heightForRoute:(MKRoute*)route andWidth:(float)width;

@end
