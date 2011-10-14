//
//  TWZGlyphLayer.m
//  Tweezer
//
//  Created by Bryan Hansen on 10/13/11.
//  Copyright (c) 2011 Übermind, Inc. All rights reserved.
//

#import "TWZGlyphLayer.h"

@implementation TWZGlyphLayer

@synthesize glyph = _glyph;
@synthesize font = _font;
@synthesize baseline;

- (id)initWithGlyph:(CGGlyph)glyph {
    self = [super init];
    if (self) {
        self.contentsScale = [UIScreen mainScreen].scale;
        self.glyph = glyph;
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
    CGContextSetFontSize(ctx, 32.0f);
    
    CGGlyph glyphs[1] = {self.glyph};
    CGContextShowGlyphsAtPoint(ctx, 0.0f, self.baseline, glyphs, 1);
}

@end
