//
//  UIColor+TweezerExtensions.m
//  Tweezer
//
//  Created by Bryan Hansen on 10/11/11.
//  Copyright (c) 2011 Übermind, Inc. All rights reserved.
//

#import "UIColor+TweezerExtensions.h"

#define RGB255(val) (val/255.0f)

@implementation UIColor (TweezerExtensions)

+ (UIColor *)addSourcePresetTextColor
{
    return [UIColor colorWithRed:RGB255(20) green:RGB255(180) blue:RGB255(20) alpha:1.0f];
}

@end
