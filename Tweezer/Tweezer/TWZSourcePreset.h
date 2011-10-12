//
//  TWZSourcePreset.h
//  Tweezer
//
//  Created by Bryan Hansen on 10/10/11.
//  Copyright (c) 2011 Übermind, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    TWZSourcePresetKeywordsMatchAny,
    TWZSourcePresetKeywordsMatchAll
} TWZSourcePresetKeywordsMatch;

@interface TWZSourcePreset : NSObject <NSCopying> {
    NSString *_name;
    NSMutableArray *_keywords;
    TWZSourcePresetKeywordsMatch _matching;
    BOOL _includesResponses;
    BOOL _includesRetweets;
}

+ (NSArray *)allPresets;
+ (NSString *)nameForMatching:(TWZSourcePresetKeywordsMatch)match;

- (id)initWithName:(NSString *)name;


@property (nonatomic,copy) NSString *name;
@property (nonatomic,retain) NSMutableArray *keywords;
@property (nonatomic,assign) TWZSourcePresetKeywordsMatch matching;
@property (nonatomic,assign) BOOL includesResponses;
@property (nonatomic,assign) BOOL includesRetweets;

@end
