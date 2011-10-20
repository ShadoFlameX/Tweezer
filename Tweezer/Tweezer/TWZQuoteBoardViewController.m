//
//  TWZQuoteBoardViewController.m
//  Tweezer
//
//  Created by Bryan Hansen on 10/8/11.
//  Copyright 2011 Übermind, Inc. All rights reserved.
//

#import "TWZQuoteBoardViewController.h"
#import "TWZSettingsViewController.h"
#import "TWZStatus.h"
#import "TWZList.h"
#import "TWZSourcePreset.h"

@interface TWZQuoteBoardViewController ()
- (void)showTweet;
@end

@implementation TWZQuoteBoardViewController

@synthesize users = _users;
@synthesize statuses = _statuses;
@synthesize unshownStatuses = _unshownStatuses;
@synthesize setupContainerView = _setupContainerView;
@synthesize statusLabel = _statusLabel;
@synthesize tweetTimer = _tweetTimer;
@synthesize quoteView = _quoteView;

- (void)loadTweetsForUser:(TWZUser *)user
{
    RKObjectManager* objectManager = [RKObjectManager sharedManager];
    objectManager.client.baseURL = @"http://api.twitter.com";
    [objectManager loadObjectsAtResourcePath:[NSString stringWithFormat:@"/1/statuses/user_timeline.json?user_id=%@",user.userID] delegate:self block:^(RKObjectLoader* loader) {
        if ([objectManager.acceptMIMEType isEqualToString:RKMIMETypeJSON]) {
            loader.objectMapping = [objectManager.mappingProvider objectMappingForClass:[TWZStatus class]];
        }
    }];
}

- (void)loadTweetsForList:(TWZList *)list
{
    RKObjectManager* objectManager = [RKObjectManager sharedManager];
    objectManager.client.baseURL = @"http://api.twitter.com";
    [objectManager loadObjectsAtResourcePath:[NSString stringWithFormat:@"/1/lists/statuses.json?list_id=%@&per_page=100",list.listID] delegate:self block:^(RKObjectLoader* loader) {
        if ([objectManager.acceptMIMEType isEqualToString:RKMIMETypeJSON]) {
            loader.objectMapping = [objectManager.mappingProvider objectMappingForClass:[TWZStatus class]];
        }
    }];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.statuses = [NSMutableArray array];
    
    if ([TWZSourcePreset allPresets].count) {
        [self.setupContainerView removeFromSuperview];
    }
    else {
        self.setupContainerView.frame = self.view.bounds;
        [self.view addSubview:self.setupContainerView];
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated {
    if ([TWZSourcePreset allPresets].count) {
        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
        [self.navigationController setNavigationBarHidden:YES animated:animated];
        [self loadTweetsForList:((TWZSourcePreset *)[[TWZSourcePreset allPresets] objectAtIndex:0]).list];
    }
    else {
        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
        [self.navigationController setNavigationBarHidden:NO animated:animated];
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait ||
            interfaceOrientation == UIInterfaceOrientationLandscapeLeft ||
            interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}


#pragma mark - RKObjectLoaderDelegate methods

- (void)request:(RKRequest*)request didLoadResponse:(RKResponse*)response {
//    NSLog(@"Loaded payload: %@", [response bodyAsString]);
}

- (void)objectLoader:(RKObjectLoader*)objectLoader didLoadObjects:(NSArray*)objects {
//	NSLog(@"Loaded msg: %@", objects);
    for (TWZStatus *aStatus in objects) {
        if (!aStatus.inReplyToScreenName) {
            [self.statuses addObject:aStatus];
        }
    }
    self.unshownStatuses = [NSMutableArray arrayWithArray:self.statuses];
    
    if (!self.tweetTimer) {
        self.tweetTimer = [NSTimer scheduledTimerWithTimeInterval:8.0f target:self selector:@selector(showTweet) userInfo:nil repeats:YES];
        [self showTweet];
    }
//    if (_userIndex < self.users.count - 1) {
//        _userIndex++;
//        [self loadTweetsForUser:[self.users objectAtIndex:_userIndex]];
//    }
}

- (void)objectLoader:(RKObjectLoader*)objectLoader didFailWithError:(NSError*)error {
	UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[alert show];
	NSLog(@"Hit error: %@", error);
}


#pragma mark - API

- (IBAction)showSettings:(id)sender
{
    TWZSettingsViewController *settingsVC = [[TWZSettingsViewController alloc] initWithNibName:@"TWZSettingsViewController" bundle:nil];
    UINavigationController *navCon = [[UINavigationController alloc] initWithRootViewController:settingsVC];
    [self presentModalViewController:navCon animated:YES];
    [settingsVC release];
    [navCon release];
}

- (void)showTweet
{
    if (self.unshownStatuses.count) {
        NSUInteger index = rand()%self.unshownStatuses.count;
        TWZStatus *aStatus = [self.unshownStatuses objectAtIndex:index];
        
        [self.quoteView removeFromSuperview];
        
        self.quoteView = [[TWZQuoteView alloc] initWithFrame:CGRectInset(self.view.bounds, 15.0f, 10.0f)];
        // flexbile causes a crash at the moment
//        self.quoteView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.quoteView.quote = aStatus.text;
        self.quoteView.credit = aStatus.user.screenName;
        self.quoteView.additionalInfo = aStatus.user.name;
        [self.quoteView sizeToFit];
        self.quoteView.hidden = YES;
        
        CGRect rect = self.quoteView.frame;
        rect.origin.x = floorf((self.view.bounds.size.width - rect.size.width)/2.0f);
        rect.origin.y = floorf((self.view.bounds.size.height - rect.size.height)/2.0f);
        self.quoteView.frame = rect;
        
        [self.view addSubview:self.quoteView];
        [self.quoteView release];
                
        [self.quoteView setHidden:NO animated:YES];
        [self.unshownStatuses removeObjectAtIndex:index];
    }
    else if (self.statuses.count)
    {
        self.unshownStatuses = [NSMutableArray arrayWithArray:self.statuses];
        [self showTweet];
    }
    else
    {
        [self.tweetTimer invalidate];
    }
}


#pragma mark - setters/getters

- (void)setUsers:(NSArray *)users
{
    if (users == _users) return;
    
    [users retain];
    [_users release];
    _users = users;
    
    if (self.users.count) {
        [self loadTweetsForUser:[self.users objectAtIndex:0]];
        _userIndex = 0;
    }
}


@end
