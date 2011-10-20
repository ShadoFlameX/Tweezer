//
//  TWZQuoteBoardViewController.h
//  Tweezer
//
//  Created by Bryan Hansen on 10/8/11.
//  Copyright 2011 Übermind, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <RestKit/RestKit.h>
#import "TWZTextAnimationView.h"
#import "TWZQuoteView.h"

@interface TWZQuoteBoardViewController : UIViewController <RKObjectLoaderDelegate> {
    NSArray *_users;
    NSMutableArray *_statuses;
    NSMutableArray *_unshownStatuses;
    NSUInteger _userIndex; // booo
    UIView *_setupContainerView;
    UILabel *_statusLabel;
    TWZQuoteView *_quoteView;
}

- (IBAction)showSettings:(id)sender;

@property (nonatomic,retain) NSArray *users;
@property (nonatomic,retain) NSMutableArray *statuses;
@property (nonatomic,retain) NSMutableArray *unshownStatuses;
@property (nonatomic,retain) IBOutlet UIView *setupContainerView;
@property (nonatomic,retain) IBOutlet UILabel *statusLabel;
@property (nonatomic,retain) TWZQuoteView *quoteView;
@property (nonatomic,assign) NSTimer *tweetTimer;

@end
