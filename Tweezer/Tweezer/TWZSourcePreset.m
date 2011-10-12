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
@synthesize keywords = _keywords;
@synthesize matching = _matching;
@synthesize includesResponses = _includesResponses;
@synthesize includesRetweets = _includesRetweets;

+ (NSArray *)allPresets {
    return [NSArray arrayWithObjects:
            [[[TWZSourcePreset alloc] initWithName:@"UX List"] autorelease],
            [[[TWZSourcePreset alloc] initWithName:@"Seattle Music Scene"] autorelease],
            [[[TWZSourcePreset alloc] initWithName:@"Cocoa Development Rockstars"] autorelease],
            [[[TWZSourcePreset alloc] initWithName:@"Religion & Politics"] autorelease],
            [[[TWZSourcePreset alloc] initWithName:@"Seattle"] autorelease],
            nil];
}

+ (NSString *)nameForMatching:(TWZSourcePresetKeywordsMatch)match
{
    switch (match) {
        case TWZSourcePresetKeywordsMatchAll:
            return NSLocalizedString(@"Match All", @"source keywords matching name");            
        case TWZSourcePresetKeywordsMatchAny:
        default:
            return NSLocalizedString(@"Match Any", @"source keywords matching name");
    }
}

- (id)initWithName:(NSString *)name {
    self = [super init];
    if (self) {
        self.name = name;
        self.keywords = [NSMutableArray array];
        self.matching = TWZSourcePresetKeywordsMatchAny;
        self.includesResponses = NO;
        self.includesRetweets = NO;
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone {
    TWZSourcePreset *copy = [[TWZSourcePreset alloc] initWithName:self.name];
    if (copy) {
        copy.keywords = [self.keywords mutableCopy];
        copy.matching = self.matching;
        copy.includesResponses = self.includesResponses;
        copy.includesRetweets = self.includesRetweets;
    }
    return copy;
}

@end
