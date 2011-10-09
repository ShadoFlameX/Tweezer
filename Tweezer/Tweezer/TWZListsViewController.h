//
//  TWZListsViewController.h
//  Tweezer
//
//  Created by Bryan Hansen on 10/8/11.
//  Copyright 2011 Übermind, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <RestKit/RestKit.h>

@interface TWZListsViewController : UITableViewController <RKObjectLoaderDelegate>

@property (nonatomic,retain) NSArray *lists;

@property (nonatomic,retain) NSIndexPath *loadingRowIndexPath;

@end
