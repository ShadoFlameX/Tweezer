//
//  TWZSettingsViewController.h
//  Tweezer
//
//  Created by Bryan Hansen on 10/10/11.
//  Copyright (c) 2011 Übermind, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TWZSettingsViewController : UITableViewController

+ (NSDictionary *)dictionaryForUserDefaultsKey:(NSString *)key;

@end
