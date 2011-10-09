//
//  TWZQuoteBoardViewController.h
//  Tweezer
//
//  Created by Bryan Hansen on 10/8/11.
//  Copyright 2011 Übermind, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <RestKit/RestKit.h>

@interface TWZQuoteBoardViewController : UIViewController <RKObjectLoaderDelegate> {
    NSArray *_users;
}

@property (nonatomic,retain) NSArray *users;

@end
