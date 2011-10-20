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
    CGGlyph *_glyphs;
    size_t _count;
    CGFontRef _font;
    CGFloat _fontSize;
}

- (id)initWithGlyphs:(CGGlyph *)glyphs count:(size_t)count;

@property(nonatomic,assign) CGFontRef font;
@property(nonatomic,assign) CGFloat fontSize;
@property(nonatomic,assign) CGFloat baseline;
@property(nonatomic,assign) CGColorRef color;

@end
