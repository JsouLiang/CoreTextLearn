//
//  CTDisplayView.m
//  CoreTextLearn
//
//  Created by Liang on 2018/5/10.
//  Copyright © 2018年 Liang. All rights reserved.
//

#import "CTDisplayView.h"
#import <CoreText/CoreText.h>

@implementation CTDisplayView

- (void)drawRect:(CGRect)rect {
	[super drawRect:rect];
	// 1. 获取当前绘制画布上下文，后续内容会绘制到该画布上
	CGContextRef context = UIGraphicsGetCurrentContext();
	// 2. 翻转坐标系
	CGContextSetTextMatrix(context, CGAffineTransformIdentity);
	CGContextTranslateCTM(context, 0, self.bounds.size.height);
	CGContextScaleCTM(context, 1, -1);
	// 3. 创建CoreText的排版区域，
	CGMutablePathRef path = CGPathCreateMutable();
	// 这里将UIView整个界面作为排版区域
	 CGPathAddRect(path, NULL, self.bounds);
	// 创建一个圆形的排版区间
	// CGPathAddEllipseInRect(path, NULL, self.bounds);
	// 4.
	NSAttributedString *string = [[NSAttributedString alloc] initWithString:@"Hello World! "
								  " 创建绘制的区域，CoreText 本身支持各种文字排版的区域，"
								  " 我们这里简单地将 UIView 的整个界面作为排版的区域。"
								  " 为了加深理解，建议读者将该步骤的代码替换成如下代码，"
								  " 测试设置不同的绘制区域带来的界面变化。"];;
	CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)string);
	CTFrameRef frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, 0), path, NULL);
	// 5.
	CTFrameDraw(frame, context);
	// 6.
	CFRelease(frame);
	CFRelease(path);
	CFRelease(framesetter);
	
}

@end
