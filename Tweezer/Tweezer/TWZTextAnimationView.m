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

#define TWZTextAnimationViewDelay 0.03f

@interface TWZTextAnimationView ()
- (void)setup;
- (void)animateGlyphLayer:(TWZGlyphLayer *)layer withDelay:(CGFloat)time;
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
    CTFontRef font = CTFontCreateWithName((CFStringRef)@"Times New Roman", 24.0f, NULL);
    
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
    
    NSUInteger glyphIndex = 0;
    NSUInteger runIndex = 0;;
    CGFloat lineHeight = 0.0f;
    for (id aLine in (NSArray *)CTFrameGetLines(_frame))
    {
        CFArrayRef runs = CTLineGetGlyphRuns((CTLineRef)aLine);
        for (id aRun in (NSArray *)runs)
        {
            CFDictionaryRef attributes = CTRunGetAttributes((CTRunRef)aRun);
            CTFontRef runFont = CFDictionaryGetValue(attributes, kCTFontAttributeName);
            
            CFIndex glyphCount = CTRunGetGlyphCount((CTRunRef)aRun);
            CGGlyph allGlyphs[glyphCount];
            CTRunGetGlyphs((CTRunRef)aRun, CFRangeMake(0, 0), allGlyphs);
            
            BOOL word = NO;
            NSUInteger glyphStart = 0;
            NSUInteger glyphEnd = 0;
            CGFloat ascent;
            CGFloat descent;
            CGFloat leading;
            double totalWidth = 0.0f;
            CFIndex i;
            for (i=0;i<glyphCount;i++)
            {
                CFIndex charIndex;
                CTRunGetStringIndices((CTRunRef)aRun, CFRangeMake(i, 1), &charIndex);
                
                if (YES)
                {
                    double glyphWidth = CTRunGetTypographicBounds((CTRunRef)aRun, CFRangeMake(i, 1), &ascent, &descent, &leading);
                    
                    CGGlyph g[1];
                    g[0] = allGlyphs[i];
                    TWZGlyphLayer *glyphLayer = [[TWZGlyphLayer alloc] initWithGlyphs:g count:1];
                    glyphLayer.font = CTFontCopyGraphicsFont(runFont, NULL);
                    glyphLayer.fontSize = CTFontGetSize(font);
                    glyphLayer.baseline = descent + leading;
                    glyphLayer.frame = CGRectMake(roundf(totalWidth), lineHeight, ceilf(glyphWidth), ceilf(ascent + descent + leading));
                    
                    [self.layer addSublayer:glyphLayer];
                    [self animateGlyphLayer:glyphLayer withDelay:glyphIndex*TWZTextAnimationViewDelay];
                    [glyphLayer setNeedsDisplay];
                    [glyphLayer release];
                    
                    totalWidth += glyphWidth;
                    glyphIndex++;
                }
                else
                {
                    unichar c = [self.text characterAtIndex:charIndex];
                    NSString *charStr = [NSString stringWithCharacters:&c length:1];
                    NSUInteger loc = [charStr rangeOfCharacterFromSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].location;
                    if (word && (loc != NSNotFound || i == glyphCount - 1))
                    {
                        // we just ended a word
                        //  1. get the glyphs for this chunk
                        //  2. get the width of this chunk
                        //  3. create a glyphlayer for it
                        
                        glyphEnd = i;
                        if (i == glyphCount - 1) glyphEnd++;
                        
                        NSUInteger chunkCount = glyphEnd - glyphStart;
                        CGGlyph glyphChunk[chunkCount];
                        int j;
                        for (j=0; j<chunkCount; j++)
                        {
                            glyphChunk[j] = allGlyphs[glyphStart + j];
                        }
                        
                        double chunkWidth = CTRunGetTypographicBounds((CTRunRef)aRun, CFRangeMake(glyphStart, chunkCount), &ascent, &descent, &leading);
                        
                        TWZGlyphLayer *glyphLayer = [[TWZGlyphLayer alloc] initWithGlyphs:glyphChunk count:chunkCount];
                        glyphLayer.font = CTFontCopyGraphicsFont(runFont, NULL);
                        glyphLayer.fontSize = CTFontGetSize(font);
                        glyphLayer.baseline = descent + leading;
                        glyphLayer.frame = CGRectMake(roundf(totalWidth), lineHeight, ceilf(chunkWidth), ceilf(ascent + descent + leading));
                        
                        [self.layer addSublayer:glyphLayer];
                        [self animateGlyphLayer:glyphLayer withDelay:glyphIndex*TWZTextAnimationViewDelay];
                        [glyphLayer setNeedsDisplay];
                        [glyphLayer release];
                        glyphIndex++;
                        
                        glyphStart = i;
                        word = NO;
                        totalWidth += chunkWidth;
                    }
                    else if (!word && loc == NSNotFound)
                    {
                        // we just started a word
                        //  1. if we had any whitespace, create it
                        //  2. set some vars
                        
                        if (glyphStart < i) {
                            glyphEnd = i;
                            if (i == glyphCount - 1) glyphEnd++;
                            
                            NSUInteger chunkCount = glyphEnd - glyphStart;
                            CGGlyph glyphChunk[chunkCount];
                            int j;
                            for (j=0; j<chunkCount; j++)
                            {
                                glyphChunk[j] = allGlyphs[glyphStart + j];
                            }
                            
                            double chunkWidth = CTRunGetTypographicBounds((CTRunRef)aRun, CFRangeMake(glyphStart, chunkCount), &ascent, &descent, &leading);
                            
                            TWZGlyphLayer *glyphLayer = [[TWZGlyphLayer alloc] initWithGlyphs:glyphChunk count:chunkCount];
                            glyphLayer.font = CTFontCopyGraphicsFont(runFont, NULL);
                            glyphLayer.fontSize = CTFontGetSize(font);
                            glyphLayer.baseline = descent + leading;
                            glyphLayer.frame = CGRectMake(roundf(totalWidth), lineHeight, ceilf(chunkWidth), ceilf(ascent + descent + leading));
                            
                            [self.layer addSublayer:glyphLayer];
                            [self animateGlyphLayer:glyphLayer withDelay:glyphIndex*TWZTextAnimationViewDelay];
                            [glyphLayer setNeedsDisplay];
                            [glyphLayer release];
                            glyphIndex++;
                            
                            glyphStart = i;
                            word = NO;
                            totalWidth += chunkWidth;
                        }
                        
                        word = YES;
                        glyphStart = i;
                    }
                }                
            }
        }
        lineHeight += CTFontGetAscent(font) + CTFontGetDescent(font) + CTFontGetLeading(font);
        runIndex++;
    }
    
    // cleanup
	CGPathRelease(columnPath);
	CFRelease(framesetter);
	CFRelease(font);
}

- (void)animateGlyphLayer:(TWZGlyphLayer *)layer withDelay:(CGFloat)time
{
    //                CGPoint startPos = glyphLayer.position;
    //                int upOrDown = (i%2 == 0) ? -1 : 1;
    //                startPos.y += 100.0f * upOrDown;
    
    CGFloat duration = 0.4f;
    
    CABasicAnimation *opacityAnim = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opacityAnim.duration = duration;
//    opacityAnim.beginTime = CACurrentMediaTime() + time;
    opacityAnim.fillMode=kCAFillModeBackwards;
    opacityAnim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    opacityAnim.fromValue = [NSNumber numberWithFloat:0.0f];
    opacityAnim.toValue = [NSNumber numberWithFloat:1.0f];
//    [layer addAnimation:opacityAnim forKey:@"opacity"];
    
    CABasicAnimation *transformAnim = [CABasicAnimation animationWithKeyPath:@"transform"];
    transformAnim.duration = duration;
//    transformAnim.beginTime = CACurrentMediaTime() + time;
    transformAnim.fillMode = kCAFillModeBackwards;
    transformAnim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transformAnim.fromValue = [NSValue valueWithCATransform3D:CATransform3DTranslate(CATransform3DMakeScale(4.0f, 4.0f, 1.0f),0,-2,0)];
//    transformAnim.fromValue = [NSValue valueWithCATransform3D:CATransform3DMakeTranslation(40.0f,1.0f,1.0f)];
    transformAnim.toValue = [NSValue valueWithCATransform3D:layer.transform];
    transformAnim.removedOnCompletion = FALSE;
//    [layer addAnimation:transformAnim forKey:@"transform"];

    CAAnimationGroup *animGroup = [CAAnimationGroup animation];
    animGroup.fillMode=kCAFillModeBackwards;
    animGroup.duration = duration;
    animGroup.beginTime = CACurrentMediaTime() + time;
    animGroup.animations = [NSArray arrayWithObjects:opacityAnim,transformAnim, nil];
    [layer addAnimation:animGroup forKey:@"show"];
}

//- (void)setText:(NSString *)string
//{
//    [string retain];
//    [_text release];
//    _text = string;
//}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    NSUInteger layerIdx = 0;
    for (CALayer *layer in [self.layer sublayers ])
    {
        if ([layer isKindOfClass:[TWZGlyphLayer class]])
        {
            [self animateGlyphLayer:(TWZGlyphLayer*)layer withDelay:layerIdx * TWZTextAnimationViewDelay];
            layerIdx++;
        }
    }
}

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
