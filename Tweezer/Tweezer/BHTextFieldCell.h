//
//  BHTextFieldCell.h
//  Tweezer
//
//  Created by Bryan Hansen on 10/12/11.
//  Copyright (c) 2011 Übermind, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BHTextFieldCell : UITableViewCell {
    UITextField *_textField;
    CGFloat _titleWidth;
}

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier;

@property (nonatomic,retain) UITextField *textField;
@property (nonatomic,assign) CGFloat titleWidth;

@end
