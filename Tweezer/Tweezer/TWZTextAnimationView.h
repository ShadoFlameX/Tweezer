//
//  TWZTextAnimationView.h
//  Tweezer
//
//  Created by Bryan Hansen on 10/13/11.
//  Copyright (c) 2011 Übermind, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreText/CoreText.h>

@interface TWZTextAnimationView : UIView
{
    NSString *_text;
    CTFrameRef _frame;
}

- (id)initWithString:(NSString *)string;

@property (nonatomic,retain) NSString *text;

@end
