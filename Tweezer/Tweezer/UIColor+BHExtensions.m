//
//  UIColor+BHExtensions.m
//  BH
//
//  Created by Bryan Hansen on 10/11/11.
//  Copyright (c) 2011 Übermind, Inc. All rights reserved.
//

#import "UIColor+BHExtensions.h"

#define RGB255(val) (val/255.0f)

@implementation UIColor (BHExtensions)

+ (UIColor *)selectedTextColor
{
    return [UIColor colorWithRed:RGB255(43) green:RGB255(63) blue:RGB255(118) alpha:1.0f];
}

@end
