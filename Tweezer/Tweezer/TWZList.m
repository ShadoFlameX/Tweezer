//
//  TWZList.m
//  Tweezer
//
//  Created by Bryan Hansen on 10/7/11.
//  Copyright 2011 Übermind, Inc. All rights reserved.
//

#import "TWZList.h"

@implementation TWZList

@synthesize listID;
@synthesize name;

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        self.listID = [aDecoder decodeObjectForKey:@"listID"];
        self.name = [aDecoder decodeObjectForKey:@"name"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.listID forKey:@"listID"];
    [aCoder encodeObject:self.name forKey:@"name"];
}

@end
