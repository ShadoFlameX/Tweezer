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

@implementation TWZQuoteBoardViewController

@synthesize users = _users;
@synthesize statuses = _statuses;
@synthesize setupContainerView = _setupContainerView;
@synthesize statusLabel = _statusLabel;
@synthesize tweetTimer = _tweetTimer;

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
    
    if (NO) {
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
    if (NO) {
        [self.navigationController setNavigationBarHidden:YES animated:animated];
    }
    else {
        [self.navigationController setNavigationBarHidden:NO animated:animated];
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark - RKObjectLoaderDelegate methods

- (void)request:(RKRequest*)request didLoadResponse:(RKResponse*)response {
    NSLog(@"Loaded payload: %@", [response bodyAsString]);
}

- (void)objectLoader:(RKObjectLoader*)objectLoader didLoadObjects:(NSArray*)objects {
	NSLog(@"Loaded msg: %@", objects);
    for (TWZStatus *aStatus in objects) {
        if (!aStatus.inReplyToScreenName) {
            [self.statuses addObject:aStatus];
        }
    }
    if (!self.tweetTimer) {
        self.tweetTimer = [NSTimer scheduledTimerWithTimeInterval:5.0f target:self selector:@selector(showTweet) userInfo:nil repeats:YES];
    }
    if (_userIndex < self.users.count - 1) {
        _userIndex++;
        [self loadTweetsForUser:[self.users objectAtIndex:_userIndex]];
    }
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
    if (self.statuses.count) {
        NSUInteger index = rand()%self.statuses.count;
        TWZStatus *aStatus = [self.statuses objectAtIndex:index];
        self.statusLabel.text = aStatus.text;
    }
    else {
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
