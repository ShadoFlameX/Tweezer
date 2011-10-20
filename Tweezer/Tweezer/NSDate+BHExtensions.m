//
//  NSDate+BHExtensions.m
//  Tweezer
//
//  Created by Bryan Hansen on 10/19/11.
//  Copyright (c) 2011 Übermind, Inc. All rights reserved.
//

#import "NSDate+BHExtensions.h"

@implementation NSDate (BHExtensions)

- (NSString *)relativeDifference:(NSDate *)oldDate
{
    NSDate *todayDate = [NSDate date];
    double ti = [oldDate timeIntervalSinceDate:todayDate];
    ti = ti * -1;
    if(ti < 1) {
        return @"never";
    } else      if (ti < 60) {
        return @"less than a minute ago";
    } else if (ti < 3600) {
        int diff = round(ti / 60);
        if (diff == 1) return [NSString stringWithFormat:@"%d minute ago", diff];
        else return [NSString stringWithFormat:@"%d minutes ago", diff];
    } else if (ti < 86400) {
        int diff = round(ti / 60 / 60);
        if (diff == 1) return[NSString stringWithFormat:@"%d hour ago", diff];
        else return[NSString stringWithFormat:@"%d hours ago", diff];        
    } else if (ti < 2629743) {
        int diff = round(ti / 60 / 60 / 24);
        if (diff == 1) return [NSString stringWithFormat:@"%d day ago", diff];
        else return [NSString stringWithFormat:@"%d days ago", diff];
    } else {
        return @"never";
    }   
}

@end
