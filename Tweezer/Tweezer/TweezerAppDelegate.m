//
//  TweezerAppDelegate.m
//  Tweezer
//
//  Created by Bryan Hansen on 10/6/11.
//  Copyright 2011 Übermind, Inc. All rights reserved.
//

#import "TweezerAppDelegate.h"
#import "TWZListsViewController.h"
#import "TWZStatus.h"
#import "TWZUser.h"
#import "TWZList.h"
#import "TWZConstants.h"

@implementation TweezerAppDelegate

@synthesize window = _window;
@synthesize navigationController = _navigationController;

+ (void)initialize
{
    NSDictionary *defaults = [NSDictionary dictionaryWithObjectsAndKeys:
                              [NSNumber numberWithInt:0],TWZUserDefaultShuffleMode,
                              [NSNumber numberWithInt:5],TWZUserDefaultQuoteDuration,
                              nil];
    [[NSUserDefaults standardUserDefaults] registerDefaults:defaults];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    // Initialize RestKit
	RKObjectManager* objectManager = [RKObjectManager objectManagerWithBaseURL:@"http://twitter.com"];
    
    // Enable automatic network activity indicator management
    objectManager.client.requestQueue.showsNetworkActivityIndicatorWhenBusy = YES;
    
    // OAuth setup
    objectManager.client.baseURL = @"http://www.driftinglight.com";
    objectManager.client.OAuth1ConsumerKey = @"iDXS8ft8ygFp85V4U0DQ";
    objectManager.client.OAuth1ConsumerSecret = @"tUG3YGMMJZ4nS0aNORVxvKRtl0JkC9FEMXAjc55gKSI";
    objectManager.client.OAuth1AccessToken = @"41256728-v97mfbMcWuj26fWRN5dCEKJZ27d5BBRuESrxERQ1Q";
    objectManager.client.OAuth1AccessTokenSecret = @"m9fW6ordiH89ksNwG5nWwYVoYCVVtoiaQXKFHShSSo";
    objectManager.client.authenticationType = RKRequestAuthenticationTypeOAuth1;
    
    // Setup our object mappings
    RKObjectMapping* userMapping = [RKObjectMapping mappingForClass:[TWZUser class]];
    [userMapping mapKeyPath:@"id" toAttribute:@"userID"];
    [userMapping mapKeyPath:@"screen_name" toAttribute:@"screenName"];
    [userMapping mapAttributes:@"name", nil];
    
    RKObjectMapping* statusMapping = [RKObjectMapping mappingForClass:[TWZStatus class]];
    [statusMapping mapKeyPathsToAttributes:@"id", @"statusID",
     @"created_at", @"createdAt",
     @"text", @"text",
     @"url", @"urlString",
     @"in_reply_to_screen_name", @"inReplyToScreenName",
     @"favorited", @"isFavorited",
     nil];
    [statusMapping mapRelationship:@"user" withMapping:userMapping];
    
    RKObjectMapping* listMapping = [RKObjectMapping mappingForClass:[TWZList class]];
    [listMapping mapKeyPathsToAttributes:@"id", @"listID",
     @"name", @"name",
     nil];
    
    // Update date format so that we can parse Twitter dates properly
	// Wed Sep 29 15:31:08 +0000 2010
    [RKObjectMapping addDefaultDateFormatterForString:@"E MMM d HH:mm:ss Z y" inTimeZone:nil];
    
    // Register our mappings with the provider
    [objectManager.mappingProvider setMapping:userMapping forKeyPath:@"user"];
    [objectManager.mappingProvider setMapping:statusMapping forKeyPath:@"status"];
    [objectManager.mappingProvider setMapping:listMapping forKeyPath:@"list"];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    TWZQuoteBoardViewController *qbVC = [[TWZQuoteBoardViewController alloc] initWithNibName:@"TWZQuoteBoardViewController" bundle:nil]; 
    self.navigationController = [[UINavigationController alloc] initWithRootViewController:qbVC];

//    TWZListsViewController *vc = [[TWZListsViewController alloc] initWithNibName:@"TWZListsViewController" bundle:nil];
//    self.navigationController = [[UINavigationController alloc] initWithRootViewController:vc];

    
    self.window.rootViewController = self.navigationController;
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

@end
