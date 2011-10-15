//
//  TWZGlyphLayer.m
//  Tweezer
//
//  Created by Bryan Hansen on 10/13/11.
//  Copyright (c) 2011 Übermind, Inc. All rights reserved.
//

#import "TWZGlyphLayer.h"

@implementation TWZGlyphLayer

@synthesize font = _font;
@synthesize fontSize = _fontSize;
@synthesize baseline;

- (id)initWithGlyphs:(CGGlyph *)glyphs count:(size_t)count
{
    self = [super init];
    if (self) {
        self.contentsScale = [UIScreen mainScreen].scale;
        
        _count = count;
        _glyphs = malloc(sizeof(CGGlyph) * _count);
        
        int i;
        for (i=0;i<_count;i++)
        {
            _glyphs[i] = glyphs[i];
        }        
        self.baseline = 0.0f;
    }
    return self;
}

- (void)drawInContext:(CGContextRef)ctx
{        
    // flip the coordinate system
	CGContextSetTextMatrix(ctx, CGAffineTransformIdentity);
	CGContextTranslateCTM(ctx, 0, self.bounds.size.height);
	CGContextScaleCTM(ctx, 1.0, -1.0);
    
    CGContextSetFillColorWithColor(ctx, [UIColor whiteColor].CGColor);
    CGContextSetFont(ctx, _font);
    CGContextSetFontSize(ctx, self.fontSize);
    
    CGContextShowGlyphsAtPoint(ctx, 0.0f, self.baseline, _glyphs, _count);
}

@end
