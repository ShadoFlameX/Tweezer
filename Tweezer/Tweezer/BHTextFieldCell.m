//
//  BHTextFieldCell.m
//  Tweezer
//
//  Created by Bryan Hansen on 10/12/11.
//  Copyright (c) 2011 Übermind, Inc. All rights reserved.
//

#import "BHTextFieldCell.h"
#import "UIColor+BHExtensions.h"

@implementation BHTextFieldCell

@synthesize textField = _textField;
@synthesize titleWidth = _titleWidth;

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self) {
        self.titleWidth = 80.0f;
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.textField = [[UITextField alloc] initWithFrame:CGRectZero];
        self.textField.font = [UIFont systemFontOfSize:[UIFont labelFontSize]];
        self.textField.textColor = [UIColor selectedTextColor];

        [self.contentView addSubview:self.textField];
        
//        self.textLabel.backgroundColor = [UIColor greenColor];
//        self.textField.backgroundColor = [UIColor redColor];
    }
    return self;
}

- (void)prepareForReuse {
    [super prepareForReuse];  
    self.textField.delegate = nil;
    self.textField.text = nil;
    self.textField.placeholder = nil;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGRect titleRect, textFieldRect;
    titleRect = CGRectInset(self.contentView.bounds, 10.0f, 0.0f);
    if (self.titleWidth) {
        CGRectDivide(titleRect, &titleRect, &textFieldRect, self.titleWidth + 8.0f, CGRectMinXEdge);
        titleRect.size.width -= 8.0f;
    }
    else {
        textFieldRect = titleRect;
        titleRect = CGRectZero;
    }
    
    textFieldRect = CGRectInset(textFieldRect, 0.0f, floorf((self.contentView.bounds.size.height - self.textField.font.lineHeight)/2));
    
    self.textLabel.frame = titleRect;
    self.textField.frame = textFieldRect;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
