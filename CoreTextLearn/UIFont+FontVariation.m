//
//  UIFont+FontVariation.m
//  CoreTextLearn
//
//  Created by Liang on 2018/5/12.
//  Copyright © 2018年 Liang. All rights reserved.
//

#import "UIFont+FontVariation.h"

@implementation UIFont (FontVariation)

UIFont *GetVariationOfFontWithTrait(UIFont *baseFont, CTFontSymbolicTraits traits) {
	CGFloat fontSize = [baseFont pointSize];
	CFStringRef baseFontName = (__bridge CFStringRef)[baseFont fontName];
	CTFontRef baseCTFont = CTFontCreateWithName(baseFontName, fontSize, NULL);
	CTFontRef ctFont = CTFontCreateCopyWithSymbolicTraits(baseCTFont, 0, NULL, traits, traits);
	NSString *variationFontName = CFBridgingRelease(CTFontCopyName(ctFont, kCTFontPostScriptNameKey));
	UIFont *variationFont = [UIFont fontWithName:variationFontName size:fontSize];
	
	CFRelease(ctFont);
	CFRelease(baseCTFont);
	return variationFont;
}

@end
