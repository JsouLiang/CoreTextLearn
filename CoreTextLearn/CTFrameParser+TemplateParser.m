//
//  CTFrameParser+TemplateLoad.m
//  CoreTextLearn
//
//  Created by Liang on 2018/5/10.
//  Copyright © 2018年 Liang. All rights reserved.
//

#import "CTFrameParser+TemplateParser.h"
#import "CTAttributeFactory.h"
#import "CoreTextImageData.h"

@implementation CTFrameParser (TemplateParser)


static CGFloat ascentCallBack(void *ref) {
	return [(NSNumber *)[(__bridge NSDictionary*)ref objectForKey:@"height"] floatValue];
}

static CGFloat descentCallBack(void *ref) {
	return 0;
}

static CGFloat widthCallBack(void *ref) {
	return [(NSNumber *)[(__bridge NSDictionary*)ref objectForKey:@"width"] floatValue];
}


+ (CoreTextData *)parseTemplateFile:(NSString *)path config:(CTFrameParserConfig *)config {
	NSMutableArray *images = [NSMutableArray array];
	NSAttributedString *content = [self loadTemplateFile:path config:config images:images];
	CoreTextData *coreTextData = [self parseAttributeContent:content config:config];
	coreTextData.images = images;
	return coreTextData;
}

+ (NSMutableAttributedString *)loadTemplateFile:(NSString *)path
										 config:(CTFrameParserConfig *)config
										 images:(NSMutableArray *)images {
	NSData *data = [NSData dataWithContentsOfFile:path];
	NSMutableAttributedString *mutableAttributeStr = [[NSMutableAttributedString alloc] init];
	if (data) {
		NSArray *array = [NSJSONSerialization JSONObjectWithData:data
														 options:NSJSONReadingAllowFragments
														   error:nil];
		if ([array isKindOfClass:[NSArray class]]) {
			for (NSDictionary *dict in array) {
				NSString *type = dict[@"type"];			// 获得当前这部分富文本的类型
				if ([type isEqualToString:@"txt"]) {
					NSAttributedString *attributeStr = [self parseAttributedContentFromNSDictionary:dict
																							 config:config];
					[mutableAttributeStr appendAttributedString:attributeStr];
				} else if ([type isEqualToString:@"img"]) {
					CoreTextImageData *imageData = [[CoreTextImageData alloc] init];
					imageData.imageName = dict[@"name"];
					imageData.position = mutableAttributeStr.length;
					[images addObject:imageData];
					// 创建空的占位符
					NSMutableAttributedString *attributeStr = [self parseImageDataFromNSDictionary:dict config:config];
					[mutableAttributeStr appendAttributedString:attributeStr];
				}
			}
		}
	}
	return mutableAttributeStr;
}

+ (NSMutableAttributedString *)parseImageDataFromNSDictionary:(NSDictionary *)dict config:(CTFrameParserConfig *)config {
	NSMutableDictionary *attributes = [[CTAttributeFactory attributesWithConfigure:config] mutableCopy];
	
	// CTRun 通过指定CTRun的delegate来指定CTRun的宽高，对齐方式
	CTRunDelegateCallbacks callbacks;
	memset(&callbacks, 0, sizeof(CTRunDelegateCallbacks));
	callbacks.version = kCTRunDelegateVersion1;
	callbacks.getAscent = ascentCallBack;
	callbacks.getDescent = descentCallBack;
	callbacks.getWidth = widthCallBack;
	
	CTRunDelegateRef delegate = CTRunDelegateCreate(&callbacks, (__bridge void * _Nullable)(dict));
	// 使用OXFFC作为图片的占位符
	unichar objectReplacemenetChar = 0xFFFC;
	NSString *content = [NSString stringWithCharacters:&objectReplacemenetChar length:1];
	NSMutableAttributedString *space = [[NSMutableAttributedString alloc] initWithString:content
																			  attributes:attributes];
	// 为AttributeStringRef设置指定属性kCTRunDelegate 的值delegate
	CFAttributedStringSetAttribute((CFMutableAttributedStringRef)space, CFRangeMake(0, 1), kCTRunDelegateAttributeName, delegate);
	CFRelease(delegate);
	
	return space;
}

+ (NSAttributedString *)parseAttributedContentFromNSDictionary:(NSDictionary *)dict
														config:(CTFrameParserConfig *)config {
	NSMutableDictionary *attributes = [[CTAttributeFactory attributesWithConfigure:config] mutableCopy];
	// color
	UIColor *color = [self colorFromTemplate:dict[@"color"]];
	if (color) {
		attributes[(id)kCTForegroundColorAttributeName] = (id)color.CGColor;
	}
	// font
	CGFloat fontSize = [dict[@"size"] floatValue];
	if (fontSize > 0) {
		CTFontRef fontRef = CTFontCreateWithName((CFStringRef)@"ArialMT", fontSize, NULL);
		[attributes setObject:(id)kCTFontAttributeName forKey:(__bridge id)fontRef];
		CFRelease(fontRef);
	}
	return [[NSAttributedString alloc] initWithString:dict[@"content"] attributes:attributes];
}

+ (UIColor *)colorFromTemplate:(NSString *)name {
	if ([name isEqualToString:@"blue"]) {
		return [UIColor blueColor];
	} else if ([name isEqualToString:@"red"]) {
		return [UIColor redColor];
	} else if ([name isEqualToString:@"black"]) {
		return [UIColor blackColor];
	} else {
		return nil;
	}
}



@end
