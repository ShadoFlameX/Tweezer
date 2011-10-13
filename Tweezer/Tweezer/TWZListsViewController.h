//
//  TWZListsViewController.h
//  Tweezer
//
//  Created by Bryan Hansen on 10/8/11.
//  Copyright 2011 Übermind, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <RestKit/RestKit.h>
#import "TWZList.h"

@class TWZListsViewController;
@protocol TWZListsViewControllerDelegate <NSObject>
- (void)listViewController:(TWZListsViewController *)listViewController didSelectList:(TWZList *)list;
@end

@interface TWZListsViewController : UITableViewController <RKObjectLoaderDelegate>

@property (nonatomic,assign) id <TWZListsViewControllerDelegate> delegate;
@property (nonatomic,retain) NSArray *lists;
@property (nonatomic,retain) NSIndexPath *loadingRowIndexPath;

@end
