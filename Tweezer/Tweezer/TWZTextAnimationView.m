//
//  TWZTextAnimationView.m
//  Tweezer
//
//  Created by Bryan Hansen on 10/13/11.
//  Copyright (c) 2011 Übermind, Inc. All rights reserved.
//

#import "TWZTextAnimationView.h"
#import <QuartzCore/QuartzCore.h>
#import "TWZGlyphLayer.h"

@interface TWZTextAnimationView ()
- (void)setup;

void GetGlyphsForCharacters(CTFontRef iFont, CFStringRef iString);

@end

@implementation TWZTextAnimationView

@synthesize text = _text;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (id)initWithString:(NSString *)string
{
    self = [super initWithFrame:CGRectZero];
    if (self) {
        [self setup];
        self.text = string;
    }
    return self;
}

- (void)dealloc
{
    CFRelease(_frame);
}

- (void)setup
{
    self.backgroundColor = [UIColor whiteColor];
}

- (void)layoutSubviews
{
    // create a font, quasi systemFontWithSize:24.0
    //	CTFontRef sysUIFont = CTFontCreateUIFontForLanguage(kCTFontEmphasizedSystemFontType, 21.0, NULL);
    CTFontRef font = CTFontCreateWithName((CFStringRef)@"Times New Roman", 32.0f, NULL);
    
	// blue
	CGColorRef color = [UIColor whiteColor].CGColor;
    
	// pack it into attributes dictionary
	NSDictionary *attributesDict = [NSDictionary dictionaryWithObjectsAndKeys:
                                    (id)font, (id)kCTFontAttributeName,
                                    color, (id)kCTForegroundColorAttributeName,
                                    nil];
    
	// make the attributed string
	NSAttributedString *stringToDraw = [[NSAttributedString alloc] initWithString:self.text attributes:attributesDict];
    
    // layout master
	CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)stringToDraw);
    
	// column form
	CGMutablePathRef columnPath = CGPathCreateMutable();
	CGPathAddRect(columnPath, NULL, CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height));
    
	// column frame
	_frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, 0), columnPath, NULL);
    
    NSUInteger characterIndex = 0;;
    CGFloat lineHeight = 0.0f;
    for (id aLine in (NSArray *)CTFrameGetLines(_frame))
    {
        CFArrayRef runs = CTLineGetGlyphRuns((CTLineRef)aLine);
        for (id aRun in (NSArray *)runs)
        {
            CFIndex glyphCount = CTRunGetGlyphCount((CTRunRef)aRun);
            CGGlyph glyphs[glyphCount];
            CTRunGetGlyphs((CTRunRef)aRun, CFRangeMake(0, 0), glyphs);

            double totalWidth = 0.0f;
            CFIndex i;
            for (i=0;i<glyphCount;i++)
            {
                CGFloat ascent;
                CGFloat descent;
                CGFloat leading;
                double glyphWidth = CTRunGetTypographicBounds((CTRunRef)aRun, CFRangeMake(i, 1), &ascent, &descent, &leading);
                                
                CFDictionaryRef attributes = CTRunGetAttributes((CTRunRef)aRun);
                CTFontRef runFont = CFDictionaryGetValue(attributes, kCTFontAttributeName);
                                
                TWZGlyphLayer *glyphLayer = [[TWZGlyphLayer alloc] initWithGlyph:glyphs[i]];
                glyphLayer.font = CTFontCopyGraphicsFont(runFont, NULL);
                glyphLayer.baseline = descent + leading;
                glyphLayer.frame = CGRectMake(roundf(totalWidth), lineHeight, ceilf(glyphWidth), ceilf(ascent + descent + leading));
                
//                CGPoint startPos = glyphLayer.position;
//                int upOrDown = (i%2 == 0) ? -1 : 1;
//                startPos.y += 100.0f * upOrDown;
                
                
                CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"opacity"];
                anim.duration = 1.0f;
                anim.beginTime = CACurrentMediaTime() + characterIndex*0.02f;
                anim.fillMode=kCAFillModeBackwards;
                anim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
                anim.fromValue = [NSNumber numberWithFloat:0.0f];
                anim.toValue = [NSNumber numberWithFloat:1.0f];
                [glyphLayer addAnimation:anim forKey:@"opacity"];
                
                [self.layer addSublayer:glyphLayer];
                [glyphLayer setNeedsDisplay];
                [glyphLayer release];
                
                characterIndex++;
                totalWidth += glyphWidth;
            }
        }
        lineHeight += CTFontGetAscent(font) + CTFontGetDescent(font) + CTFontGetLeading(font);
    }
    
    // cleanup
	CGPathRelease(columnPath);
	CFRelease(framesetter);
	CFRelease(font);
}

//- (void)setText:(NSString *)string
//{
//    [string retain];
//    [_text release];
//    _text = string;
//}

- (void)drawRect:(CGRect)rect
{
    // flip the coordinate system
//	CGContextRef context = UIGraphicsGetCurrentContext();
//	CGContextSetTextMatrix(context, CGAffineTransformIdentity);
//	CGContextTranslateCTM(context, 0, self.bounds.size.height);
//	CGContextScaleCTM(context, 1.0, -1.0);
//	// draw
//	CTFrameDraw(_frame, context);    
}

- (void)sizeToFit {
    self.bounds = CGRectMake(0.0f, 0.0f, 300.0f, 440.0f);
}

@end
