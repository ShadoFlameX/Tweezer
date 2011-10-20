//
//  TweezerAppDelegate.h
//  Tweezer
//
//  Created by Bryan Hansen on 10/6/11.
//  Copyright 2011 Übermind, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <RestKit/RestKit.h>
#import "TWZQuoteBoardViewController.h"

@class TweezerViewController;

@interface TweezerAppDelegate : UIResponder <UIApplicationDelegate>

@property (nonatomic,retain) UIWindow *window;
@property (nonatomic,retain) UIWindow *secondaryWindow;
@property (nonatomic,retain) UINavigationController *navigationController;
@property (nonatomic,retain) TWZQuoteBoardViewController *quoteBoardViewController;

@end
