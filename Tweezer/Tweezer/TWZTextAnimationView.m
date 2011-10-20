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
- (CAAnimation *)animationForGlyphLayer:(TWZGlyphLayer *)layer style:(TWZTextAnimation)style delay:(CGFloat)delay;
@end

@implementation TWZTextAnimationView

@synthesize text = _text;
@synthesize textColor;
@synthesize font;
@synthesize completion = _completion;

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
    self.textColor = [UIColor blackColor];
    self.font = [UIFont systemFontOfSize:32.0f];

}

- (void)layoutSubviews
{
//    for (CALayer *lyr in self.layer.sublayers)
//    {
//        if ([lyr isKindOfClass:[TWZGlyphLayer class]])
//        {
//            [lyr removeFromSuperlayer];
//        }
//    }
    
    if (![self.text length])
    {
        return;
    }
    
    
    CTFontRef ctFont = CTFontCreateWithName((CFStringRef)self.font.fontName, self.font.pointSize, NULL);
    
	// pack it into attributes dictionary
	NSDictionary *attributesDict = [NSDictionary dictionaryWithObjectsAndKeys:
                                    (id)ctFont, (id)kCTFontAttributeName,
                                    self.textColor.CGColor, (id)kCTForegroundColorAttributeName,
                                    nil];
    
	// make the attributed string
	NSAttributedString *stringToDraw = [[NSAttributedString alloc] initWithString:self.text attributes:attributesDict];
    
    // layout master
	CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)stringToDraw);
    [stringToDraw release];
    
	// column form
	CGMutablePathRef columnPath = CGPathCreateMutable();
	CGPathAddRect(columnPath, NULL, CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height));
    
	// column frame
	_frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, 0), columnPath, NULL);
    
    
    NSUInteger glyphIndex = 0;
    NSUInteger runIndex = 0;;
    NSArray *lines = (NSArray *)CTFrameGetLines(_frame);
    CGPoint *originPts = malloc(sizeof(CGPoint) * lines.count);    
    CTFrameGetLineOrigins(_frame, CFRangeMake(0, 0), originPts);
    int lineIndex;
    for (lineIndex=0; lineIndex<lines.count; lineIndex++)
    {
        CTLineRef aLine = (CTLineRef)[lines objectAtIndex:lineIndex];
        
        CGFloat lineAscent;
        CGFloat lineDescent;
        CGFloat lineLeading;
        CTLineGetTypographicBounds((CTLineRef)aLine, &lineAscent, &lineDescent, &lineLeading);
        
        // need to flip y-axis then move up by height above baselined
        CGFloat lineOrigin = floorf((self.frame.size.height - originPts[lineIndex].y) - lineAscent);
        
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
                    glyphLayer.fontSize = CTFontGetSize(ctFont);
                    glyphLayer.baseline = ceilf(descent) + ceilf(leading);
                    glyphLayer.color = self.textColor.CGColor;
                    glyphLayer.frame = CGRectMake(roundf(totalWidth), lineOrigin, ceilf(glyphWidth), ceilf(ascent) + ceilf(descent) + ceilf(leading));
                    
                    [self.layer addSublayer:glyphLayer];
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
                        glyphLayer.fontSize = CTFontGetSize(ctFont);
                        glyphLayer.baseline = ceilf(descent) + ceilf(leading);
                        glyphLayer.frame = CGRectMake(roundf(totalWidth), lineOrigin, ceilf(chunkWidth), ceilf(ascent) + ceilf(descent) + ceilf(leading));
                        
                        [self.layer addSublayer:glyphLayer];
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
                            glyphLayer.fontSize = CTFontGetSize(ctFont);
                            glyphLayer.baseline = ceilf(descent) + ceilf(leading);
                            glyphLayer.frame = CGRectMake(roundf(totalWidth), lineOrigin, ceilf(chunkWidth), ceilf(ascent) + ceilf(descent) + ceilf(leading));
                            
                            [self.layer addSublayer:glyphLayer];
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
//        lineHeight += ceilf(lineAscent + lineDescent + lineLeading);
        runIndex++;
    }
    
    // cleanup
	CGPathRelease(columnPath);
	CFRelease(framesetter);
	CFRelease(font);
}

//- (void)setHidden:(BOOL)hidden animation:(TWZTextAnimation)style completion:(void (^)(BOOL finished))completion
- (void)setHidden:(BOOL)hidden animation:(TWZTextAnimation)style completion:(void (^)(void))completion
{
    self.hidden = hidden;
    
    if (style != TWZTextAnimationNone)
    {
        self.completion = completion;
        [self layoutIfNeeded];
        CGFloat delay = 0.0f;
        int i;
        for (i=0; i<self.layer.sublayers.count; i++)
        {
            CALayer *lyr = [self.layer.sublayers objectAtIndex:i];
            if ([lyr isKindOfClass:[TWZGlyphLayer class]])
            {
                CAAnimation *anim = [self animationForGlyphLayer:(TWZGlyphLayer *)lyr style:style delay:delay];
                if (i == self.layer.sublayers.count - 1)
                {
                    anim.delegate = self;
                }
                [lyr addAnimation:anim forKey:@"ShowHide"];
                if (style == TWZTextAnimationDropRotate) delay += TWZTextAnimationViewDelay;
            }
        }
    }
}

- (CAAnimation *)animationForGlyphLayer:(TWZGlyphLayer *)layer style:(TWZTextAnimation)style delay:(CGFloat)delay
{
    if (style == TWZTextAnimationDropRotate)
    {
        if (self.hidden)
        {
            // hiding is not supported for TWZTextAnimationStyleDropRotate
            return [self animationForGlyphLayer:layer style:TWZTextAnimationFade delay:0];
        }
        CGFloat duration = 0.4f;
        
        CABasicAnimation *opacityAnim = [CABasicAnimation animationWithKeyPath:@"opacity"];
        opacityAnim.duration = duration;
        opacityAnim.fillMode=kCAFillModeBackwards;
        opacityAnim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
        opacityAnim.fromValue = [NSNumber numberWithFloat:0.0f];
        opacityAnim.toValue = [NSNumber numberWithFloat:1.0f];
        
        CABasicAnimation *transformAnim = [CABasicAnimation animationWithKeyPath:@"transform"];
        transformAnim.duration = duration;
        transformAnim.fillMode = kCAFillModeBackwards;
        transformAnim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        transformAnim.fromValue = [NSValue valueWithCATransform3D:CATransform3DRotate(CATransform3DTranslate(CATransform3DMakeScale(4.0f, 4.0f, 1.0f),0,-self.font.pointSize/3.0f,0), M_PI, 0, 0, 1)];
        transformAnim.toValue = [NSValue valueWithCATransform3D:layer.transform];
        transformAnim.removedOnCompletion = FALSE;
        
        CAAnimationGroup *animGroup = [CAAnimationGroup animation];
        animGroup.fillMode=kCAFillModeBackwards;
        animGroup.duration = duration;
        animGroup.beginTime = CACurrentMediaTime() + delay;
        animGroup.animations = [NSArray arrayWithObjects:opacityAnim,transformAnim, nil];
        return animGroup;
    }
    else if (style == TWZTextAnimationFade)
    {
        CGFloat duration = 1.0f;
        
        NSNumber *fromVal = (self.hidden) ? [NSNumber numberWithFloat:1.0f] : [NSNumber numberWithFloat:0.0f];
        NSNumber *toVal = (self.hidden) ? [NSNumber numberWithFloat:0.0f] : [NSNumber numberWithFloat:1.0f];
        
        CABasicAnimation *opacityAnim = [CABasicAnimation animationWithKeyPath:@"opacity"];
        opacityAnim.duration = duration;
        opacityAnim.fillMode=kCAFillModeBackwards;
        opacityAnim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
        opacityAnim.fromValue = fromVal;
        opacityAnim.toValue = toVal;
        
        CAAnimationGroup *animGroup = [CAAnimationGroup animation];
        animGroup.fillMode=kCAFillModeBackwards;
        animGroup.duration = duration;
        animGroup.beginTime = CACurrentMediaTime() + delay;
        animGroup.animations = [NSArray arrayWithObjects:opacityAnim, nil];
        return animGroup;
    }
    else if (style == TWZTextAnimationDropRotate)
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
        transformAnim.fromValue = [NSValue valueWithCATransform3D:CATransform3DRotate(CATransform3DTranslate(CATransform3DMakeScale(4.0f, 4.0f, 1.0f),0,-self.font.pointSize/3.0f,0), M_PI, 0, 0, 1)];
        //    transformAnim.fromValue = [NSValue valueWithCATransform3D:CATransform3DMakeTranslation(40.0f,1.0f,1.0f)];
        transformAnim.toValue = [NSValue valueWithCATransform3D:layer.transform];
        transformAnim.removedOnCompletion = FALSE;
        //    [layer addAnimation:transformAnim forKey:@"transform"];
        
        CAAnimationGroup *animGroup = [CAAnimationGroup animation];
        animGroup.fillMode=kCAFillModeBackwards;
        animGroup.duration = duration;
        animGroup.beginTime = CACurrentMediaTime() + delay;
        animGroup.animations = [NSArray arrayWithObjects:opacityAnim,transformAnim, nil];
        return animGroup;
    }
    return nil;
}

//- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
//    NSUInteger layerIdx = 0;
//    for (CALayer *layer in [self.layer sublayers ])
//    {
//        if ([layer isKindOfClass:[TWZGlyphLayer class]])
//        {
//            [self animateGlyphLayer:(TWZGlyphLayer*)layer withDelay:layerIdx * TWZTextAnimationViewDelay];
//            layerIdx++;
//        }
//    }
//}

//- (void)drawRect:(CGRect)rect
//{
//    [super drawRect:rect];
//    // flip the coordinate system
//	CGContextRef context = UIGraphicsGetCurrentContext();
//	CGContextSetTextMatrix(context, CGAffineTransformIdentity);
//	CGContextTranslateCTM(context, 0, self.bounds.size.height);
//	CGContextScaleCTM(context, 1.0, -1.0);
//	// draw
//	CTFrameDraw(_frame, context);    
//}

- (CGSize)sizeThatFits:(CGSize)size
{
    if (![self.text length])
    {
        return CGSizeZero;
    }
    
    CTFontRef ctFont = CTFontCreateWithName((CFStringRef)self.font.fontName, self.font.pointSize, NULL);
    
	// pack it into attributes dictionary
	NSDictionary *attributesDict = [NSDictionary dictionaryWithObjectsAndKeys:
                                    (id)ctFont, (id)kCTFontAttributeName,
                                    self.textColor.CGColor, (id)kCTForegroundColorAttributeName,
                                    nil];
    
    NSAttributedString *stringToDraw = [[NSAttributedString alloc] initWithString:self.text attributes:attributesDict];
	CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)stringToDraw);
    [stringToDraw release];
    
    CFRange fitRange;
    CGSize fitSize = CTFramesetterSuggestFrameSizeWithConstraints(framesetter, CFRangeMake(0, 0), NULL, CGSizeMake(size.width, CGFLOAT_MAX), &fitRange);
    
    fitSize.width = ceilf(fitSize.width);
    fitSize.height = ceilf(fitSize.height);
    
    return fitSize;
}

- (void)animationDidStop:(CAAnimation *)theAnimation finished:(BOOL)flag
{
    if (self.completion)
    {
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, NSEC_PER_SEC),dispatch_get_current_queue(), self.completion);
        dispatch_async(dispatch_get_current_queue(), self.completion);
        self.completion = NULL;
    }
}

@end
