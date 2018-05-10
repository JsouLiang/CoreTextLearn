//
//  CTAttributeFactory.m
//  CoreTextLearn
//
//  Created by Liang on 2018/5/10.
//  Copyright © 2018年 Liang. All rights reserved.
//

#import "CTAttributeFactory.h"
#import "CTFrameParserConfig.h"
#import <CoreText/CoreText.h>

@implementation CTAttributeFactory

+ (NSDictionary *)attributesWithConfigure:(CTFrameParserConfig *)config {
	CGFloat fontSize = config.fontSize;
	CTFontRef fontRef = CTFontCreateWithName((CFStringRef)@"ArialMT", fontSize, NULL);
	
	CGFloat lineSpace = config.lineSpace;
	const CFIndex kNumberOfSettings = 3;
	CTParagraphStyleSetting paragraphSettings[] =  {
		{kCTParagraphStyleSpecifierLineSpacingAdjustment, sizeof(CGFloat), &lineSpace},
		{kCTParagraphStyleSpecifierMaximumLineSpacing, sizeof(CGFloat), &lineSpace},
		{kCTParagraphStyleSpecifierMinimumLineSpacing, sizeof(CGFloat), &lineSpace}
	};
	CTParagraphStyleRef paragraphRef = CTParagraphStyleCreate(paragraphSettings, kNumberOfSettings);
	
	UIColor *textColor = config.textColor;
	NSDictionary *dic = @{
						  (id)kCTForegroundColorAttributeName: (__bridge id)textColor.CGColor,
						  (id)kCTFontAttributeName: (__bridge id)fontRef,
						  (id)kCTParagraphStyleAttributeName: (__bridge id)paragraphRef
						  };
	CFRelease(paragraphRef);
	CFRelease(fontRef);
	return dic;
}

@end
