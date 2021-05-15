//
//  UIColor+Theme.m
//  Takeout Central Driver App
//
//  Created by Michael Gray on 12/7/18.
//  Copyright © 2018 Takeout Central. All rights reserved.
//

#import "UIColor+Theme.h"
#import "CFAThemeManager.h"
#import "ios_interview-Swift.h"

@implementation UIColor (Theme)

+ (instancetype)tc_PrimaryColor:(CFATheme)theme {
    switch (theme) {
        case CFAThemeLight:
            return [UIColor tc_Orange600];

        case CFAThemeDark:
            return [UIColor tc_Gray3:theme];
    }
}

+ (instancetype)tc_PrimaryLightColor:(CFATheme)theme {
    switch (theme) {
        case CFAThemeLight:
            return [UIColor tc_Orange300];

        case CFAThemeDark:
            return [UIColor tc_Orange200];
    }
}

+ (instancetype)tc_PrimaryDarkColor:(CFATheme)theme {
    switch (theme) {
        case CFAThemeLight:
            return [UIColor tc_Orange800];

        case CFAThemeDark:
            return [UIColor blackColor];
    }
}

+ (instancetype)tc_SecondaryColor:(CFATheme)theme {
    switch (theme) {
        case CFAThemeLight:
            return [UIColor tc_Blue500];

        case CFAThemeDark:
            return [UIColor tc_Blue200];
    }
}

+ (instancetype)tc_ButtonColor1:(CFATheme)theme {
    switch (theme) {
        case CFAThemeLight:
            return [UIColor tc_Green800];

        case CFAThemeDark:
            return [UIColor tc_Green300];
    }
}

+ (instancetype)tc_ButtonColor2:(CFATheme)theme {
    switch (theme) {
        case CFAThemeLight:
            return [UIColor tc_Red400];

        case CFAThemeDark:
            return [UIColor tc_Red200];
    }
}

+ (instancetype)tc_ButtonColor3:(CFATheme)theme {
    switch (theme) {
        case CFAThemeLight:
            return [UIColor tc_Blue500];

        case CFAThemeDark:
            return [UIColor tc_Blue300];
    }
}

+ (instancetype)tc_TextColorOnPrimary:(CFATheme)theme {
    switch (theme) {
        case CFAThemeLight:
            return [UIColor whiteColor];

        case CFAThemeDark:
            return [UIColor tc_Orange300];
    }
}

+ (instancetype)tc_DarkSurfaceColor:(CFATheme)theme {
    switch (theme) {
        case CFAThemeLight:
            return [UIColor tc_Gray55];

        case CFAThemeDark:
            return [UIColor tc_Gray3:theme];
    }
}

+ (instancetype)tc_Gray1:(CFATheme)theme {
    switch (theme) {
        case CFAThemeLight:
            return [UIColor tc_Gray1_light];

        case CFAThemeDark:
            return [UIColor tc_Gray1_dark];
    }
}

+ (instancetype)tc_Gray2:(CFATheme)theme {
    switch (theme) {
        case CFAThemeLight:
            return [UIColor tc_Gray2_light];

        case CFAThemeDark:
            return [UIColor tc_Gray2_dark];
    }
}

+ (instancetype)tc_Gray3:(CFATheme)theme {
    switch (theme) {
        case CFAThemeLight:
            return [UIColor tc_Gray3_light];

        case CFAThemeDark:
            return [UIColor tc_Gray3_dark];
    }
}

+ (instancetype)tc_Gray4:(CFATheme)theme {
    switch (theme) {
        case CFAThemeLight:
            return [UIColor tc_Gray4_light];

        case CFAThemeDark:
            return [UIColor tc_Gray4_dark];
    }
}

+ (instancetype)tc_Gray5:(CFATheme)theme {
    switch (theme) {
        case CFAThemeLight:
            return [UIColor tc_Gray5_light];

        case CFAThemeDark:
            return [UIColor tc_Gray5_dark];
    }
}

+ (instancetype)tc_Gray6:(CFATheme)theme {
    switch (theme) {
        case CFAThemeLight:
            return [UIColor tc_Gray6_light];

        case CFAThemeDark:
            return [UIColor tc_Gray6_dark];
    }
}

+ (instancetype)tc_Gray7:(CFATheme)theme {
    switch (theme) {
        case CFAThemeLight:
            return [UIColor tc_Gray7_light];

        case CFAThemeDark:
            return [UIColor tc_Gray7_dark];
    }
}

+ (instancetype)tc_Gray8:(CFATheme)theme {
    switch (theme) {
        case CFAThemeLight:
            return [UIColor tc_Gray8_light];

        case CFAThemeDark:
            return [UIColor tc_Gray8_dark];
    }
}

+ (instancetype)tc_Gray900:(CFATheme)theme {
    switch (theme) {
        case CFAThemeLight:
            return [UIColor tc_Gray900_light];

        case CFAThemeDark:
            return [UIColor tc_Gray900_dark];
    }
}

@end
