//
//  TWZSourcePreset.h
//  Tweezer
//
//  Created by Bryan Hansen on 10/10/11.
//  Copyright (c) 2011 Übermind, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TWZSourcePreset : NSObject {
    NSString *_name;
}

+ (NSArray *)allPresets;

- (id)initWithName:(NSString *)name;

@property (nonatomic,retain) NSString *name;

@end
