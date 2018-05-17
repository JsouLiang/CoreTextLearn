//
//  CTDisplayView.m
//  CoreTextLearn
//
//  Created by Liang on 2018/5/10.
//  Copyright © 2018年 Liang. All rights reserved.
//

#import "CTDisplayView.h"
#import "CoreTextData.h"
#import "CoreTextImageData.h"
static NSString* const kEllipsesCharacter = @"\u2026";		// 省略号UTF-8编码

@implementation CTDisplayView

- (void)drawRect:(CGRect)rect {
	[super drawRect:rect];
	// [a, b, c, d, tx, ty]
	CGContextRef context = UIGraphicsGetCurrentContext();
	NSLog(@"转换前的坐标：%@",NSStringFromCGAffineTransform(CGContextGetCTM(context)));

	CGContextSetTextMatrix(context, CGAffineTransformIdentity);
	CGContextTranslateCTM(context, 0, rect.size.height);
	CGContextScaleCTM(context, 1, -1);
	NSLog(@"转换后的坐标：%@",NSStringFromCGAffineTransform(CGContextGetCTM(context)));
	
	
	
	[self drawStrokeWithContext:context rect:rect];
//	if (self.data) {
//		CTFrameDraw(self.data.ctFrame, context);
//	}
//
//	for (CoreTextImageData *data in self.data.images) {
//		UIImage *image = [UIImage imageNamed:data.imageName];
//		if (image) {
//			CGContextDrawImage(context, data.imagePosition, image.CGImage);
//		}
//	}
	
}

- (void)drawLines:(CTFrameRef)frame
		  context:(CGContextRef)context
  attributeString:(NSAttributedString *)attributeStr
	numberOfLines:(NSUInteger)lineNumber {
	CGPathRef path = CTFrameGetPath(frame);
	CGRect rect = CGPathGetBoundingBox(path);
	CFArrayRef lines = CTFrameGetLines(frame);
	CFIndex lineCount = CFArrayGetCount(lines);
	NSUInteger numberOfLines = lineNumber == 0 ? lineCount : lineNumber;
	
	CGPoint lineOrigins[numberOfLines];
	CTFrameGetLineOrigins(frame, CFRangeMake(0, 0), lineOrigins);
	for (CFIndex lineIndex = 0; lineIndex < numberOfLines; lineIndex++) {
		CGPoint lineOrigin = lineOrigins[lineIndex];
		CGContextSetTextPosition(context, lineOrigin.x, lineOrigin.y);
		
		CTLineRef currentLine = CFArrayGetValueAtIndex(lines, lineIndex);
		BOOL shouldDrawLine = YES;
		if (numberOfLines == lineIndex + 1) {		// 绘制到最后一行，绘制省略号
			CFRange lastLineRange = CTLineGetStringRange(currentLine);
			//
			if (lastLineRange.location + lastLineRange.length < (CFIndex)attributeStr.length) {
				CTLineTruncationType truncationType = kCTLineTruncationStart;
				NSUInteger truncationAttributePosition = lastLineRange.location + lastLineRange.length - 1;
				// 获取原字符串的属性
				NSDictionary *tokenAttributes = [attributeStr attributesAtIndex:truncationAttributePosition
																 effectiveRange:NULL];
				// 使用原字符串属性创建 ... 字符串
				NSAttributedString *tokenString = [[NSAttributedString alloc] initWithString:kEllipsesCharacter
																				  attributes:tokenAttributes];
				// ...  => CTLine
				CTLineRef truncationToken = CTLineCreateWithAttributedString((__bridge CFAttributedStringRef)tokenString);
				// 获取最后一行字符串
				NSMutableAttributedString *truncationString = [[attributeStr attributedSubstringFromRange:NSMakeRange(lastLineRange.location, lastLineRange.length)] mutableCopy];
				if (lastLineRange.length > 0) {
					// 获取最后一个字符
					unichar lastCharatcter = [[truncationString string] characterAtIndex:lastLineRange.length - 1];
					if ([[NSCharacterSet whitespaceAndNewlineCharacterSet] characterIsMember:lastCharatcter]) {
						// 将最后一行字符串最后一个字符删除
						[truncationString deleteCharactersInRange:NSMakeRange(lastLineRange.location,1)];
					}
				}
				// 追加 ...
				[truncationString appendAttributedString:tokenString];
				// 此时创建带有... 的字符串不一定能正常显示在一行，比如可能长度 > 一行的长度
				CTLineRef truncationLine = CTLineCreateWithAttributedString((__bridge CFAttributedStringRef)truncationString);
				CGContextSetTextPosition(context, lineOrigin.x, lineOrigin.y - 50);
				CTLineDraw(truncationLine, context);
				// 创建带有... 的CTLine，从一个带有省略号的trancationLine, 并指定最大宽度 react.size.width, 断行模式不足是从end开始删除
				CTLineRef truncatedLine = CTLineCreateTruncatedLine(truncationLine, rect.size.width, truncationType, truncationToken);
				
				if (!truncatedLine) {
					truncatedLine = CFRetain(truncationToken);
				}

				CFRelease(truncationLine);
				
				CGContextSetTextPosition(context, lineOrigin.x, lineOrigin.y);
				CTLineDraw(truncatedLine, context);
				
				CFRelease(truncationToken);
				CFRelease(truncatedLine);
				shouldDrawLine = NO;
			}
		}
		
		if (shouldDrawLine) {
			CTLineDraw(currentLine, context);
		}
	}
}


/**
 画出每行轮廓
 */
- (void)drawStrokeWithContext:(CGContextRef)context rect:(CGRect)rect{
	
	CGMutablePathRef path = CGPathCreateMutable();
	CGRect coreTextRect = CGRectMake(rect.origin.x,
									 rect.origin.y,
									 rect.size.width,
									 rect.size.height);
	CGPathAddRect(path, NULL, coreTextRect);
	// 绘制View轮廓
	CGContextSetLineWidth(context, 1.0);
	CGContextSetStrokeColorWithColor(context, UIColor.blueColor.CGColor);
	CGContextAddRect(context, rect);
	CGContextStrokePath(context);
	// 绘制CoreText 轮廓
	CGContextSetLineWidth(context, 2.0);
//	CGContextSetStrokeColorWithColor(context, UIColor.greenColor.CGColor);
	CGContextAddRect(context, coreTextRect);
	CGContextStrokePath(context);

	NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:@"CGMutablePathRefpath=CGPathCreateMutable();CGPathAddRect(path, NULL, self.bounds);NSMutableAttributedString*attributeString"];
	
	NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
	paragraphStyle.minimumLineHeight = 15;		// 控制行高
	paragraphStyle.maximumLineHeight = 20;
	paragraphStyle.lineSpacing = 10.f;
	[attributeString addAttributes:@{
									 NSFontAttributeName: [UIFont systemFontOfSize:17],
									 NSParagraphStyleAttributeName: paragraphStyle
									 }
							 range:NSMakeRange(0, attributeString.length)];
	
	CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)attributeString);
	CTFrameRef frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, 0), path, NULL);
	
//	CTFrameDraw(frame, context);
	[self drawByLine:frame context:context];
	
//	[self drawLines:frame context:context attributeString:attributeString numberOfLines:1];
	CFRelease(frame);
	CFRelease(framesetter);
}

- (void)drawByLine:(CTFrameRef)frame context:(CGContextRef)context{
	CFArrayRef lines = CTFrameGetLines(frame);
	CGPathRef path = CTFrameGetPath(frame);
	CFIndex lineCount = CFArrayGetCount(lines);
	CGPoint lineOrigins[lineCount];
	CTFrameGetLineOrigins(frame, CFRangeMake(0, 0), lineOrigins);
	CGContextSetStrokeColorWithColor(context, UIColor.redColor.CGColor);
	
	CGRect pathRect = CGPathGetBoundingBox(path);
	for (int index = 0; index < lineCount; index++) {
		CTLineRef line = CFArrayGetValueAtIndex(lines, index);
		CGPoint lineOrigin = lineOrigins[index];			// 获得行远点
		NSLog(@"Line Origin: (x: %f, y: %f) ",lineOrigins[index].x, lineOrigins[index].y);

		CFRange lastLineRange = CTLineGetStringRange(line);
		NSLog(@"Current Line Range: (location: %f, length: %f)", (float)lastLineRange.location, (float)lastLineRange.length);
		
		CGFloat lineAscent, lineDescent, lineLeading; // leading 行距
		CGFloat lineWidth = CTLineGetTypographicBounds(line, &lineAscent, &lineDescent, &lineLeading);
		CGRect lineBoundBox = (CGRect){
										lineOrigin.x + pathRect.origin.x,
//									    self.frame.size.height + (lineOrigin.y - pathRect.size.height),
										lineOrigin.y - lineDescent  ,
										lineWidth,
										lineAscent + lineDescent + lineLeading
		};
		CGContextSetTextPosition(context, lineOrigin.x + pathRect.origin.x,
//								 self.fxrame.size.height + (lineOrigin.y - pathRect.size.height));
								 lineOrigin.y);
		
		CGContextAddRect(context, lineBoundBox);
		CGContextStrokePath(context);
		
		CTLineDraw(line, context);
	}
}

@end
