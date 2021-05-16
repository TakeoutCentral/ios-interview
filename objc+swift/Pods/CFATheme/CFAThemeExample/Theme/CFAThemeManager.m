//
//  CFAThemeManager.m
//  CFAThemeExample
//
//  Created by Bradley Mueller on 8/11/17.
//  Copyright © 2017 Cellaflora. All rights reserved.
//

#import "CFAThemeManager.h"
#import <UIKit/UIKit.h>

#define THEME_DEBUG_MODE 0

static NSString *const kForcedThemeDefaultsKey = @"kForcedThemeDefaultsKey";
NSString *const kThemeChangedKey = @"kThemeChangedKey";

@interface CFAThemeManager ()

@property (nonatomic, readwrite) CFATheme currentTheme;

@end

@implementation CFAThemeManager

+ (instancetype)sharedManager
{
    static CFAThemeManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[CFAThemeManager alloc] init];
    });
    return manager;
}

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(appDidBecomeActive)
                                                     name:UIApplicationDidBecomeActiveNotification
                                                   object:nil];
        
        [self setCurrentTheme:[self calculateCurrentTheme] animated:NO];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Setters/getters

- (void)setCurrentTheme:(CFATheme)currentTheme
{
    [self setCurrentTheme:currentTheme animated:YES];
}

- (void)setCurrentTheme:(CFATheme)currentTheme animated:(BOOL)animated
{
    if (_currentTheme != currentTheme)
    {
        _currentTheme = currentTheme;
        
        [UIView animateWithDuration:animated ? 0.5 : 0.0
                              delay:0
             usingSpringWithDamping:1
              initialSpringVelocity:0
                            options:0
                         animations:^{
                             [[NSNotificationCenter defaultCenter] postNotificationName:kThemeChangedKey
                                                                                 object:@(currentTheme)];
                         }
                         completion:nil];
    }
}

- (void)setForcedTheme:(NSNumber *)forcedTheme
{
    if (forcedTheme) {
        [[NSUserDefaults standardUserDefaults] setObject:forcedTheme forKey:kForcedThemeDefaultsKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
    } else {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:kForcedThemeDefaultsKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    self.currentTheme = [self calculateCurrentTheme];
}

- (NSNumber *)forcedTheme
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:kForcedThemeDefaultsKey];
}

#pragma mark - Calculations

- (CFATheme)calculateCurrentTheme
{
#if THEME_DEBUG_MODE == 1
    // Alternate themes periodically - useful for testing on Simulator
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(brightnessDidChange:) object:nil];
    [self performSelector:@selector(brightnessDidChange:) withObject:nil afterDelay:10];
    return (CFATheme)ABS(1 - self.currentTheme);
#endif
    
    if (self.forcedTheme != nil)
    {
        return [self.forcedTheme integerValue];
    }
    
    if (self.sunrise && self.sunset) {
        NSDateComponents *current = [[NSCalendar currentCalendar]
                                     components:NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond fromDate:[NSDate date]];
        
        NSMutableArray *times = [@[self.sunrise, current, self.sunset] mutableCopy];
        [times sortUsingComparator:^NSComparisonResult(NSDateComponents *t1, NSDateComponents *t2) {
            if (t1.hour > t2.hour) {
                return NSOrderedDescending;
            }
            
            if (t1.hour < t2.hour) {
                return NSOrderedAscending;
            }
            // hour is the same
            if (t1.minute > t2.minute) {
                return NSOrderedDescending;
            }
            
            if (t1.minute < t2.minute) {
                return NSOrderedAscending;
            }
            // hour and minute are the same
            if (t1.second > t2.second) {
                return NSOrderedDescending;
            }
            
            if (t1.second < t2.second) {
                return NSOrderedAscending;
            }
            return NSOrderedSame;
        }];
        if ([times indexOfObject:current] == 1) {
            return CFAThemeLight;
        } else {
            return CFAThemeDark;
        }
    } else {
        return CFAThemeLight;
    }
}

- (void)appDidBecomeActive
{
    self.currentTheme = [self calculateCurrentTheme];
}

@end
