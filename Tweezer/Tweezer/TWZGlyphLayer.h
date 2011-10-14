//
//  TWZGlyphLayer.h
//  Tweezer
//
//  Created by Bryan Hansen on 10/13/11.
//  Copyright (c) 2011 Übermind, Inc. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

@interface TWZGlyphLayer : CALayer
{
    CGGlyph _glyph;
    CGFontRef _font;
}

- (id)initWithGlyph:(CGGlyph)glyph;

@property(nonatomic,assign) CGGlyph glyph;
@property(nonatomic,assign) CGFontRef font;
@property(nonatomic,assign) CGFloat baseline;

@end
