//
//  TWZSourceEditorViewController.h
//  Tweezer
//
//  Created by Bryan Hansen on 10/10/11.
//  Copyright (c) 2011 Übermind, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TWZSourcePreset.h"
#import "TWZListsViewController.h"

@interface TWZSourceEditorViewController : UITableViewController <TWZListsViewControllerDelegate,UITextFieldDelegate> {
    
}

@property(nonatomic,retain) TWZSourcePreset *sourcePreset;

@end
