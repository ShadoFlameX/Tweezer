//
//  TWZSourcePreset.m
//  Tweezer
//
//  Created by Bryan Hansen on 10/10/11.
//  Copyright (c) 2011 Übermind, Inc. All rights reserved.
//

#import "TWZSourcePreset.h"

@implementation TWZSourcePreset

@synthesize name = _name;

+ (NSArray *)allPresets {
    return [NSArray arrayWithObjects:
            [[[TWZSourcePreset alloc] initWithName:@"UX List"] autorelease],
            [[[TWZSourcePreset alloc] initWithName:@"Seattle Music Scene"] autorelease],
            [[[TWZSourcePreset alloc] initWithName:@"Cocoa Development Rockstars"] autorelease],
            [[[TWZSourcePreset alloc] initWithName:@"Religion & Politics"] autorelease],
            [[[TWZSourcePreset alloc] initWithName:@"Seattle"] autorelease],
            nil];
}

- (id)initWithName:(NSString *)name {
    self = [super init];
    if (self) {
        self.name = name;
    }
    return self;
}

@end
