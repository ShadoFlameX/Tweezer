//
//  TWZTextAnimationView.h
//  Tweezer
//
//  Created by Bryan Hansen on 10/13/11.
//  Copyright (c) 2011 Übermind, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreText/CoreText.h>

typedef enum
{
    TWZTextAnimationNone,
    TWZTextAnimationDropRotateIn,
    TWZTextAnimationFadeIn,
    TWZTextAnimationFadeOut
} TWZTextAnimation;

@interface TWZTextAnimationView : UIView
{
    NSString *_text;
    CTFrameRef _frame;
    void (^_completion)(void);
}

- (id)initWithString:(NSString *)string;

- (void)setHidden:(BOOL)hidden animation:(TWZTextAnimation)style completion:(void (^)(void))completion;

@property (nonatomic,retain) NSString *text;
@property (nonatomic,retain) UIColor *textColor;
@property (nonatomic,retain) UIColor *textShadowColor;
@property (nonatomic,retain) UIFont *font;
@property (nonatomic,copy) void (^completion)(void);

@end
