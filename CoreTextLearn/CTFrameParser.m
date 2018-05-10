//
//  CTFrameParser.m
//  CoreTextLearn
//
//  Created by Liang on 2018/5/10.
//  Copyright © 2018年 Liang. All rights reserved.
//

#import "CTFrameParser.h"
#import "CoreTextData.h"
#import "CTFrameParserConfig.h"

@implementation CTFrameParser

+ (CoreTextData *)pareContent:(NSString *)content config:(CTFrameParserConfig *)config {
	NSDictionary *attributes = [self attributesWithConfigure:config];
	NSAttributedString *contentString = [[NSAttributedString alloc] initWithString:content attributes:attributes];
	//
	CTFramesetterRef frameSetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)contentString);
	// 计算绘制Sting所需要的区域
	CGSize restrictSize = CGSizeMake(config.width, CGFLOAT_MAX);
	CGSize coreTextSize = CTFramesetterSuggestFrameSizeWithConstraints(frameSetter, CFRangeMake(0, 0), NULL, restrictSize, NULL);
	CGFloat textHeight = coreTextSize.height;
	// 创建frame
	CTFrameRef frame = [self createFrameWithFrameSetter:frameSetter config:config height:textHeight];
	
	// 将生成好的CTFrame实例和计算好的绘制高度保存到CoreTextData中
	CoreTextData *coreTextData = [[CoreTextData alloc] init];
	coreTextData.ctFrame = frame;
	coreTextData.height = textHeight;
	// 释放内存
	CFRelease(frame);
	CFRelease(frameSetter);
	
	return coreTextData;
}

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

+ (CTFrameRef)createFrameWithFrameSetter:(CTFramesetterRef)frameSetter
								  config:(CTFrameParserConfig *)config
								  height:(CGFloat)height {
	CGMutablePathRef path = CGPathCreateMutable();
	CGPathAddRect(path, NULL, CGRectMake(0, 0, config.width, height));
	CTFrameRef frameRef = CTFramesetterCreateFrame(frameSetter, CFRangeMake(0, 0), path, NULL);
	CFRelease(path);
	return frameRef;
}

@end
