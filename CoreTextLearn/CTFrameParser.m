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
//static NSString* const kEllipsesCharacter = @"\u2026";		// 省略号UTF-8编码

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

//+ (void)drawByLines:(CTFrameRef)frame attributeString:(NSAttributedString *)attributeStr config:(CTFrameParserConfig *)config {
//	CGPathRef path = CTFrameGetPath(frame);
//	CGRect rect = CGPathGetBoundingBox(path);
//	CFArrayRef lines = CTFrameGetLines(frame);
//	CFIndex lineCount = CFArrayGetCount(lines);
//	NSUInteger numberOfLines = config.numberOfLines == 0 ? lineCount : config.numberOfLines;
//	
//	CGPoint lineOrigins[numberOfLines];
//	CTFrameGetLineOrigins(frame, CFRangeMake(0, 0), lineOrigins);
//	for (CFIndex lineIndex = 0; lineIndex < numberOfLines; lineIndex++) {
//		CGPoint lineOrigin = lineOrigins[lineIndex];
//		CGContextSetTextPosition(UIGraphicsGetCurrentContext(), lineOrigin.x, lineOrigin.y);
//		
//		CTLineRef currentLine = CFArrayGetValueAtIndex(lines, lineIndex);
//		BOOL shouldDrawLine = YES;
//		if (numberOfLines == lineIndex + 1) {		// 绘制到最后一行，绘制省略号
//			CFRange lastLineRange = CTLineGetStringRange(currentLine);
//			if (lastLineRange.location + lastLineRange.length < (CFIndex)attributeStr.length) {
//				CTLineTruncationType truncationType = kCTLineTruncationEnd;
//				NSUInteger truncationAttributePosition = lastLineRange.location + lastLineRange.length - 1;
//				
//				NSDictionary *tokenAttributes = [attributeStr attributesAtIndex:truncationAttributePosition
//																 effectiveRange:NULL];
//				NSAttributedString *tokenString = [[NSAttributedString alloc] initWithString:kEllipsesCharacter
//																				  attributes:tokenAttributes];
//				CTLineRef truncationToken = CTLineCreateWithAttributedString((__bridge CFAttributedStringRef)tokenString);
//				NSMutableAttributedString *truncationString = [[attributeStr attributedSubstringFromRange:NSMakeRange(lastLineRange.location, lastLineRange.length)] mutableCopy];
//				if (lastLineRange.length > 0) {
//					// 获取最后一个字符
//					unichar lastCharatcter = [[truncationString string] characterAtIndex:lastLineRange.length - 1];
//					if ([[NSCharacterSet whitespaceAndNewlineCharacterSet] characterIsMember:lastCharatcter]) {
//						[truncationString deleteCharactersInRange:NSMakeRange(lastLineRange.location,1)];
//					}
//				}
//				[truncationString appendAttributedString:tokenString];
//				
//				CTLineRef truncationLine = CTLineCreateWithAttributedString((__bridge CFAttributedStringRef)truncationString);
////				CTLineRef truncaedLine = CTLineCreateTruncatedLine(truncationLine, <#double width#>, truncationType, truncationToken);
//				
//			}
//		}
//		
//		if (shouldDrawLine) {
//			CTLineDraw(currentLine, UIGraphicsGetCurrentContext());
//		}
//	}
//}

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
