//
//  TWZQuoteView.m
//  Tweezer
//
//  Created by Bryan Hansen on 10/19/11.
//  Copyright (c) 2011 Übermind, Inc. All rights reserved.
//

#import "TWZQuoteView.h"

#define TWZQuoteViewQuoteSpacing 8.0f
#define TWZQuoteViewCreditSpacing 0.0f

@implementation TWZQuoteView

@dynamic quote;
@dynamic credit;
@dynamic additionalInfo;
@synthesize maxSize;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _quoteTextView = [[TWZTextAnimationView alloc] initWithFrame:CGRectZero];
        _quoteTextView.font = [UIFont systemFontOfSize:30.0f];
        _quoteTextView.textColor = [UIColor whiteColor];
        _quoteTextView.backgroundColor = [UIColor clearColor];

        _creditTextView = [[TWZTextAnimationView alloc] initWithFrame:CGRectZero];
        _creditTextView.font = [UIFont systemFontOfSize:24.0f];
        _creditTextView.textColor = [UIColor lightGrayColor];
        _creditTextView.backgroundColor = [UIColor clearColor];
        
        _addInfoTextView = [[TWZTextAnimationView alloc] initWithFrame:CGRectZero];
        _addInfoTextView.font = [UIFont systemFontOfSize:24.0f];
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
    if ([self.additionalInfo length]) CGRectDivide(quoteRect, &addInfoRect, &quoteRect, _addInfoTextView.font.lineHeight + TWZQuoteViewCreditSpacing, CGRectMaxYEdge);
    addInfoRect.origin.y += TWZQuoteViewCreditSpacing;
    addInfoRect.size.height -= TWZQuoteViewCreditSpacing;
    
    if ([self.credit length]) CGRectDivide(quoteRect, &creditRect, &quoteRect, _addInfoTextView.font.lineHeight + TWZQuoteViewCreditSpacing, CGRectMaxYEdge);
    creditRect.origin.y += TWZQuoteViewCreditSpacing;
    creditRect.size.height -= TWZQuoteViewCreditSpacing;
    
    if ([self.additionalInfo length] || [self.credit length]) CGRectDivide(quoteRect, &spacerRect, &quoteRect, TWZQuoteViewQuoteSpacing, CGRectMaxYEdge);
    
    _quoteTextView.frame = quoteRect;
    _creditTextView.frame = creditRect;
    _addInfoTextView.frame = addInfoRect;
}

- (CGSize)sizeThatFits:(CGSize)size
{
    CGRect r = CGRectZero;
    r.size = size;
    // need to set size of quote view before sizing to fit
    _quoteTextView.frame = r;
    [_quoteTextView sizeToFit];
    [_creditTextView sizeToFit];
    [_addInfoTextView sizeToFit];
    CGFloat heightNeeded = _quoteTextView.bounds.size.height + _creditTextView.bounds.size.height + _addInfoTextView.bounds.size.height;
    if ([self.credit length]) heightNeeded += TWZQuoteViewCreditSpacing;
    if ([self.additionalInfo length]) heightNeeded += TWZQuoteViewCreditSpacing;
    if ([self.credit length] || [self.additionalInfo length]) heightNeeded += TWZQuoteViewQuoteSpacing;

    return CGSizeMake(_quoteTextView.frame.size.width, heightNeeded);
}

- (void)setHidden:(BOOL)hidden animated:(BOOL)animated
{
    [super setHidden:hidden];
    
    if (animated) {
        [_quoteTextView setHidden:hidden animation:TWZTextAnimationDropRotate completion:
         ^{
             [_creditTextView setHidden:hidden animation:TWZTextAnimationFade completion:NULL];
             [_addInfoTextView setHidden:hidden animation:TWZTextAnimationFade completion:NULL];
        }];
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
