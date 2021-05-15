//
//  UIColor+Theme.h
//  Takeout Central Driver App
//
//  Created by Michael Gray on 12/7/18.
//  Copyright © 2018 Takeout Central. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM (NSInteger, CFATheme);

@interface UIColor (Theme)

+ (instancetype)tc_PrimaryColor:(CFATheme)theme;
+ (instancetype)tc_PrimaryLightColor:(CFATheme)theme;
+ (instancetype)tc_PrimaryDarkColor:(CFATheme)theme;
+ (instancetype)tc_SecondaryColor:(CFATheme)theme;

+ (instancetype)tc_ButtonColor1:(CFATheme)theme;
+ (instancetype)tc_ButtonColor2:(CFATheme)theme;
+ (instancetype)tc_ButtonColor3:(CFATheme)theme;

+ (instancetype)tc_TextColorOnPrimary:(CFATheme)theme;
+ (instancetype)tc_DarkSurfaceColor:(CFATheme)theme;

+ (instancetype)tc_Gray1:(CFATheme)theme;
+ (instancetype)tc_Gray2:(CFATheme)theme;
+ (instancetype)tc_Gray3:(CFATheme)theme;
+ (instancetype)tc_Gray4:(CFATheme)theme;
+ (instancetype)tc_Gray5:(CFATheme)theme;
+ (instancetype)tc_Gray6:(CFATheme)theme;
+ (instancetype)tc_Gray7:(CFATheme)theme;
+ (instancetype)tc_Gray8:(CFATheme)theme;
+ (instancetype)tc_Gray900:(CFATheme)theme;

@end

NS_ASSUME_NONNULL_END
