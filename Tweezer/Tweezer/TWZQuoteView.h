//
//  TWZQuoteView.h
//  Tweezer
//
//  Created by Bryan Hansen on 10/19/11.
//  Copyright (c) 2011 Übermind, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TWZTextAnimationView.h"

typedef enum {
    TWZQuoteViewFontSizeSmall,
    TWZQuoteViewFontSizeMedium,
    TWZQuoteViewFontSizeLarge
} TWZQuoteViewFontSize;

@interface TWZQuoteView : UIView
{
    TWZTextAnimationView *_quoteTextView;
    TWZTextAnimationView *_creditTextView;
    TWZTextAnimationView *_addInfoTextView;
}

+ (CGFloat)quoteFontSize;

- (void)setHidden:(BOOL)hidden animated:(BOOL)animated;

@property (nonatomic,assign) NSString *quote;
@property (nonatomic,assign) NSString *credit;
@property (nonatomic,assign) NSString *additionalInfo;
@property (nonatomic,assign) CGSize maxSize;

@end
