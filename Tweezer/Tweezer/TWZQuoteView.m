//
//  TWZQuoteView.m
//  Tweezer
//
//  Created by Bryan Hansen on 10/19/11.
//  Copyright (c) 2011 Übermind, Inc. All rights reserved.
//

#import "TWZQuoteView.h"
#import "TWZConstants.h"

#define TWZQuoteViewQuoteSpacing 8.0f
#define TWZQuoteViewCreditSpacing 0.0f

@implementation TWZQuoteView

@dynamic quote;
@dynamic credit;
@dynamic additionalInfo;
@synthesize maxSize;

+ (CGFloat)quoteFontSize
{
    CGRect screenRect;
    NSArray *screens = [UIScreen screens];
    if (screens.count > 1)
    {
        screenRect = ((UIScreen *)[screens objectAtIndex:1]).bounds;
    }
    else
    {
        screenRect = [UIScreen mainScreen].bounds;
    }
    
    CGFloat minDimension = MIN(screenRect.size.width, screenRect.size.width);
    
    NSUInteger setting = [[[NSUserDefaults standardUserDefaults] objectForKey:TWZUserDefaultFontSize] intValue];
    switch (setting) {
        case TWZQuoteViewFontSizeLarge:
            if (minDimension >= 720.0f) return 60.0f;
            else if (minDimension >= 480.0f) return 46.0f;
            else return 35.0f;
            
        case TWZQuoteViewFontSizeSmall:
            if (minDimension >= 720.0f) return 35.0f;
            else if (minDimension >= 480.0f) return 29.0f;
            else return 24.0f;
        case TWZQuoteViewFontSizeMedium:
        default:
            if (minDimension >= 720.0f) return 46.0f;
            else if (minDimension >= 480.0f) return 35.0f;
            else return 29.0f;
    }
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _quoteTextView = [[TWZTextAnimationView alloc] initWithFrame:CGRectZero];
        _quoteTextView.font = [UIFont systemFontOfSize:[TWZQuoteView quoteFontSize]];
        _quoteTextView.textColor = [UIColor whiteColor];
        _quoteTextView.backgroundColor = [UIColor clearColor];

        _creditTextView = [[TWZTextAnimationView alloc] initWithFrame:CGRectZero];
        _creditTextView.font = [UIFont systemFontOfSize:floorf([TWZQuoteView quoteFontSize] * 0.666)];
        _creditTextView.textColor = [UIColor lightGrayColor];
        _creditTextView.backgroundColor = [UIColor clearColor];
        
        _addInfoTextView = [[TWZTextAnimationView alloc] initWithFrame:CGRectZero];
        _addInfoTextView.font = [UIFont systemFontOfSize:floorf([TWZQuoteView quoteFontSize] * 0.666)];
        _addInfoTextView.textColor = [UIColor lightGrayColor];
        _addInfoTextView.backgroundColor = [UIColor clearColor];
        
        [self addSubview:_addInfoTextView];
        [self addSubview:_creditTextView];
        [self addSubview:_quoteTextView];
    }
    return self;
}

- (void)layoutSubviews
{
    CGRect quoteRect, spacerRect, creditRect, addInfoRect;
    quoteRect = self.bounds;
    if ([self.additionalInfo length]) CGRectDivide(quoteRect, &addInfoRect, &quoteRect, _addInfoTextView.font.lineHeight + 1 + TWZQuoteViewCreditSpacing, CGRectMaxYEdge);
    addInfoRect.origin.y += TWZQuoteViewCreditSpacing;
    addInfoRect.size.height -= TWZQuoteViewCreditSpacing;
    
    if ([self.credit length]) CGRectDivide(quoteRect, &creditRect, &quoteRect, _creditTextView.font.lineHeight + 1 + TWZQuoteViewCreditSpacing, CGRectMaxYEdge);
    creditRect.origin.y += TWZQuoteViewCreditSpacing;
    creditRect.size.height -= TWZQuoteViewCreditSpacing;
    
    if ([self.additionalInfo length] || [self.credit length]) CGRectDivide(quoteRect, &spacerRect, &quoteRect, TWZQuoteViewQuoteSpacing, CGRectMaxYEdge);
    
    _quoteTextView.frame = quoteRect;
    _creditTextView.frame = creditRect;
    _addInfoTextView.frame = addInfoRect;
}

- (CGSize)sizeThatFits:(CGSize)size
{
    [_creditTextView sizeToFit];
    // the font line height returns 1 higher then the framesetter says it needs height, don't know why
    CGFloat heightNeeded = _creditTextView.bounds.size.height + 2;
    [_addInfoTextView sizeToFit];
    // the font line height returns 1 higher then the framesetter says it needs height, don't know why
    heightNeeded += _addInfoTextView.bounds.size.height + 2;
    if ([self.credit length]) heightNeeded += TWZQuoteViewCreditSpacing;
    if ([self.additionalInfo length]) heightNeeded += TWZQuoteViewCreditSpacing;
    if ([self.credit length] || [self.additionalInfo length]) heightNeeded += TWZQuoteViewQuoteSpacing;

    // need to set size of quote view before sizing to fit
    CGRect r = CGRectZero;
    r.size = size;
    r.size.height -= heightNeeded;
    _quoteTextView.frame = r;
    [_quoteTextView sizeToFit];
    heightNeeded += _quoteTextView.bounds.size.height;

    return CGSizeMake(_quoteTextView.frame.size.width, heightNeeded);
}

- (void)setHidden:(BOOL)hidden animated:(BOOL)animated
{    
    if (animated) {
        if (hidden)
        {
            [_quoteTextView setHidden:hidden animation:TWZTextAnimationFadeOut completion:NULL];
            [_creditTextView setHidden:hidden animation:TWZTextAnimationFadeOut completion:NULL];
            [_addInfoTextView setHidden:hidden animation:TWZTextAnimationFadeOut completion:NULL];
        }
        else
        {
            [super setHidden:hidden];
            [_quoteTextView setHidden:hidden animation:TWZTextAnimationDropRotateIn completion:
             ^{
                 [_creditTextView setHidden:hidden animation:TWZTextAnimationFadeIn completion:NULL];
                 [_addInfoTextView setHidden:hidden animation:TWZTextAnimationFadeIn completion:NULL];
            }];
        }
    }
    else
    {
        _creditTextView.hidden = hidden;
        _addInfoTextView.hidden = hidden;
    }
}

- (void)setHidden:(BOOL)hidden
{
    [self setHidden:hidden animated:NO];
}

- (NSString *)quote
{
    return _quoteTextView.text;
}

- (void)setQuote:(NSString *)quote
{
    _quoteTextView.text = quote;
}

- (NSString *)credit
{
    return _creditTextView.text;
}

- (void)setCredit:(NSString *)credit
{
    _creditTextView.text = credit;
}

- (NSString *)additionalInfo
{
    return _addInfoTextView.text;
}

- (void)setAdditionalInfo:(NSString *)additionalInfo
{
    _addInfoTextView.text = additionalInfo;
}

@end
