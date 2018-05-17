//
//  CoreTextData.m
//  CoreTextLearn
//
//  Created by Liang on 2018/5/10.
//  Copyright © 2018年 Liang. All rights reserved.
//

#import "CoreTextData.h"
#import "CoreTextImageData.h"

@implementation CoreTextData

- (void)setCtFrame:(CTFrameRef)ctFrame {
	if (_ctFrame != ctFrame) {
		if (_ctFrame != NULL) {
			CFRelease(_ctFrame);
		}
		CFRetain(ctFrame);
		_ctFrame = ctFrame;
	}
}

- (void)setImages:(NSArray *)images {
	_images = [images copy];
	[self fillImagePosition];
}

/**
 找到每张图片在绘制时所在的位置
 hahalkwfe hiahoieh
 */
- (void)fillImagePosition {
	if (self.images.count == 0) {
		return;
	}
	// CTLine 数组
	NSArray *lines = (NSArray*)CTFrameGetLines(_ctFrame);
	NSUInteger lineCount = lines.count;
	CGPoint lineOrigins[lineCount];			// 记录每行的起点
	CTFrameGetLineOrigins(_ctFrame, CFRangeMake(0, 0), lineOrigins);
	
	int imageIndex = 0;
	CoreTextImageData *imageData = self.images[0];
	for (int i = 0; i < lineCount; i++) {			// 遍历每行(遍历CTLine数组)
		// Line
		CTLineRef line = (__bridge CTLineRef)lines[i];
		NSLog(@"Line Origin: (x: %f, y: %f) ",lineOrigins[i].x, lineOrigins[i].y);
//		CGFloat lineAscent, lineDescent, lineLeading;
//		CGFloat lineWidth = CTLineGetTypographicBounds(line, &lineAscent, &lineDescent, &lineLeading);
		
		if (!imageData) {
			break ;
		}
		
		// 获取该行中所有的 CTRun: CTRun 是一组相同Attribute的字符的合集，CoreText绘制的最小单位
		NSArray *runs = (NSArray *)CTLineGetGlyphRuns(line);
		for (id runObj in runs) {
			CTRunRef run = (__bridge CTRunRef)runObj;
			// 获得该CTRun对应的Attribute
			NSDictionary *runAttributes = (NSDictionary *)CTRunGetAttributes(run);
			CTRunDelegateRef runDelegate = (__bridge CTRunDelegateRef)[runAttributes valueForKey:(id)kCTRunDelegateAttributeName];
			if (!runDelegate) {		// 因为只有图片设置的delegate
				continue;
			}
			NSDictionary *metaDic = CTRunDelegateGetRefCon(runDelegate);
			if (![metaDic isKindOfClass:[NSDictionary class]]) {
				continue;
			}
			
			CGRect runBounds; CGFloat ascent; CGFloat descent;
			runBounds.size.width = CTRunGetTypographicBounds(run, CFRangeMake(0, 0), &ascent, &descent, NULL);
			runBounds.size.height = ascent + descent;
			
			CGFloat xOffset = CTLineGetOffsetForStringIndex(line, CTRunGetStringRange(run).location, NULL);
			runBounds.origin.x = lineOrigins[i].x + xOffset;
			runBounds.origin.y = lineOrigins[i].y;
			runBounds.origin.y -= descent;
			
			CGPathRef pathRef = CTFrameGetPath(self.ctFrame);
			CGRect colRect = CGPathGetBoundingBox(pathRef);
			// 这里需要与创建Path的Rect做下偏移, 防止设置的path不是从(0,0)点设置的
			CGRect delegateBounds = CGRectOffset(runBounds, colRect.origin.x, colRect.origin.y);
			imageData.imagePosition = delegateBounds;
//			imageData.imagePosition = runBounds;
			imageIndex++;
			if (imageIndex == self.images.count) {
				imageData = nil;
				break;
			} else {
				imageData = self.images[imageIndex];
			}
		}
	}
}


- (void)dealloc {
	if (_ctFrame != NULL) {
		CFRelease(_ctFrame);
		_ctFrame = NULL;
	}
}

@end
