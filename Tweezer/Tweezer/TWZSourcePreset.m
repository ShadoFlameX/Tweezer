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
@synthesize list;
@synthesize keywords = _keywords;
@synthesize matching = _matching;
@synthesize includesResponses = _includesResponses;
@synthesize includesRetweets = _includesRetweets;

static NSArray *_allPresets = nil;

+ (NSArray *)allPresets {
    if (!_allPresets) {
        NSArray *savedPresets = [NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"presets"]];
        _allPresets = [savedPresets retain];
        
//        [[[TWZSourcePreset alloc] initWithName:@"Seattle Music Scene"] autorelease],
//        [[[TWZSourcePreset alloc] initWithName:@"Cocoa Development Rockstars"] autorelease],
//        [[[TWZSourcePreset alloc] initWithName:@"Religion & Politics"] autorelease],
//        [[[TWZSourcePreset alloc] initWithName:@"Seattle"] autorelease],
    }
    return _allPresets;
}

+ (void)addPreset:(TWZSourcePreset *)preset
{
    NSMutableArray *array = [NSMutableArray arrayWithArray:_allPresets];
    [array addObject:preset];
    
    [array retain];
    [_allPresets release];
    _allPresets = array;
    
    [TWZSourcePreset savePresets];
}

+ (void)savePresets
{
    NSData *encodedData = [NSKeyedArchiver archivedDataWithRootObject:_allPresets];
    [[NSUserDefaults standardUserDefaults] setObject:encodedData forKey:@"presets"];
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

- (id)initWithName:(NSString *)name
{
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

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        self.name = [aDecoder decodeObjectForKey:@"name"];
        self.list = [aDecoder decodeObjectForKey:@"list"];
        self.keywords = [aDecoder decodeObjectForKey:@"keywords"];
        self.matching = [aDecoder decodeIntForKey:@"matching"];
        self.includesResponses = [aDecoder decodeBoolForKey:@"includesResponses"];
        self.includesRetweets = [aDecoder decodeBoolForKey:@"includesRetweets"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeObject:self.list forKey:@"list"];
    [aCoder encodeObject:self.keywords forKey:@"keywords"];
    [aCoder encodeInt:self.matching forKey:@"matching"];
    [aCoder encodeBool:self.includesResponses forKey:@"includesResponses"];
    [aCoder encodeBool:self.includesRetweets forKey:@"includesRetweets"];
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

- (NSString *)description {
    return [NSString stringWithFormat:@"%@ - name: %@, list: %@, keywords: %@, matching: %@, include responses: %d, include retweets: %d,",
            [super description],
            self.name,
            self.list,
            self.keywords,
            [TWZSourcePreset nameForMatching:self.matching],
            self.includesResponses,
            self.includesRetweets];
}

@end
