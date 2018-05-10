//
//  CTFrameParser.m
//  CoreTextLearn
//
//  Created by Liang on 2018/5/10.
//  Copyright © 2018年 Liang. All rights reserved.
//

#import "CTFrameParser.h"
#import "CTAttributeFactory.h"
#import "CTFrameParserConfig.h"

@implementation CTFrameParser

+ (CoreTextData *)parseAttributeContent:(NSAttributedString *)attributeString
								 config:(CTFrameParserConfig *)config {
	CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)attributeString);
	// 计算绘制Sting所需要的区域
	CGSize restrictSize = CGSizeMake(config.width, CGFLOAT_MAX);		// 最大Size
	CGSize practicalSize = CTFramesetterSuggestFrameSizeWithConstraints(framesetter, CFRangeMake(0, 0), NULL, restrictSize, NULL);
	CGFloat contentHeight = practicalSize.height;
	// 创建frame
	CTFrameRef frame = [self createFrameWithFrameSetter:framesetter config:config height:contentHeight];
	// 将生成好的CTFrame实例和计算好的绘制高度保存到CoreTextData中
	CoreTextData *coreTextData = [[CoreTextData alloc] init];
	coreTextData.ctFrame = frame;
	coreTextData.height = contentHeight;
	coreTextData.attributeContent = attributeString;
	// 释放内存
	CFRelease(frame);
	CFRelease(framesetter);
	
	return coreTextData;
}

+ (CoreTextData *)parseContent:(NSString *)content config:(CTFrameParserConfig *)config {
	NSDictionary *attributes = [CTAttributeFactory attributesWithConfigure:config];
	NSAttributedString *contentString = [[NSAttributedString alloc] initWithString:content
																		attributes:attributes];
	return [self parseAttributeContent:contentString config:config];
}

+ (CTFrameRef)createFrameWithFrameSetter:(CTFramesetterRef)frameSetter
								  config:(CTFrameParserConfig *)config
								  height:(CGFloat)height {
	CGMutablePathRef path = CGPathCreateMutable();
	CGPathAddRect(path, NULL, CGRectMake(100, 0, config.width, height));
	CTFrameRef frameRef = CTFramesetterCreateFrame(frameSetter, CFRangeMake(0, 0), path, NULL);
	CFRelease(path);
	return frameRef;
}

@end
