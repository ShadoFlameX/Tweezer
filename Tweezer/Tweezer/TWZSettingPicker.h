//
//  TWZSettingPicker.h
//  Tweezer
//
//  Created by Bryan Hansen on 10/10/11.
//  Copyright (c) 2011 Übermind, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TWZSettingPicker : UITableViewController {
    NSString *_defaultsKey;
    NSDictionary *_settings;
    NSComparator _keyComparitor;
}

- (id)initWithUserDefaultsKey:(NSString *)defaultsKey
                     settings:(NSDictionary *)settings
                   comparitor:(NSComparator)comparitor;

@property (nonatomic,retain) NSString *defaultsKey;
@property (nonatomic,retain) NSDictionary *settings;
@property (nonatomic,retain) NSComparator keyComparitor;

@end
