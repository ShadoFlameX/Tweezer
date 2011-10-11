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
    NSUInteger _userIndex; // booo
    UIView *_setupContainerView;
    UILabel *_statusLabel;
}

- (IBAction)showSettings:(id)sender;

@property (nonatomic,retain) NSArray *users;
@property (nonatomic,retain) NSMutableArray *statuses;
@property (nonatomic,retain) IBOutlet UIView *setupContainerView;
@property (nonatomic,retain) IBOutlet UILabel *statusLabel;
@property (nonatomic,assign) NSTimer *tweetTimer;

@end
