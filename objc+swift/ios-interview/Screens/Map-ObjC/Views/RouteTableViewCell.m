//
//  RouteTableViewCell.m
//  Takeout Central Driver App
//
//  Created by Allen Luo on 6/2/15.
//  Copyright (c) 2015 Takeout Central. All rights reserved.
//

#import "RouteTableViewCell.h"

@implementation RouteTableViewCell

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (float) heightForRoute:(MKRoute*)route andWidth:(float)width{
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    
    CGRect nameRect = [route.name boundingRectWithSize:CGSizeMake(width - 16, CGFLOAT_MAX)
                                                               options:NSStringDrawingUsesLineFragmentOrigin
                                                            attributes:@{NSFontAttributeName:[UIFont fontWithName:@"Montserrat-Bold" size:18.0], NSParagraphStyleAttributeName:paragraphStyle.copy}
                                                               context:nil];
    CGSize nameSize = nameRect.size;
    if(route.advisoryNotices==nil || [route.advisoryNotices count]==0)
        return  8 + nameSize.height + 4 + 29 + 8;
    
    NSMutableString *alertString = [[route.advisoryNotices objectAtIndex:0] mutableCopy];
    for(int i=1; i<route.advisoryNotices.count; i++){
        [alertString appendFormat:@"\n%@", [route.advisoryNotices objectAtIndex:i]];
    }
    
    CGRect alertRect = [alertString boundingRectWithSize:CGSizeMake(width - 16, CGFLOAT_MAX)
                                               options:NSStringDrawingUsesLineFragmentOrigin
                                            attributes:@{NSFontAttributeName:[UIFont fontWithName:@"OpenSans" size:18.0], NSParagraphStyleAttributeName:paragraphStyle.copy}
                                               context:nil];
    CGSize alertSize = alertRect.size;
    return  8 + nameSize.height + 4 + 29 + 4 + alertSize.height + 8;
}

@end
