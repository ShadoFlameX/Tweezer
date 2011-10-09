//
//  TweezerAppDelegate.h
//  Tweezer
//
//  Created by Bryan Hansen on 10/6/11.
//  Copyright 2011 Übermind, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <RestKit/RestKit.h>
#import "TWZListsViewController.h"

@class TweezerViewController;

@interface TweezerAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) UINavigationController *navigationController;

@end
