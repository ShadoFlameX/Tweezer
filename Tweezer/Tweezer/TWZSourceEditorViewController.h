//
//  TWZSourceEditorViewController.h
//  Tweezer
//
//  Created by Bryan Hansen on 10/10/11.
//  Copyright (c) 2011 Übermind, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TWZSourcePreset.h"

@interface TWZSourceEditorViewController : UITableViewController <UITextFieldDelegate> {
    
}

@property(nonatomic,retain) TWZSourcePreset *sourcePreset;

@end
